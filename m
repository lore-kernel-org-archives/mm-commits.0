From: akpm@osdl.org
Subject: - virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch removed from -mm tree
Date: Wed, 20 Dec 2006 23:26:06 -0800
Message-ID: <200612210726.kBL7Q6Em018708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45358 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422810AbWLUH1e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 02:27:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     virtual-memmap-on-sparsemem-v3-map-and-unmap fix
has been removed from the -mm tree.  Its filename was
     virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: virtual-memmap-on-sparsemem-v3-map-and-unmap fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This removes implicit default actions in map_generic_kernel() call.
Also changes comments in vmalloc.h

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/vmalloc.h |    8 ++++---
 mm/vmalloc.c            |   39 +++++++++++---------------------------
 2 files changed, 17 insertions(+), 30 deletions(-)

diff -puN include/linux/vmalloc.h~virtual-memmap-on-sparsemem-v3-map-and-unmap-fix include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~virtual-memmap-on-sparsemem-v3-map-and-unmap-fix
+++ a/include/linux/vmalloc.h
@@ -81,6 +81,9 @@ extern struct vm_struct *vmlist;
  * not managed by standard vmap calls.
  * The caller has to be responsible to manage his own virtual address space.
  *
+ * what you have to do in pud/pmd/pte allocation is allocate page and
+ * populate that entry.
+ *
  * Bootstrap consideration:
  * you can pass pud/pmd/pte alloc functions to map_generic_kernel().
  * So you can use bootmem function or something to alloc page tables if
@@ -88,13 +91,12 @@ extern struct vm_struct *vmlist;
  */
 
 struct gen_map_kern_ops {
-	/* must be defined */
+	/* all pointers must be filled */
 	int	(*k_pte_set)(pte_t *pte, unsigned long addr, void *data);
-	int	(*k_pte_clear)(pte_t *pte, unsigned long addr, void *data);
-	/* optional */
 	int 	(*k_pud_alloc)(pgd_t *pgd, unsigned long addr, void *data);
 	int 	(*k_pmd_alloc)(pud_t *pud, unsigned long addr, void *data);
 	int 	(*k_pte_alloc)(pmd_t *pmd, unsigned long addr, void *data);
+	int	(*k_pte_clear)(pte_t *pte, unsigned long addr, void *data);
 };
 
 /*
diff -puN mm/vmalloc.c~virtual-memmap-on-sparsemem-v3-map-and-unmap-fix mm/vmalloc.c
--- a/mm/vmalloc.c~virtual-memmap-on-sparsemem-v3-map-and-unmap-fix
+++ a/mm/vmalloc.c
@@ -764,15 +764,10 @@ static int map_generic_pte_range(pmd_t *
 	int ret = 0;
 	unsigned long next;
 	if (!pmd_present(*pmd)) {
-		if (ops->k_pte_alloc) {
-			ret = ops->k_pte_alloc(pmd, addr, data);
-			if (ret)
-				return ret;
-		} else {
-			pte = pte_alloc_kernel(pmd, addr);
-			if (!pte)
-				return -ENOMEM;
-		}
+		BUG_ON(!ops->k_pte_alloc);
+		ret = ops->k_pte_alloc(pmd, addr, data);
+		if (ret)
+			return ret;
 	}
 	pte = pte_offset_kernel(pmd, addr);
 
@@ -796,15 +791,10 @@ static int map_generic_pmd_range(pud_t *
 	int ret;
 
 	if (pud_none(*pud)) {
-		if (ops->k_pmd_alloc) {
-			ret = ops->k_pmd_alloc(pud, addr, data);
-			if (ret)
-				return ret;
-		} else {
-			pmd = pmd_alloc(&init_mm, pud, addr);
-			if (!pmd)
-				return -ENOMEM;
-		}
+		BUG_ON(!ops->k_pmd_alloc);
+		ret = ops->k_pmd_alloc(pud, addr, data);
+		if (ret)
+			return ret;
 	}
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -824,15 +814,10 @@ static int map_generic_pud_range(pgd_t *
 	unsigned long next;
 	int ret;
 	if (pgd_none(*pgd)) {
-		if (ops->k_pud_alloc) {
-			ret = ops->k_pud_alloc(pgd, addr, data);
-			if (ret)
-				return ret;
-		} else {
-			pud = pud_alloc(&init_mm, pgd, addr);
-			if (!pud)
-				return -ENOMEM;
-		}
+		BUG_ON(!ops->k_pud_alloc);
+		ret = ops->k_pud_alloc(pgd, addr, data);
+		if (ret)
+			return ret;
 	}
 	pud = pud_offset(pgd, addr);
 	do {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

virtual-memmap-on-sparsemem-v3-map-and-unmap-fix.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-generic-virtual-fix.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual-update.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch

