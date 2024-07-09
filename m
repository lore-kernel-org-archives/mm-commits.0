Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D707CF18;
	Tue,  9 Jul 2024 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720564913; cv=none; b=LnJhd6nFUEojzEfmpSaHMkgZxctljGiAD4+24RS6kga0i6rIsB426WnnGxo4LaM9pEdH7AhQ6H/q2KN+RunwBTmuYuNNOvv1JDqLd9URwXdePv2ebOMnzws3u4vg6MsJzeZoDyNI6uIjGPCi6Wzlbf1sFilTnJTayauqyWs/XLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720564913; c=relaxed/simple;
	bh=cCJX5jp/wnF4JfyNE/u6ypC5s10f5KN75fWZULAVZTw=;
	h=Date:To:From:Subject:Message-Id; b=VVVtRK3dERRJZ3Vkp27z0iGW8+Cmu9U8CCsgsWmJtkuDTIQeR5SAuiznPjAU90TZ6R9pjwT/+UrUoXGGaqMwrzzs9PFrJj5HqoycR+t5ChLbjaOsvQB9OB5TnoajwoG07ULBik0Hz1lnqmQTH/c4N0I6K7MPfwDaWydUnj5tgcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sqf6RlL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sqf6RlL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8B9C32786;
	Tue,  9 Jul 2024 22:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720564913;
	bh=cCJX5jp/wnF4JfyNE/u6ypC5s10f5KN75fWZULAVZTw=;
	h=Date:To:From:Subject:From;
	b=Sqf6RlL7wi0dOz9YZDDlv2mSVYTgCc1qjHSpisl0XLP7UQVZ6ji2S3/bQXJjoTY0y
	 hy7XCix37nVMQDv92nviSO4QwHlL/aa5menBahacB/qz4h/GKCXcL2DKS8w+L68QdK
	 bA/78VHNW4AgSEL3nXOtO7aIH+azcuj1tLEJdeu8=
Date: Tue, 09 Jul 2024 15:41:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio.patch removed from -mm tree
Message-Id: <20240709224153.1E8B9C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix potential race in __update_and_free_hugetlb_folio()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential race in __update_and_free_hugetlb_folio()
Date: Mon, 8 Jul 2024 10:51:27 +0800

There is a potential race between __update_and_free_hugetlb_folio() and
try_memory_failure_hugetlb():

 CPU1					CPU2
 __update_and_free_hugetlb_folio	try_memory_failure_hugetlb
					 folio_test_hugetlb
					  -- It's still hugetlb folio.
  folio_clear_hugetlb_hwpoison
  					  spin_lock_irq(&hugetlb_lock);
					   __get_huge_page_for_hwpoison
					    folio_set_hugetlb_hwpoison
					  spin_unlock_irq(&hugetlb_lock);
  spin_lock_irq(&hugetlb_lock);
  __folio_clear_hugetlb(folio);
   -- Hugetlb flag is cleared but too late.
  spin_unlock_irq(&hugetlb_lock);

When the above race occurs, raw error page info will be leaked.  Even
worse, raw error pages won't have hwpoisoned flag set and hit
pcplists/buddy.  Fix this issue by deferring
folio_clear_hugetlb_hwpoison() until __folio_clear_hugetlb() is done.  So
all raw error pages will have hwpoisoned flag set.

Link: https://lkml.kernel.org/r/20240708025127.107713-1-linmiaohe@huawei.com
Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1726,13 +1726,6 @@ static void __update_and_free_hugetlb_fo
 	}
 
 	/*
-	 * Move PageHWPoison flag from head page to the raw error pages,
-	 * which makes any healthy subpages reusable.
-	 */
-	if (unlikely(folio_test_hwpoison(folio)))
-		folio_clear_hugetlb_hwpoison(folio);
-
-	/*
 	 * If vmemmap pages were allocated above, then we need to clear the
 	 * hugetlb flag under the hugetlb lock.
 	 */
@@ -1742,6 +1735,13 @@ static void __update_and_free_hugetlb_fo
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
+	/*
+	 * Move PageHWPoison flag from head page to the raw error pages,
+	 * which makes any healthy subpages reusable.
+	 */
+	if (unlikely(folio_test_hwpoison(folio)))
+		folio_clear_hugetlb_hwpoison(folio);
+
 	folio_ref_unfreeze(folio, 1);
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch

