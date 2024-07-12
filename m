Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDC512EBF5;
	Fri, 12 Jul 2024 22:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824907; cv=none; b=XnWzEWOjFh0aAM83yIeH3ZyZH7FYuiE8B8PPlG3a5ppUzhFCWa1Z3yEkCUu/H2z/Lp23XEp9Rrq46IAu5dkAK3Xgrd0Wvxc9egbIr9NOLxe6KHvkjrutCCTBwSZvt9ocEbsX64wOgInw1vMP28Um2rOQ6DUwLtEYc3dcPRCRpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824907; c=relaxed/simple;
	bh=rZ7eTq6piSjZSl3TMYsnSoqxST7wMx/oma0crEcOp4w=;
	h=Date:To:From:Subject:Message-Id; b=KrRJqbBTu/aCarnSf1L8Vb0q011w9CWxhidIOLlZ1WXE1pxXMTnJKAudlmNNzSFjMcAAkuiEg8T+gykkPFnYTr1G2bLU/C6YPKG48VsDqbpd4R3V5W3AJgGQrh5E/C3qTbxNA/WR1lTSxYggmHU7dMfNH1RM0Cm/+p/ENCUJXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PjMsScNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PjMsScNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FFEC32782;
	Fri, 12 Jul 2024 22:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824907;
	bh=rZ7eTq6piSjZSl3TMYsnSoqxST7wMx/oma0crEcOp4w=;
	h=Date:To:From:Subject:From;
	b=PjMsScNMW6jYREazUPMTmjTxV/PmdCHScWeoovjhQsDADpjzThI38N7SJJjVx93S8
	 4ks2Wn9K1SpMUughhz8fX2j6euGrT+SoEcQ1RaFoyqyGYUqhsOdJIvUG3zdkarM9gU
	 zRtpI87BZV0TLkDt3hV95lfszch8fDozX5zQac9o=
Date: Fri, 12 Jul 2024 15:55:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-potential-race-with-try_memory_failure_hugetlb.patch removed from -mm tree
Message-Id: <20240712225507.63FFEC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix potential race with try_memory_failure_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-potential-race-with-try_memory_failure_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential race with try_memory_failure_hugetlb()
Date: Wed, 10 Jul 2024 16:14:45 +0800

There is a potential race between __update_and_free_hugetlb_folio() and
try_memory_failure_hugetlb():

 CPU1					CPU2
 __update_and_free_hugetlb_folio	try_memory_failure_hugetlb
  					 spin_lock_irq(&hugetlb_lock);
					 __get_huge_page_for_hwpoison
					  folio_test_hugetlb
					  -- It's still hugetlb folio.
  folio_test_hugetlb_raw_hwp_unreliable
  -- raw_hwp_unreliable flag is not set yet.
					  folio_set_hugetlb_hwpoison
					  -- raw_hwp_unreliable flag might
					     be set.
					 spin_unlock_irq(&hugetlb_lock);
  spin_lock_irq(&hugetlb_lock);
  __folio_clear_hugetlb(folio);
   -- Hugetlb flag is cleared but too late!
  spin_unlock_irq(&hugetlb_lock);

When this race occurs, raw error pages will hit pcplists/buddy.  Fix this
issue by deferring folio_test_hugetlb_raw_hwp_unreliable() until
__folio_clear_hugetlb() is done.  The raw_hwp_unreliable flag cannot be
set after hugetlb folio flag is cleared.

Link: https://lkml.kernel.org/r/20240710081445.3307355-1-linmiaohe@huawei.com
Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-race-with-try_memory_failure_hugetlb
+++ a/mm/hugetlb.c
@@ -1706,13 +1706,6 @@ static void __update_and_free_hugetlb_fo
 		return;
 
 	/*
-	 * If we don't know which subpages are hwpoisoned, we can't free
-	 * the hugepage, so it's leaked intentionally.
-	 */
-	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
-		return;
-
-	/*
 	 * If folio is not vmemmap optimized (!clear_flag), then the folio
 	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
 	 * can only be passed hugetlb pages and will BUG otherwise.
@@ -1730,6 +1723,13 @@ static void __update_and_free_hugetlb_fo
 	}
 
 	/*
+	 * If we don't know which subpages are hwpoisoned, we can't free
+	 * the hugepage, so it's leaked intentionally.
+	 */
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+		return;
+
+	/*
 	 * Move PageHWPoison flag from head page to the raw error pages,
 	 * which makes any healthy subpages reusable.
 	 */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-vm_bug_on_pagepagepoisonedpage-when-unpoison-memory.patch
mm-hugetlb-fix-possible-recursive-locking-detected-warning.patch

