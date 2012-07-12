From: akpm@linux-foundation.org
Subject: + mm-swap-implement-generic-handler-for-swap_activate.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:47:49 -0700
Message-ID: <20120712214749.906E710005D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42635 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2GLVrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:47:51 -0400
Received: by ghbz15 with SMTP id z15so281527ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:47:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc


The patch titled
     Subject: mm: swap: implement generic handler for swap_activate
has been added to the -mm tree.  Its filename is
     mm-swap-implement-generic-handler-for-swap_activate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: swap: implement generic handler for swap_activate

The version of swap_activate introduced is sufficient for swap-over-NFS
but would not provide enough information to implement a generic handler. 
This patch shuffles things slightly to ensure the same information is
available for aops->swap_activate() as is available to the core.

No functionality change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h   |    6 +-
 include/linux/swap.h |    5 ++
 mm/page_io.c         |   92 +++++++++++++++++++++++++++++++++++++++++
 mm/swapfile.c        |   91 ++--------------------------------------
 4 files changed, 106 insertions(+), 88 deletions(-)

diff -puN include/linux/fs.h~mm-swap-implement-generic-handler-for-swap_activate include/linux/fs.h
--- a/include/linux/fs.h~mm-swap-implement-generic-handler-for-swap_activate
+++ a/include/linux/fs.h
@@ -427,6 +427,7 @@ struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
 struct cred;
+struct swap_info_struct;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -638,8 +639,9 @@ struct address_space_operations {
 	int (*error_remove_page)(struct address_space *, struct page *);
 
 	/* swapfile support */
-	int (*swap_activate)(struct file *file);
-	int (*swap_deactivate)(struct file *file);
+	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
+				sector_t *span);
+	void (*swap_deactivate)(struct file *file);
 };
 
 extern const struct address_space_operations empty_aops;
diff -puN include/linux/swap.h~mm-swap-implement-generic-handler-for-swap_activate include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-implement-generic-handler-for-swap_activate
+++ a/include/linux/swap.h
@@ -324,6 +324,11 @@ extern int swap_writepage(struct page *p
 extern int swap_set_page_dirty(struct page *page);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
+int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
+		unsigned long nr_pages, sector_t start_block);
+int generic_swapfile_activate(struct swap_info_struct *, struct file *,
+		sector_t *);
+
 /* linux/mm/swap_state.c */
 extern struct address_space swapper_space;
 #define total_swapcache_pages  swapper_space.nrpages
diff -puN mm/page_io.c~mm-swap-implement-generic-handler-for-swap_activate mm/page_io.c
--- a/mm/page_io.c~mm-swap-implement-generic-handler-for-swap_activate
+++ a/mm/page_io.c
@@ -87,6 +87,98 @@ void end_swap_bio_read(struct bio *bio, 
 	bio_put(bio);
 }
 
+int generic_swapfile_activate(struct swap_info_struct *sis,
+				struct file *swap_file,
+				sector_t *span)
+{
+	struct address_space *mapping = swap_file->f_mapping;
+	struct inode *inode = mapping->host;
+	unsigned blocks_per_page;
+	unsigned long page_no;
+	unsigned blkbits;
+	sector_t probe_block;
+	sector_t last_block;
+	sector_t lowest_block = -1;
+	sector_t highest_block = 0;
+	int nr_extents = 0;
+	int ret;
+
+	blkbits = inode->i_blkbits;
+	blocks_per_page = PAGE_SIZE >> blkbits;
+
+	/*
+	 * Map all the blocks into the extent list.  This code doesn't try
+	 * to be very smart.
+	 */
+	probe_block = 0;
+	page_no = 0;
+	last_block = i_size_read(inode) >> blkbits;
+	while ((probe_block + blocks_per_page) <= last_block &&
+			page_no < sis->max) {
+		unsigned block_in_page;
+		sector_t first_block;
+
+		first_block = bmap(inode, probe_block);
+		if (first_block == 0)
+			goto bad_bmap;
+
+		/*
+		 * It must be PAGE_SIZE aligned on-disk
+		 */
+		if (first_block & (blocks_per_page - 1)) {
+			probe_block++;
+			goto reprobe;
+		}
+
+		for (block_in_page = 1; block_in_page < blocks_per_page;
+					block_in_page++) {
+			sector_t block;
+
+			block = bmap(inode, probe_block + block_in_page);
+			if (block == 0)
+				goto bad_bmap;
+			if (block != first_block + block_in_page) {
+				/* Discontiguity */
+				probe_block++;
+				goto reprobe;
+			}
+		}
+
+		first_block >>= (PAGE_SHIFT - blkbits);
+		if (page_no) {	/* exclude the header page */
+			if (first_block < lowest_block)
+				lowest_block = first_block;
+			if (first_block > highest_block)
+				highest_block = first_block;
+		}
+
+		/*
+		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
+		 */
+		ret = add_swap_extent(sis, page_no, 1, first_block);
+		if (ret < 0)
+			goto out;
+		nr_extents += ret;
+		page_no++;
+		probe_block += blocks_per_page;
+reprobe:
+		continue;
+	}
+	ret = nr_extents;
+	*span = 1 + highest_block - lowest_block;
+	if (page_no == 0)
+		page_no = 1;	/* force Empty message */
+	sis->max = page_no;
+	sis->pages = page_no - 1;
+	sis->highest_bit = page_no - 1;
+out:
+	return ret;
+bad_bmap:
+	printk(KERN_ERR "swapon: swapfile has holes\n");
+	ret = -EINVAL;
+	goto out;
+}
+
 /*
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
diff -puN mm/swapfile.c~mm-swap-implement-generic-handler-for-swap_activate mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-implement-generic-handler-for-swap_activate
+++ a/mm/swapfile.c
@@ -1358,7 +1358,7 @@ static void destroy_swap_extents(struct 
  *
  * This function rather assumes that it is called in ascending page order.
  */
