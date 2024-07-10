Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB7134545;
	Wed, 10 Jul 2024 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633484; cv=none; b=S3+e9i9V5AvoS5Rwz3AaRYzJIh5v/TAfxKmEUx0qxrVR18fITFiiTjPXffSphA4D9oouJGZz5qvzhKy2OIRKxuhqs7Lcu3qr8jYRw8cBNl0zpjpicob23zeTGWHpC39MiGRzMeJaNE9OfEaGstqDuyYL483RGq8pebc4Ni1JzVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633484; c=relaxed/simple;
	bh=RnkaHQsJ0ervPT8vPQhoWskpBYWUQzQjoBOLZewZY6I=;
	h=Date:To:From:Subject:Message-Id; b=caAu22G3wzWwLJ3MBhtRSDjGiT1jnBsziIjD6x7lINnuhzpt9rZqLh4oEZbfi70r54JU35omTg3w2+tVun6ETFn/cjBP43Z/V1yZ1WsL948m181MD+7F+wgVNwtAaDwtUVBL4Hd2KIwtcekS52zXoslTp0W4jZf2aVBCR4D+u5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AMTqO5mR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AMTqO5mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E6BC32781;
	Wed, 10 Jul 2024 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720633484;
	bh=RnkaHQsJ0ervPT8vPQhoWskpBYWUQzQjoBOLZewZY6I=;
	h=Date:To:From:Subject:From;
	b=AMTqO5mRucpyjNqpmKxT9irq2aSm6mDkxQIUmFpawxnQqP6Ky10zaifjCyru1pTV9
	 55fDEu7/Jxm7OSMV3W+vc/2WTT4rZZWWCkLUjGEZouCVjEd3ptm3+9dF9swx9Ksu8U
	 yTe7ozN1KpqhMgpoa3Ky/ds3Mt6LyYkEqwVQBTiw=
Date: Wed, 10 Jul 2024 10:44:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-potential-race-with-try_memory_failure_hugetlb.patch added to mm-unstable branch
Message-Id: <20240710174444.36E6BC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix potential race with try_memory_failure_hugetlb()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-potential-race-with-try_memory_failure_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-potential-race-with-try_memory_failure_hugetlb.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch
mm-hugetlb-fix-potential-race-with-try_memory_failure_hugetlb.patch

