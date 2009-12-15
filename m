From: akpm@linux-foundation.org
Subject: [merged] swap_info-reorder-its-fields.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:51:57 -0800
Message-ID: <200912152151.nBFLpv2V015148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761348AbZLOWM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:12:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     swap_info: reorder its fields
has been removed from the -mm tree.  Its filename was
     swap_info-reorder-its-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swap_info: reorder its fields
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Reorder (and comment) the fields of swap_info_struct, to make better
use of its cachelines: it's good for swap_duplicate() in particular
if unsigned int max and swap_map are near the start.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/swap.h~swap_info-reorder-its-fields include/linux/swap.h
--- a/include/linux/swap.h~swap_info-reorder-its-fields
+++ a/include/linux/swap.h
@@ -167,21 +167,21 @@ struct swap_info_struct {
 	signed short	prio;		/* swap priority of this type */
 	signed char	type;		/* strange name for an index */
 	signed char	next;		/* next type on the swap list */
-	struct file *swap_file;
-	struct block_device *bdev;
-	struct swap_extent first_swap_extent;
-	struct swap_extent *curr_swap_extent;
-	unsigned char *swap_map;
-	unsigned int lowest_bit;
-	unsigned int highest_bit;
+	unsigned int	max;		/* extent of the swap_map */
+	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
+	unsigned int lowest_bit;	/* index of first free in swap_map */
+	unsigned int highest_bit;	/* index of last free in swap_map */
+	unsigned int pages;		/* total of usable pages of swap */
+	unsigned int inuse_pages;	/* number of those currently in use */
+	unsigned int cluster_next;	/* likely index for next allocation */
+	unsigned int cluster_nr;	/* countdown to next cluster search */
 	unsigned int lowest_alloc;	/* while preparing discard cluster */
 	unsigned int highest_alloc;	/* while preparing discard cluster */
-	unsigned int cluster_next;
-	unsigned int cluster_nr;
-	unsigned int pages;
-	unsigned int max;
-	unsigned int inuse_pages;
-	unsigned int old_block_size;
+	struct swap_extent *curr_swap_extent;
+	struct swap_extent first_swap_extent;
+	struct block_device *bdev;	/* swap device or bdev of swap file */
+	struct file *swap_file;		/* seldom referenced */
+	unsigned int old_block_size;	/* seldom referenced */
 };
 
 struct swap_list_t {
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

