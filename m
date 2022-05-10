Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF61C43217
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbiEJEVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614EB2AC6F9
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3410861766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87649C385C5;
        Tue, 10 May 2022 04:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156108;
        bh=oNK8QT+X9L9bdjJ6tzBleszNiyKHn2/BpzK9WTyomoY=;
        h=Date:To:From:Subject:From;
        b=JwUI6PGZhZ0X2QgEDTKcH/wQkPyrSSyczMDlCtunABITzRzaS9QF4VcQ3IhcUzPXU
         9U1KQDxRNmM3KCQs20EVR3Z3STyczFNNAPfcZ/onwjtnLkS4sjktmUdUlKA3PRWYCT
         HNQHqJOh6fMTekc5DTMlUIUsqE7oI5FNo6Kgeud8=
Date:   Mon, 09 May 2022 21:15:08 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-create-new-mm-swaph-header-file.patch removed from -mm tree
Message-Id: <20220510041508.87649C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: create new mm/swap.h header file
has been removed from the -mm tree.  Its filename was
     mm-create-new-mm-swaph-header-file.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: create new mm/swap.h header file

Patch series "MM changes to improve swap-over-NFS support".

Assorted improvements for swap-via-filesystem.

This is a resend of these patches, rebased on current HEAD.  The only
substantial changes is that swap_dirty_folio has replaced
swap_set_page_dirty.

Currently swap-via-fs (SWP_FS_OPS) doesn't work for any filesystem.  It
has previously worked for NFS but that broke a few releases back.  This
series changes to use a new ->swap_rw rather than ->readpage and
->direct_IO.  It also makes other improvements.

There is a companion series already in linux-next which fixes various
issues with NFS.  Once both series land, a final patch is needed which
changes NFS over to use ->swap_rw.


This patch (of 10):

Many functions declared in include/linux/swap.h are only used within mm/

Create a new "mm/swap.h" and move some of these declarations there.
Remove the redundant 'extern' from the function declarations.

[akpm@linux-foundation.org: mm/memory-failure.c needs mm/swap.h]
Link: https://lkml.kernel.org/r/164859751830.29473.5309689752169286816.stgit@noble.brown
Link: https://lkml.kernel.org/r/164859778120.29473.11725907882296224053.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: David Howells <dhowells@redhat.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |  121 -------------------------------------
 mm/huge_memory.c     |    1 
 mm/madvise.c         |    1 
 mm/memcontrol.c      |    1 
 mm/memory-failure.c  |    1 
 mm/memory.c          |    1 
 mm/mincore.c         |    1 
 mm/page_alloc.c      |    1 
 mm/page_io.c         |    1 
 mm/shmem.c           |    1 
 mm/swap.h            |  133 +++++++++++++++++++++++++++++++++++++++++
 mm/swap_state.c      |    1 
 mm/swapfile.c        |    1 
 mm/util.c            |    1 
 mm/vmscan.c          |    1 
 mm/zswap.c           |    2 
 16 files changed, 148 insertions(+), 121 deletions(-)

--- a/include/linux/swap.h~mm-create-new-mm-swaph-header-file
+++ a/include/linux/swap.h
@@ -427,62 +427,19 @@ extern void kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
-#include <linux/blk_types.h> /* for bio_end_io_t */
-
-/* linux/mm/page_io.c */
-extern int swap_readpage(struct page *page, bool do_poll);
-extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern void end_swap_bio_write(struct bio *bio);
-extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	bio_end_io_t end_write_func);
 bool swap_dirty_folio(struct address_space *mapping, struct folio *folio);
-
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
 int generic_swapfile_activate(struct swap_info_struct *, struct file *,
 		sector_t *);
 