-static int
+int
 add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block)
 {
@@ -1434,106 +1434,25 @@ static int setup_swap_extents(struct swa
 	struct file *swap_file = sis->swap_file;
 	struct address_space *mapping = swap_file->f_mapping;
 	struct inode *inode = mapping->host;
-	unsigned blocks_per_page;
-	unsigned long page_no;
-	unsigned blkbits;
-	sector_t probe_block;
-	sector_t last_block;
-	sector_t lowest_block = -1;
-	sector_t highest_block = 0;
-	int nr_extents = 0;
 	int ret;
 
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
-		goto out;
+		return ret;
 	}
 
 	if (mapping->a_ops->swap_activate) {
-		ret = mapping->a_ops->swap_activate(swap_file);
+		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
 		if (!ret) {
 			sis->flags |= SWP_FILE;
 			ret = add_swap_extent(sis, 0, sis->max, 0);
 			*span = sis->pages;
 		}
-		goto out;
+		return ret;
 	}
 
-	blkbits = inode->i_blkbits;
-	blocks_per_page = PAGE_SIZE >> blkbits;
-
-	/*
-	 * Map all the blocks into the extent list.  This code doesn't try
-	 * to be very smart.
-	 */
-	probe_block = 0;
-	page_no = 0;
-	last_block = i_size_read(inode) >> blkbits;
-	while ((probe_block + blocks_per_page) <= last_block &&
-			page_no < sis->max) {
-		unsigned block_in_page;
-		sector_t first_block;
-
-		first_block = bmap(inode, probe_block);
-		if (first_block == 0)
-			goto bad_bmap;
-
-		/*
-		 * It must be PAGE_SIZE aligned on-disk
-		 */
-		if (first_block & (blocks_per_page - 1)) {
-			probe_block++;
-			goto reprobe;
-		}
-
-		for (block_in_page = 1; block_in_page < blocks_per_page;
-					block_in_page++) {
-			sector_t block;
-
-			block = bmap(inode, probe_block + block_in_page);
-			if (block == 0)
-				goto bad_bmap;
-			if (block != first_block + block_in_page) {
-				/* Discontiguity */
-				probe_block++;
-				goto reprobe;
-			}
-		}
-
-		first_block >>= (PAGE_SHIFT - blkbits);
-		if (page_no) {	/* exclude the header page */
-			if (first_block < lowest_block)
-				lowest_block = first_block;
-			if (first_block > highest_block)
-				highest_block = first_block;
-		}
-
-		/*
-		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
-		 */
-		ret = add_swap_extent(sis, page_no, 1, first_block);
-		if (ret < 0)
-			goto out;
-		nr_extents += ret;
-		page_no++;
-		probe_block += blocks_per_page;
-reprobe:
-		continue;
-	}
-	ret = nr_extents;
-	*span = 1 + highest_block - lowest_block;
-	if (page_no == 0)
-		page_no = 1;	/* force Empty message */
-	sis->max = page_no;
-	sis->pages = page_no - 1;
-	sis->highest_bit = page_no - 1;
-out:
-	return ret;
-bad_bmap:
-	printk(KERN_ERR "swapon: swapfile has holes\n");
-	ret = -EINVAL;
-	goto out;
+	return generic_swapfile_activate(sis, swap_file, span);
 }
 
 static void enable_swap_info(struct swap_info_struct *p, int prio,
_
Subject: Subject: mm: swap: implement generic handler for swap_activate

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch
netvm-prevent-a-stream-specific-deadlock.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch

