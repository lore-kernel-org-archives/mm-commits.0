Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E327E576
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104051; cv=none; b=tznhmXUUKlrwnh4MvgCKGw+3BbTdF1xa/LEAmZYOfDYfoDxQdCyv687RLUvaYrq1QQHu/YzpAPKPIZIpe2Wdzldo/cMNsvVV2GtDNtDepgk94QdyzkbHc2nIdN1RoGXgVXsYrKcrQ77E8ZgKQYSNeNYMAfPnf3Kppm5bpd6go6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104051; c=relaxed/simple;
	bh=BfdzuPAr1Liqj8TqxA5HpbHRp3jxMFtImxvmPNzRttQ=;
	h=Date:To:From:Subject:Message-Id; b=NFfkM6EMIYMUR0yQhGRgsioWirqI52xFWFkHWeFNk4dO5BSZDvBTundrj1PqY7TQGlD4i3R53vI6+yFEeUJWf4/s2y6vHhyUSzPs/U1R2HX70uRrran/xXnz6U4uSs/Fhs++mY1Q01hUR6nKQHCzu0wudzy3P7JcHhY2C8byep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lSWa76jB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lSWa76jB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB52C113CD;
	Fri, 26 Apr 2024 04:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104050;
	bh=BfdzuPAr1Liqj8TqxA5HpbHRp3jxMFtImxvmPNzRttQ=;
	h=Date:To:From:Subject:From;
	b=lSWa76jBU/upzKJ/u2GTLH/TPuI1MowveNRM+Rx+RJUXreEmTXefMuK5KBiGyqaFc
	 Re+H8na+Cd1+m+DNFuX2shdZdAMnLXPueT3g5+xXjZ0YxwNxg5xmIebD6XyL8XB3YE
	 dn7o7lVBwZQftqLANOUKAQVhx027rwbMZS+Mkp1M=
Date: Thu, 25 Apr 2024 21:00:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch removed from -mm tree
Message-Id: <20240426040050.BBB52C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: declare hugetlbfs_pagecache_present() non-static
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: declare hugetlbfs_pagecache_present() non-static
Date: Wed, 27 Mar 2024 11:23:21 -0400

It will be used outside hugetlb.c soon.

Link: https://lkml.kernel.org/r/20240327152332.950956-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    9 +++++++++
 mm/hugetlb.c            |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static
+++ a/include/linux/hugetlb.h
@@ -174,6 +174,9 @@ u32 hugetlb_fault_mutex_hash(struct addr
 
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud);
+bool hugetlbfs_pagecache_present(struct hstate *h,
+				 struct vm_area_struct *vma,
+				 unsigned long address);
 
 struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
 
@@ -1228,6 +1231,12 @@ static inline void hugetlb_register_node
 static inline void hugetlb_unregister_node(struct node *node)
 {
 }
+
+static inline bool hugetlbfs_pagecache_present(
+    struct hstate *h, struct vm_area_struct *vma, unsigned long address)
+{
+	return false;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c~mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static
+++ a/mm/hugetlb.c
@@ -6113,8 +6113,8 @@ out_release_old:
 /*
  * Return whether there is a pagecache page to back given address within VMA.
  */
-static bool hugetlbfs_pagecache_present(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long address)
+bool hugetlbfs_pagecache_present(struct hstate *h,
+				 struct vm_area_struct *vma, unsigned long address)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	pgoff_t idx = linear_page_index(vma, address);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

