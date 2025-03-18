Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116A51C701D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274566; cv=none; b=G8uzIFypLYZKJn8RUD57QMJHRftkHtSRnTchszGLD6FSD2WRc0XzWKRHoti5hcO2kQS9V3i0OXEwFkAdBA7FVbTdmfpHEd+F/wtCkA258saS1vBzTeFc1gN1ODPq5bTFRi9gFbCxrvoFGUZsTht36kIdHoJAbL82n6N/vGLfD+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274566; c=relaxed/simple;
	bh=KzhpRLua7bwkoZN88c3icSHwrM0nEShnE4+sdzSQTVc=;
	h=Date:To:From:Subject:Message-Id; b=P4a3RTBqZ9cyVwtZrwdzNs354ZUSaw66lhJKGJmBp7YkyvnHKrLx2J7z4abldAkOeASBlyjTrns8n2+99zZhXTvzesxZ5Xr9C3WJIjdCnLRIFHgoZkhHXgk80E05teiFdou1pJXg/xzJnzr+Fs56nqMEa8SDi+s1Ad8opGYTH5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hhdey6lA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hhdey6lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA55EC4CEDD;
	Tue, 18 Mar 2025 05:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274565;
	bh=KzhpRLua7bwkoZN88c3icSHwrM0nEShnE4+sdzSQTVc=;
	h=Date:To:From:Subject:From;
	b=hhdey6lAfs2O20JGGX2yNuEC81CPuFyz1k/bCogXDbcHiavqD+aZS7/CuvNEJvBK2
	 aSngWccryr/+gwxXNO8wWCzy9Ri87sSn6z/ouW8XPy2NZUStU4DdhyS3vso1oYrdcq
	 9IgqIdE9EpkLVYflnBzITvOuJSbZH+JPF5LWe8io=
Date: Mon, 17 Mar 2025 22:09:25 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-update-nr_huge_pages-and-surplus_huge_pages-together.patch removed from -mm tree
Message-Id: <20250318050925.DA55EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: update nr_huge_pages and surplus_huge_pages together
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-update-nr_huge_pages-and-surplus_huge_pages-together.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
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