-/* linux/mm/swap_state.c */
-/* One swap address space for each 64M swap space */
-#define SWAP_ADDRESS_SPACE_SHIFT	14
-#define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
-extern struct address_space *swapper_spaces[];
-#define swap_address_space(entry)			    \
-	(&swapper_spaces[swp_type(entry)][swp_offset(entry) \
-		>> SWAP_ADDRESS_SPACE_SHIFT])
 static inline unsigned long total_swapcache_pages(void)
 {
 	return global_node_page_state(NR_SWAPCACHE);
 }
 
-extern void show_swap_cache_info(void);
-extern int add_to_swap(struct page *page);
-extern void *get_shadow_from_swap_cache(swp_entry_t entry);
-extern int add_to_swap_cache(struct page *page, swp_entry_t entry,
-			gfp_t gfp, void **shadowp);
-extern void __delete_from_swap_cache(struct page *page,
-			swp_entry_t entry, void *shadow);
-extern void delete_from_swap_cache(struct page *);
-extern void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end);
-extern void free_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
-extern struct page *lookup_swap_cache(swp_entry_t entry,
-				      struct vm_area_struct *vma,
-				      unsigned long addr);
-struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index);
-extern struct page *read_swap_cache_async(swp_entry_t, gfp_t,
-			struct vm_area_struct *vma, unsigned long addr,
-			bool do_poll);
-extern struct page *__read_swap_cache_async(swp_entry_t, gfp_t,
-			struct vm_area_struct *vma, unsigned long addr,
-			bool *new_page_allocated);
-extern struct page *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
-				struct vm_fault *vmf);
-extern struct page *swapin_readahead(swp_entry_t entry, gfp_t flag,
-				struct vm_fault *vmf);
-
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
@@ -535,12 +492,6 @@ static inline void put_swap_device(struc
 }
 
 #else /* CONFIG_SWAP */
