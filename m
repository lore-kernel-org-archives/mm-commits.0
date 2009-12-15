From: akpm@linux-foundation.org
Subject: [merged] swap_info-swap_map-of-chars-not-shorts.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:51:48 -0800
Message-ID: <200912152151.nBFLpmmK015134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761198AbZLOVwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     swap_info: swap_map of chars not shorts
has been removed from the -mm tree.  Its filename was
     swap_info-swap_map-of-chars-not-shorts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swap_info: swap_map of chars not shorts
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Halve the vmalloc'ed swap_map array from unsigned shorts to unsigned
chars: it's still very unusual to reach a swap count of 126, and the
next patch allows it to be extended indefinitely.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 ++++----
 mm/swapfile.c        |   40 +++++++++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff -puN include/linux/swap.h~swap_info-swap_map-of-chars-not-shorts include/linux/swap.h
--- a/include/linux/swap.h~swap_info-swap_map-of-chars-not-shorts
+++ a/include/linux/swap.h
@@ -151,9 +151,9 @@ enum {
 
 #define SWAP_CLUSTER_MAX 32
 
-#define SWAP_MAP_MAX	0x7ffe
-#define SWAP_MAP_BAD	0x7fff
-#define SWAP_HAS_CACHE  0x8000		/* There is a swap cache of entry. */
+#define SWAP_MAP_MAX	0x7e
+#define SWAP_MAP_BAD	0x7f
+#define SWAP_HAS_CACHE	0x80		/* There is a swap cache of entry. */
 
 /*
  * The in-memory structure used to track swap areas.
@@ -167,7 +167,7 @@ struct swap_info_struct {
 	struct block_device *bdev;
 	struct swap_extent first_swap_extent;
 	struct swap_extent *curr_swap_extent;
-	unsigned short *swap_map;
+	unsigned char *swap_map;
 	unsigned int lowest_bit;
 	unsigned int highest_bit;
 	unsigned int lowest_alloc;	/* while preparing discard cluster */
diff -puN mm/swapfile.c~swap_info-swap_map-of-chars-not-shorts mm/swapfile.c
--- a/mm/swapfile.c~swap_info-swap_map-of-chars-not-shorts
+++ a/mm/swapfile.c
@@ -53,7 +53,7 @@ static struct swap_info_struct *swap_inf
 
 static DEFINE_MUTEX(swapon_mutex);
 
-static inline int swap_count(unsigned short ent)
+static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;
 }
@@ -203,7 +203,7 @@ static int wait_for_discard(void *word)
 #define LATENCY_LIMIT		256
 
 static inline unsigned long scan_swap_map(struct swap_info_struct *si,
-					  unsigned short usage)
+					  unsigned char usage)
 {
 	unsigned long offset;
 	unsigned long scan_base;
@@ -531,12 +531,12 @@ out:
 	return NULL;
 }
 
-static unsigned short swap_entry_free(struct swap_info_struct *p,
-			   swp_entry_t entry, unsigned short usage)
+static unsigned char swap_entry_free(struct swap_info_struct *p,
+				     swp_entry_t entry, unsigned char usage)
 {
 	unsigned long offset = swp_offset(entry);
-	unsigned short count;
-	unsigned short has_cache;
+	unsigned char count;
+	unsigned char has_cache;
 
 	count = p->swap_map[offset];
 	has_cache = count & SWAP_HAS_CACHE;
@@ -591,7 +591,7 @@ void swap_free(swp_entry_t entry)
 void swapcache_free(swp_entry_t entry, struct page *page)
 {
 	struct swap_info_struct *p;
-	unsigned short count;
+	unsigned char count;
 
 	p = swap_info_get(entry);
 	if (p) {
@@ -975,7 +975,7 @@ static unsigned int find_next_to_unuse(s
 {
 	unsigned int max = si->max;
 	unsigned int i = prev;
-	int count;
+	unsigned char count;
 
 	/*
 	 * No need for swap_lock here: we're just looking
@@ -1013,8 +1013,8 @@ static int try_to_unuse(unsigned int typ
 {
 	struct swap_info_struct *si = swap_info[type];
 	struct mm_struct *start_mm;
-	unsigned short *swap_map;
-	unsigned short swcount;
+	unsigned char *swap_map;
+	unsigned char swcount;
 	struct page *page;
 	swp_entry_t entry;
 	unsigned int i = 0;
@@ -1174,6 +1174,12 @@ static int try_to_unuse(unsigned int typ
 		 * If that's wrong, then we should worry more about
 		 * exit_mmap() and do_munmap() cases described above:
 		 * we might be resetting SWAP_MAP_MAX too early here.
+		 *
+		 * Yes, that's wrong: though very unlikely, swap count 0x7ffe
+		 * could surely occur if pid_max raised from PID_MAX_DEFAULT;
+		 * and we are now lowering SWAP_MAP_MAX to 0x7e, making it
+		 * much easier to reach.  But the next patch will fix that.
+		 *
 		 * We know "Undead"s can happen, they're okay, so don't
 		 * report them; but do report if we reset SWAP_MAP_MAX.
 		 */
@@ -1492,7 +1498,7 @@ bad_bmap:
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	unsigned short *swap_map;
+	unsigned char *swap_map;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
@@ -1762,7 +1768,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	sector_t span;
 	unsigned long maxpages = 1;
 	unsigned long swapfilepages;
-	unsigned short *swap_map = NULL;
+	unsigned char *swap_map = NULL;
 	struct page *page = NULL;
 	struct inode *inode = NULL;
 	int did_down = 0;
@@ -1938,13 +1944,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap;
 
 	/* OK, set up the swap map and apply the bad block list */
-	swap_map = vmalloc(maxpages * sizeof(short));
+	swap_map = vmalloc(maxpages);
 	if (!swap_map) {
 		error = -ENOMEM;
 		goto bad_swap;
 	}
 
-	memset(swap_map, 0, maxpages * sizeof(short));
+	memset(swap_map, 0, maxpages);
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		int page_nr = swap_header->info.badpages[i];
 		if (page_nr <= 0 || page_nr >= swap_header->info.last_page) {
@@ -2082,12 +2088,12 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but there is already one. -> EEXIST
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  */
-static int __swap_duplicate(swp_entry_t entry, unsigned short usage)
+static int __swap_duplicate(swp_entry_t entry, unsigned char usage)
 {
 	struct swap_info_struct *p;
 	unsigned long offset, type;
-	unsigned short count;
-	unsigned short has_cache;
+	unsigned char count;
+	unsigned char has_cache;
 	int err = -EINVAL;
 
 	if (non_swap_entry(entry))
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

