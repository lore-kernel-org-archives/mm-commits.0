From: akpm@linux-foundation.org
Subject: + bootmem-add-documentation-to-api-functions.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:17 -0700
Message-ID: <200806082335.m58NZH7L025596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbYFHXgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de


The patch titled
     bootmem: add documentation to API functions
has been added to the -mm tree.  Its filename is
     bootmem-add-documentation-to-api-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: add documentation to API functions
From: Johannes Weiner <hannes@saeurebad.de>

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |  150 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 149 insertions(+), 1 deletion(-)

diff -puN mm/bootmem.c~bootmem-add-documentation-to-api-functions mm/bootmem.c
--- a/mm/bootmem.c~bootmem-add-documentation-to-api-functions
+++ a/mm/bootmem.c
@@ -47,7 +47,10 @@ static unsigned long __init get_mapsize(
 	return ALIGN(mapsize, sizeof(long));
 }
 
-/* return the number of _pages_ that will be allocated for the boot bitmap */
+/**
+ * bootmem_bootmap_pages - calculate bitmap size in pages
+ * @pages: number of pages the bitmap has to represent
+ */
 unsigned long __init bootmem_bootmap_pages(unsigned long pages)
 {
 	unsigned long mapsize;
@@ -104,12 +107,28 @@ static unsigned long __init init_bootmem
 	return mapsize;
 }
 
+/**
+ * init_bootmem_node - register a node as boot memory
+ * @pgdat: node to register
+ * @freepfn: pfn where the bitmap for this node is to be placed
+ * @startpfn: first pfn on the node
+ * @endpfn: first pfn after the node
+ *
+ * Returns the number of bytes needed to hold the bitmap for this node.
+ */
 unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
 				unsigned long startpfn, unsigned long endpfn)
 {
 	return init_bootmem_core(pgdat->bdata, freepfn, startpfn, endpfn);
 }
 
+/**
+ * init_bootmem - register boot memory
+ * @start: pfn where the bitmap is to be placed
+ * @pages: number of available physical pages
+ *
+ * Returns the number of bytes needed to hold the bitmap.
+ */
 unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 {
 	max_low_pfn = pages;
@@ -182,12 +201,23 @@ static unsigned long __init free_all_boo
 	return count;
 }
 
+/**
+ * free_all_bootmem_node - release a node's free pages to the buddy allocator
+ * @pgdat: node to be released
+ *
+ * Returns the number of pages actually released.
+ */
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
 	return free_all_bootmem_core(pgdat->bdata);
 }
 
+/**
+ * free_all_bootmem - release free pages to the buddy allocator
+ *
+ * Returns the number of pages actually released.
+ */
 unsigned long __init free_all_bootmem(void)
 {
 	return free_all_bootmem_core(NODE_DATA(0)->bdata);
@@ -231,12 +261,32 @@ static void __init free_bootmem_core(boo
 	}
 }
 
+/**
+ * free_bootmem_node - mark a page range as usable
+ * @pgdat: node the range resides on
+ * @physaddr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * Partial pages will be considered reserved and left as they are.
+ *
+ * Only physical pages that actually reside on @pgdat are marked.
+ */
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
 	free_bootmem_core(pgdat->bdata, physaddr, size);
 }
 
+/**
+ * free_bootmem - mark a page range as usable
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * Partial pages will be considered reserved and left as they are.
+ *
+ * All physical pages within the range are marked, no matter what
+ * node they reside on.
+ */
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 	bootmem_data_t *bdata;
@@ -319,6 +369,17 @@ static void __init reserve_bootmem_core(
 	}
 }
 
+/**
+ * reserve_bootmem_node - mark a page range as reserved
+ * @pgdat: node the range resides on
+ * @physaddr: starting address of the range
+ * @size: size of the range in bytes
+ * @flags: reservation flags (see linux/bootmem.h)
+ *
+ * Partial pages will be reserved.
+ *
+ * Only physical pages that actually reside on @pgdat are marked.
+ */
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
@@ -331,6 +392,17 @@ void __init reserve_bootmem_node(pg_data
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
+/**
+ * reserve_bootmem - mark a page range as usable
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ * @flags: reservation flags (see linux/bootmem.h)
+ *
+ * Partial pages will be reserved.
+ *
+ * All physical pages within the range are marked, no matter what
+ * node they reside on.
+ */
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
@@ -499,6 +571,19 @@ found:
 	return ret;
 }
 
+/**
+ * __alloc_bootmem_nopanic - allocate boot memory without panicking
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * Returns NULL on failure.
+ */
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
 				      unsigned long goal)
 {
@@ -513,6 +598,19 @@ void * __init __alloc_bootmem_nopanic(un
 	return NULL;
 }
 
+/**
+ * __alloc_bootmem - allocate boot memory
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * The function panics if the request can not be satisfied.
+ */
 void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 			      unsigned long goal)
 {
@@ -528,6 +626,21 @@ void * __init __alloc_bootmem(unsigned l
 	return NULL;
 }
 
+/**
+ * __alloc_bootmem_node - allocate boot memory from a specific node
+ * @pgdat: node to allocate from
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may fall back to any node in the system if the specified node
+ * can not hold the requested memory.
+ *
+ * The function panics if the request can not be satisfied.
+ */
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
@@ -541,6 +654,13 @@ void * __init __alloc_bootmem_node(pg_da
 }
 
 #ifdef CONFIG_SPARSEMEM
+/**
+ * alloc_bootmem_section - allocate boot memory from a specific section
+ * @size: size of the request in bytes
+ * @section_nr: sparse map section to allocate from
+ *
+ * Return NULL on failure.
+ */
 void * __init alloc_bootmem_section(unsigned long size,
 				    unsigned long section_nr)
 {
@@ -587,6 +707,19 @@ void * __init __alloc_bootmem_node_nopan
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
 
+/**
+ * __alloc_bootmem_low - allocate low boot memory
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * The function panics if the request can not be satisfied.
+ */
 void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 				  unsigned long goal)
 {
@@ -608,6 +741,21 @@ void * __init __alloc_bootmem_low(unsign
 	return NULL;
 }
 
+/**
+ * __alloc_bootmem_low_node - allocate low boot memory from a specific node
+ * @pgdat: node to allocate from
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may fall back to any node in the system if the specified node
+ * can not hold the requested memory.
+ *
+ * The function panics if the request can not be satisfied.
+ */
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-add-documentation-to-api-functions.patch
bootmem-add-debugging-framework.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

