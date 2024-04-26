Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0187F465
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104053; cv=none; b=rVBMkSgIa3MtOsIo2dGE9ksYpujDhCcuNQqSPhF1YNP7C6v2j3bdqzVi8T9sr+zmIYLmhi1NeGqfhj4kmEG2JVpXx1a350d4HPVdCF2RSIJS1KCQRTkkCyp8SvfA0fL2M9D6880cKEUgQQnTwVvIg7NvcrudAMrxXk7Pq61e/yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104053; c=relaxed/simple;
	bh=INh6fLeVFTA7a0lgqEbjzBCcAYD/fNxMekJsRT17CoU=;
	h=Date:To:From:Subject:Message-Id; b=P8yrnemB2tplBCogg+1DJCLQFAKXb1v/WtLt59ZWap8VOKEeCnlT/uymg6ycApvlROYthqphMf2/2MmJRNjrL1NQkpXR7oq9Taf0dr88meTtOfNHQRcYLwYK8TjNajywA80/DQjeR4Zgy8SD2adWPYhEZfVQBcc6MsU0ptqullQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0JA5uIB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0JA5uIB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3288C2BD11;
	Fri, 26 Apr 2024 04:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104053;
	bh=INh6fLeVFTA7a0lgqEbjzBCcAYD/fNxMekJsRT17CoU=;
	h=Date:To:From:Subject:From;
	b=0JA5uIB3Uu/cERAVxr6T5uGmD8hhBaQ2Cl+OwXIXTuIu//fgFUbqjcqYjmORNDvz5
	 9R3vhmv0lw+A60xOblLB7Xlf9SRoWUAx9/JKnkt6elK6OUXTMH+0klhx4wqSM6Zyhd
	 xgpV7NbVkFFCwgSgXc5NXIU3H1GFA+FHuzfoF1ns=
Date: Thu, 25 Apr 2024 21:00:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vma_pgtable_walk_beginend.patch removed from -mm tree
Message-Id: <20240426040053.A3288C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce vma_pgtable_walk_{begin|end}()
has been removed from the -mm tree.  Its filename was
     mm-introduce-vma_pgtable_walk_beginend.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce vma_pgtable_walk_{begin|end}()
Date: Wed, 27 Mar 2024 11:23:23 -0400

Introduce per-vma begin()/end() helpers for pgtable walks.  This is a
preparation work to merge hugetlb pgtable walkers with generic mm.

The helpers need to be called before and after a pgtable walk, will start
to be needed if the pgtable walker code supports hugetlb pages.  It's a
hook point for any type of VMA, but for now only hugetlb uses it to
stablize the pgtable pages from getting away (due to possible pmd
unsharing).

Link: https://lkml.kernel.org/r/20240327152332.950956-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/memory.c        |   12 ++++++++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/mm.h~mm-introduce-vma_pgtable_walk_beginend
+++ a/include/linux/mm.h
@@ -4230,4 +4230,7 @@ static inline bool pfn_is_unaccepted_mem
 	return range_contains_unaccepted_memory(paddr, paddr + PAGE_SIZE);
 }
 
+void vma_pgtable_walk_begin(struct vm_area_struct *vma);
+void vma_pgtable_walk_end(struct vm_area_struct *vma);
+
 #endif /* _LINUX_MM_H */
--- a/mm/memory.c~mm-introduce-vma_pgtable_walk_beginend
+++ a/mm/memory.c
@@ -6378,3 +6378,15 @@ void ptlock_free(struct ptdesc *ptdesc)
 	kmem_cache_free(page_ptl_cachep, ptdesc->ptl);
 }
 #endif
+
+void vma_pgtable_walk_begin(struct vm_area_struct *vma)
+{
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_vma_lock_read(vma);
+}
+
+void vma_pgtable_walk_end(struct vm_area_struct *vma)
+{
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_vma_unlock_read(vma);
+}
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