-
-static inline int swap_readpage(struct page *page, bool do_poll)
-{
-	return 0;
-}
-
 static inline struct swap_info_struct *swp_swap_info(swp_entry_t entry)
 {
 	return NULL;
@@ -555,11 +506,6 @@ static inline void put_swap_device(struc
 {
 }
 
-static inline struct address_space *swap_address_space(swp_entry_t entry)
-{
-	return NULL;
-}
-
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
@@ -574,14 +520,6 @@ static inline struct address_space *swap
 #define free_pages_and_swap_cache(pages, nr) \
 	release_pages((pages), (nr));
 
-static inline void free_swap_cache(struct page *page)
-{
-}
-
-static inline void show_swap_cache_info(void)
-{
-}
-
 /* used to sanity check ptes in zap_pte_range when CONFIG_SWAP=0 */
 #define free_swap_and_cache(e) is_pfn_swap_entry(e)
 
@@ -607,65 +545,6 @@ static inline void put_swap_page(struct
 {
 }
 
-static inline struct page *swap_cluster_readahead(swp_entry_t entry,
-				gfp_t gfp_mask, struct vm_fault *vmf)
-{
-	return NULL;
-}
-
-static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
-			struct vm_fault *vmf)
-{
-	return NULL;
-}
-
-static inline int swap_writepage(struct page *p, struct writeback_control *wbc)
-{
-	return 0;
-}
-
-static inline struct page *lookup_swap_cache(swp_entry_t swp,
-					     struct vm_area_struct *vma,
-					     unsigned long addr)
-{
-	return NULL;
-}
-
-static inline
-struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index)
-{
-	return find_get_page(mapping, index);
-}
-
-static inline int add_to_swap(struct page *page)
-{
-	return 0;
-}
-
-static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
-{
-	return NULL;
-}
-
-static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
-					gfp_t gfp_mask, void **shadowp)
-{
-	return -1;
-}
-
-static inline void __delete_from_swap_cache(struct page *page,
-					swp_entry_t entry, void *shadow)
-{
-}
-
-static inline void delete_from_swap_cache(struct page *page)
-{
-}
-
-static inline void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end)
-{
-}
 
 static inline int page_swapcount(struct page *page)
 {
--- a/mm/huge_memory.c~mm-create-new-mm-swaph-header-file
+++ a/mm/huge_memory.c
@@ -39,6 +39,7 @@
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
+#include "swap.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/thp.h>
--- a/mm/madvise.c~mm-create-new-mm-swaph-header-file
+++ a/mm/madvise.c
@@ -35,6 +35,7 @@
 #include <asm/tlb.h>
 
 #include "internal.h"
+#include "swap.h"
 
 struct madvise_walk_private {
 	struct mmu_gather *tlb;
--- a/mm/memcontrol.c~mm-create-new-mm-swaph-header-file
+++ a/mm/memcontrol.c
@@ -67,6 +67,7 @@
 #include <net/sock.h>
 #include <net/ip.h>
 #include "slab.h"
+#include "swap.h"
 
 #include <linux/uaccess.h>
 
--- a/mm/memory.c~mm-create-new-mm-swaph-header-file
+++ a/mm/memory.c
@@ -86,6 +86,7 @@
 
 #include "pgalloc-track.h"
 #include "internal.h"
+#include "swap.h"
 
 #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
 #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
--- a/mm/memory-failure.c~mm-create-new-mm-swaph-header-file
+++ a/mm/memory-failure.c
@@ -59,6 +59,7 @@
 #include <linux/page-isolation.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
+#include "swap.h"
 #include "internal.h"
 #include "ras/ras_event.h"
 
--- a/mm/mincore.c~mm-create-new-mm-swaph-header-file
+++ a/mm/mincore.c
@@ -20,6 +20,7 @@
 #include <linux/pgtable.h>
 
 #include <linux/uaccess.h>
+#include "swap.h"
 
 static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
--- a/mm/page_alloc.c~mm-create-new-mm-swaph-header-file
+++ a/mm/page_alloc.c
@@ -81,6 +81,7 @@
 #include "internal.h"
 #include "shuffle.h"
 #include "page_reporting.h"
+#include "swap.h"
 
 /* Free Page Internal flags: for internal, non-pcp variants of free_pages(). */
 typedef int __bitwise fpi_t;
--- a/mm/page_io.c~mm-create-new-mm-swaph-header-file
+++ a/mm/page_io.c
@@ -26,6 +26,7 @@
 #include <linux/uio.h>
 #include <linux/sched/task.h>
 #include <linux/delayacct.h>
+#include "swap.h"
 
 void end_swap_bio_write(struct bio *bio)
 {
--- a/mm/shmem.c~mm-create-new-mm-swaph-header-file
+++ a/mm/shmem.c
@@ -38,6 +38,7 @@
 #include <linux/hugetlb.h>
 #include <linux/fs_parser.h>
 #include <linux/swapfile.h>
+#include "swap.h"
 
 static struct vfsmount *shm_mnt;
 
--- a/mm/swapfile.c~mm-create-new-mm-swaph-header-file
+++ a/mm/swapfile.c
@@ -44,6 +44,7 @@
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
+#include "swap.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
--- /dev/null
+++ a/mm/swap.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_SWAP_H
+#define _MM_SWAP_H
+
+#ifdef CONFIG_SWAP
+#include <linux/blk_types.h> /* for bio_end_io_t */
+
+/* linux/mm/page_io.c */
+int swap_readpage(struct page *page, bool do_poll);
+int swap_writepage(struct page *page, struct writeback_control *wbc);
+void end_swap_bio_write(struct bio *bio);
+int __swap_writepage(struct page *page, struct writeback_control *wbc,
+		     bio_end_io_t end_write_func);
+
+/* linux/mm/swap_state.c */
+/* One swap address space for each 64M swap space */
+#define SWAP_ADDRESS_SPACE_SHIFT	14
+#define SWAP_ADDRESS_SPACE_PAGES	(1 << SWAP_ADDRESS_SPACE_SHIFT)
+extern struct address_space *swapper_spaces[];
+#define swap_address_space(entry)			    \
+	(&swapper_spaces[swp_type(entry)][swp_offset(entry) \
+		>> SWAP_ADDRESS_SPACE_SHIFT])
+
+void show_swap_cache_info(void);
+int add_to_swap(struct page *page);
+void *get_shadow_from_swap_cache(swp_entry_t entry);
+int add_to_swap_cache(struct page *page, swp_entry_t entry,
+		      gfp_t gfp, void **shadowp);
+void __delete_from_swap_cache(struct page *page,
+			      swp_entry_t entry, void *shadow);
+void delete_from_swap_cache(struct page *page);
+void clear_shadow_from_swap_cache(int type, unsigned long begin,
+				  unsigned long end);
+void free_swap_cache(struct page *page);
+struct page *lookup_swap_cache(swp_entry_t entry,
+			       struct vm_area_struct *vma,
+			       unsigned long addr);
+struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index);
+
+struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
+				   struct vm_area_struct *vma,
+				   unsigned long addr,
+				   bool do_poll);
+struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
+				     struct vm_area_struct *vma,
+				     unsigned long addr,
+				     bool *new_page_allocated);
+struct page *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
+				    struct vm_fault *vmf);
+struct page *swapin_readahead(swp_entry_t entry, gfp_t flag,
+			      struct vm_fault *vmf);
+
+#else /* CONFIG_SWAP */
+static inline int swap_readpage(struct page *page, bool do_poll)
+{
+	return 0;
+}
+
+static inline struct address_space *swap_address_space(swp_entry_t entry)
+{
+	return NULL;
+}
+
+static inline void free_swap_cache(struct page *page)
+{
+}
+
+static inline void show_swap_cache_info(void)
+{
+}
+
+static inline struct page *swap_cluster_readahead(swp_entry_t entry,
+				gfp_t gfp_mask, struct vm_fault *vmf)
+{
+	return NULL;
+}
+
+static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
+			struct vm_fault *vmf)
+{
+	return NULL;
+}
+
+static inline int swap_writepage(struct page *p, struct writeback_control *wbc)
+{
+	return 0;
+}
+
+static inline struct page *lookup_swap_cache(swp_entry_t swp,
+					     struct vm_area_struct *vma,
+					     unsigned long addr)
+{
+	return NULL;
+}
+
+static inline
+struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index)
+{
+	return find_get_page(mapping, index);
+}
+
+static inline int add_to_swap(struct page *page)
+{
+	return 0;
+}
+
+static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
+{
+	return NULL;
+}
+
+static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
+					gfp_t gfp_mask, void **shadowp)
+{
+	return -1;
+}
+
+static inline void __delete_from_swap_cache(struct page *page,
+					swp_entry_t entry, void *shadow)
+{
+}
+
+static inline void delete_from_swap_cache(struct page *page)
+{
+}
+
+static inline void clear_shadow_from_swap_cache(int type, unsigned long begin,
+				unsigned long end)
+{
+}
+
+#endif /* CONFIG_SWAP */
+#endif /* _MM_SWAP_H */
--- a/mm/swap_state.c~mm-create-new-mm-swaph-header-file
+++ a/mm/swap_state.c
@@ -23,6 +23,7 @@
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
 #include "internal.h"
+#include "swap.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
--- a/mm/util.c~mm-create-new-mm-swaph-header-file
+++ a/mm/util.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 
 #include "internal.h"
+#include "swap.h"
 
 /**
  * kfree_const - conditionally free memory
--- a/mm/vmscan.c~mm-create-new-mm-swaph-header-file
+++ a/mm/vmscan.c
@@ -59,6 +59,7 @@
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
+#include "swap.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
--- a/mm/zswap.c~mm-create-new-mm-swaph-header-file
+++ a/mm/zswap.c
@@ -36,6 +36,8 @@
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 
+#include "swap.h"
+
 /*********************************
 * statistics
 **********************************/
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

