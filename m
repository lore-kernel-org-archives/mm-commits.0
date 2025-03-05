Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB91A2E3365
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741218061; cv=none; b=R0m9yAQh2Zk7exmHefvMEENCv+6NA/i+35x3IHldrP6f1OmwioHDQkP/YMQqdNT5xfhFusbOnAhvAk8EsFKxB70QktmJKBNg+brpNsCBuKHquqWLS9/Edpumpk5v68IL3ZxnSbQls04aJYTS/ITEZZvp9dlzlxf0bQPwXD1GhFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741218061; c=relaxed/simple;
	bh=Z378eG6cVfQ14PjMcAygN3A9UjXh0KYjz4Gk1DKOV2Y=;
	h=Date:To:From:Subject:Message-Id; b=miBxYkUeNv0dnRUyHRVLIO1ljoXYs3/ky2dDblI2/Ciin4oFLjJsZltThOrge4TvpAlHzt2T1ddDe0/HrmSJApTI1SvwyGd5kZ7N5leoalEk50TKErDDUFCzH3XEGHHknPn2MDxH92eS/8GC+zDZua6s60SOVlw2vpP+GpIMxyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uozvIHPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uozvIHPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0F2C4CED1;
	Wed,  5 Mar 2025 23:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741218060;
	bh=Z378eG6cVfQ14PjMcAygN3A9UjXh0KYjz4Gk1DKOV2Y=;
	h=Date:To:From:Subject:From;
	b=uozvIHPT0yKZAqHzjsHI58VO+uKPmq/hCeLJMJP8ZNbH7zsCaO0XpqDzdHdC5a7zM
	 kfYf/nC2eFJ+kMoMCNBCIJoeHCIJmVcXauq5eVtTxSs7OeSLUgo+3YJjq2FflYM+Yk
	 icgI8NNlD4aTyZk7bEM1bUMUFJrqTVX8F32x1Pls=
Date: Wed, 05 Mar 2025 15:40:59 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-update-nr_huge_pages-and-surplus_huge_pages-together.patch added to mm-unstable branch
Message-Id: <20250305234100.3F0F2C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: update nr_huge_pages and surplus_huge_pages together
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-update-nr_huge_pages-and-surplus_huge_pages-together.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-update-nr_huge_pages-and-surplus_huge_pages-together.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/hugetlb: update nr_huge_pages and surplus_huge_pages together
Date: Wed, 5 Mar 2025 11:54:09 +0800

In alloc_surplus_hugetlb_folio(), we increase nr_huge_pages and
surplus_huge_pages separately.  In the middle window, if we set
nr_hugepages to smaller and satisfy count < persistent_huge_pages(h), the
surplus_huge_pages will be increased by adjust_pool_surplus().

After adding delay in the middle window, we can reproduce the problem
easily by following step:

 1. echo 3 > /proc/sys/vm/nr_overcommit_hugepages
 2. mmap two hugepages. When nr_huge_pages=2 and surplus_huge_pages=1,
    goto step 3.
 3. echo 0 > /proc/sys/vm/nr_huge_pages

Finally, nr_huge_pages is less than surplus_huge_pages.

To fix the problem, call only_alloc_fresh_hugetlb_folio() instead and
move down __prep_account_new_huge_page() into the hugetlb_lock.

Link: https://lkml.kernel.org/r/20250305035409.2391344-1-liushixin2@huawei.com
Fixes: 0c397daea1d4 ("mm, hugetlb: further simplify hugetlb allocation API")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-update-nr_huge_pages-and-surplus_huge_pages-together
+++ a/mm/hugetlb.c
@@ -2259,12 +2259,21 @@ static struct folio *alloc_surplus_huget
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
 	if (!folio)
 		return NULL;
 
+	hugetlb_vmemmap_optimize_folio(h, folio);
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
+	 * nr_huge_pages needs to be adjusted within the same lock cycle
+	 * as surplus_pages, otherwise it might confuse
+	 * persistent_huge_pages() momentarily.
+	 */
+	__prep_account_new_huge_page(h, nid);
+
+	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
 	 * if we would end up overcommiting the surpluses. Abuse
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch
mm-hugetlb-update-nr_huge_pages-and-surplus_huge_pages-together.patch

