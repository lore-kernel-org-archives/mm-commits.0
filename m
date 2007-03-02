From: akpm@linux-foundation.org
Subject: + page-migration-fix-vma-flag-checking.patch added to -mm tree
Date: Thu, 01 Mar 2007 19:31:34 -0800
Message-ID: <200703020331.l223VYnv031243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422742AbXCBDbl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 22:31:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@engr.sgi.com, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     Page migration: Fix vma flag checking
has been added to the -mm tree.  Its filename is
     page-migration-fix-vma-flag-checking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Page migration: Fix vma flag checking
From: Christoph Lameter <clameter@engr.sgi.com>

Currently we do not check for vma flags if sys_move_pages is called to move
individual pages.  If sys_migrate_pages is called to move pages then we
check for vm_flags that indicate a non migratable vma but that still
includes VM_LOCKED and we can migrate mlocked pages.

Extract the vma_migratable check from mm/mempolicy.c, fix it and put it
into migrate.h so that is can be used from both locations.

Problem was spotted by Lee Schermerhorn

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    8 ++++++++
 mm/mempolicy.c          |    9 ---------
 mm/migrate.c            |    2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff -puN include/linux/migrate.h~page-migration-fix-vma-flag-checking include/linux/migrate.h
--- a/include/linux/migrate.h~page-migration-fix-vma-flag-checking
+++ a/include/linux/migrate.h
@@ -5,6 +5,14 @@
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
+/* Check if a vma is migratable */
+static inline int vma_migratable(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
+		return 0;
+	return 1;
+}
+
 #ifdef CONFIG_MIGRATION
 extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
 extern int putback_lru_pages(struct list_head *l);
diff -puN mm/mempolicy.c~page-migration-fix-vma-flag-checking mm/mempolicy.c
--- a/mm/mempolicy.c~page-migration-fix-vma-flag-checking
+++ a/mm/mempolicy.c
@@ -321,15 +321,6 @@ static inline int check_pgd_range(struct
 	return 0;
 }
 
-/* Check if a vma is migratable */
-static inline int vma_migratable(struct vm_area_struct *vma)
-{
-	if (vma->vm_flags & (
-		VM_LOCKED|VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
-		return 0;
-	return 1;
-}
-
 /*
  * Check if all pages in a range are on a set of nodes.
  * If pagelist != NULL then isolate pages from the LRU and
diff -puN mm/migrate.c~page-migration-fix-vma-flag-checking mm/migrate.c
--- a/mm/migrate.c~page-migration-fix-vma-flag-checking
+++ a/mm/migrate.c
@@ -781,7 +781,7 @@ static int do_move_pages(struct mm_struc
 
 		err = -EFAULT;
 		vma = find_vma(mm, pp->addr);
-		if (!vma)
+		if (!vma || !vma_migratable(vma))
 			goto set_status;
 
 		page = follow_page(vma, pp->addr, FOLL_GET);
_

Patches currently in -mm which might be from clameter@engr.sgi.com are

adapt-page_lock_anon_vma-to-preempt_rcu.patch
page-migration-fix-vma-flag-checking.patch
page-migration-fix-vma-flag-checking-fix.patch
nfs-fix-congestion-control-v4.patch
git-block-xfs-barriers-broke.patch
mm-set-hashdist_default-to-1-for-x86_64-numa.patch
x86_64-configurable-fake-numa-node-sizes.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
swap_prefetch-vs-zoned-counters.patch
reiser4-vs-zoned-allocator.patch
slab-leaks3-default-y.patch
