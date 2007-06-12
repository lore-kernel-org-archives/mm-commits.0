From: akpm@linux-foundation.org
Subject: + mm-fix-improper-init-type-section-references.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:23:41 -0700
Message-ID: <200706122023.l5CKNfWK020528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754074AbXFLUXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     mm: fix improper .init-type section references
has been added to the -mm tree.  Its filename is
     mm-fix-improper-init-type-section-references.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix improper .init-type section references
From: "Jan Beulich" <jbeulich@novell.com>

.. which modpost started warning about.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 mm/page_alloc.c  |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/kthread.c~mm-fix-improper-init-type-section-references kernel/kthread.c
--- a/kernel/kthread.c~mm-fix-improper-init-type-section-references
+++ a/kernel/kthread.c
@@ -215,7 +215,7 @@ int kthread_stop(struct task_struct *k)
 EXPORT_SYMBOL(kthread_stop);
 
 
-static __init void kthreadd_setup(void)
+static noinline __init_refok void kthreadd_setup(void)
 {
 	struct task_struct *tsk = current;
 
diff -puN mm/page_alloc.c~mm-fix-improper-init-type-section-references mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-improper-init-type-section-references
+++ a/mm/page_alloc.c
@@ -135,13 +135,13 @@ static unsigned long __meminitdata dma_r
     #endif
   #endif
 
-  struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
-  int __meminitdata nr_nodemap_entries;
-  unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-  unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+  static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
+  static int __meminitdata nr_nodemap_entries;
+  static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
+  static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 #ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-  unsigned long __initdata node_boundary_start_pfn[MAX_NUMNODES];
-  unsigned long __initdata node_boundary_end_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
+  static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
   unsigned long __initdata required_kernelcore;
   unsigned long __initdata zone_movable_pfn[MAX_NUMNODES];
@@ -2622,7 +2622,7 @@ void zone_init_free_lists(struct pglist_
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __cpuinit zone_batchsize(struct zone *zone)
+static int __devinit zone_batchsize(struct zone *zone)
 {
 	int batch;
 
@@ -3024,7 +3024,7 @@ void __init push_node_boundaries(unsigne
 }
 
 /* If necessary, push the node boundary out for reserve hotadd */
-static void __init account_node_boundary(unsigned int nid,
+static void __meminit account_node_boundary(unsigned int nid,
 		unsigned long *start_pfn, unsigned long *end_pfn)
 {
 	printk(KERN_DEBUG "Entering account_node_boundary(%u, %lu, %lu)\n",
@@ -3044,7 +3044,7 @@ static void __init account_node_boundary
 void __init push_node_boundaries(unsigned int nid,
 		unsigned long start_pfn, unsigned long end_pfn) {}
 
-static void __init account_node_boundary(unsigned int nid,
+static void __meminit account_node_boundary(unsigned int nid,
 		unsigned long *start_pfn, unsigned long *end_pfn) {}
 #endif
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

remove-pci_dac_dma_-apis.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
mm-fix-improper-init-type-section-references.patch
page-table-handling-cleanup.patch
modpost-white-list-pattern-adjustment.patch
adjust-nosmp-handling.patch
kill-vmalloc_earlyreserve.patch
x86-fix-change_page_attr-tlb-and-cache-flushing.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
