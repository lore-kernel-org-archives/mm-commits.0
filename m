Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EAE7F47B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104052; cv=none; b=tP+/hu25wDQp7UG8BcPxBJGKpnETgB8of8hzYmjfJwhr9SqyE/q6PRTudKtF9F5l/fMWL6d9DDtrP4mrhuojFOZlB6PIlW9qDodjUM6venr7tECizCqzh1XujPZ78iXYp5Cfqqu5DQnZ6wVlPZbaO1fwWHtuKAfi6yGF6zUkU6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104052; c=relaxed/simple;
	bh=pe/h2vf4VkzEeKj3G0gqSMKuE6HfwSIHWuii4Zq8OLY=;
	h=Date:To:From:Subject:Message-Id; b=plWkyuu6Hcbc+5DqPpmYvXSADk0d26xPCWkzrVc6whHuCEke1RynVK0CSf8BLAxpwCet7WkJ1atpqWsWJvNfM3EKdjKN3wKQQK0WWWvCox0jEj9jnpC85NQixc1KCl9+SAGcXm8yyeGaM0Uy6qIjngqHNe/wFgbfQ3ovLfVOCKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBn4ZcGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBn4ZcGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36884C113CD;
	Fri, 26 Apr 2024 04:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104052;
	bh=pe/h2vf4VkzEeKj3G0gqSMKuE6HfwSIHWuii4Zq8OLY=;
	h=Date:To:From:Subject:From;
	b=IBn4ZcGvjx7Cuv/MzIFSGs5b+k8qbScYSt+g+NDFo9mW0E1cv3DO+2nAnXRZW51Lv
	 P8BbQ4PUfurciR+SYUIiYGR3dKwB+dECOBRoF0hoEt7UdSD/g/xyyDILAPseN9rXvw
	 NtYr/ZTKSzvbkdtZ2xbI9nQbmQ1ySgeidoeZZ+xY=
Date: Thu, 25 Apr 2024 21:00:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-hpage_pxd_-macros-even-if-thp.patch removed from -mm tree
Message-Id: <20240426040052.36884C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make HPAGE_PXD_* macros even if !THP
has been removed from the -mm tree.  Its filename was
     mm-make-hpage_pxd_-macros-even-if-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: make HPAGE_PXD_* macros even if !THP
Date: Wed, 27 Mar 2024 11:23:22 -0400

These macros can be helpful when we plan to merge hugetlb code into
generic code.  Move them out and define them as long as
PGTABLE_HAS_HUGE_LEAVES is selected, because there are systems that only
define HUGETLB_PAGE not THP.

One note here is HPAGE_PMD_SHIFT must be defined even if PMD_SHIFT is not
defined (e.g.  !CONFIG_MMU case); it (or in other forms, like
HPAGE_PMD_NR) is already used in lots of common codes without ifdef
guards.  Use the old trick to let complations work.

Here we only need to differenciate HPAGE_PXD_SHIFT definitions.  All the
rest macros will be defined based on it.  When at it, move HPAGE_PMD_NR /
HPAGE_PMD_ORDER over together.

Link: https://lkml.kernel.org/r/20240327152332.950956-4-peterx@redhat.com
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

 include/linux/huge_mm.h |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/huge_mm.h~mm-make-hpage_pxd_-macros-even-if-thp
+++ a/include/linux/huge_mm.h
@@ -64,9 +64,6 @@ ssize_t single_hugepage_flag_show(struct
 				  enum transparent_hugepage_flag flag);
 extern struct kobj_attribute shmem_enabled_attr;
 
-#define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
-#define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
-
 /*
  * Mask of all large folio orders supported for anonymous THP; all orders up to
  * and including PMD_ORDER, except order-0 (which is not "huge") and order-1
@@ -87,14 +84,25 @@ extern struct kobj_attribute shmem_enabl
 #define thp_vma_allowable_order(vma, vm_flags, smaps, in_pf, enforce_sysfs, order) \
 	(!!thp_vma_allowable_orders(vma, vm_flags, smaps, in_pf, enforce_sysfs, BIT(order)))
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 #define HPAGE_PMD_SHIFT PMD_SHIFT
-#define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
+#define HPAGE_PUD_SHIFT PUD_SHIFT
+#else
+#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
+#define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
+#endif
+
+#define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
+#define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 #define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
+#define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
 
-#define HPAGE_PUD_SHIFT PUD_SHIFT
-#define HPAGE_PUD_SIZE	((1UL) << HPAGE_PUD_SHIFT)
+#define HPAGE_PUD_ORDER (HPAGE_PUD_SHIFT-PAGE_SHIFT)
+#define HPAGE_PUD_NR (1<<HPAGE_PUD_ORDER)
 #define HPAGE_PUD_MASK	(~(HPAGE_PUD_SIZE - 1))
+#define HPAGE_PUD_SIZE	((1UL) << HPAGE_PUD_SHIFT)
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 extern unsigned long transparent_hugepage_flags;
 extern unsigned long huge_anon_orders_always;
@@ -377,13 +385,6 @@ static inline bool thp_migration_support
 }
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
-#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
-#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
-#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
-
-#define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
-#define HPAGE_PUD_MASK ({ BUILD_BUG(); 0; })
-#define HPAGE_PUD_SIZE ({ BUILD_BUG(); 0; })
 
 static inline bool folio_test_pmd_mappable(struct folio *folio)
 {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

