From: akpm@linux-foundation.org
Subject: + swap_info-reorder-its-fields.patch added to -mm tree
Date: Thu, 15 Oct 2009 12:46:04 -0700
Message-ID: <200910151946.n9FJk4M9025985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935354AbZJOTq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 15:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     swap_info: reorder its fields
has been added to the -mm tree.  Its filename is
     swap_info-reorder-its-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
hwpoison-fix-oops-on-ksm-pages.patch
hwpoison-fix-proc-meminfo-alignment.patch
vmscan-limit-vm_exec-protection-to-file-pages.patch
mm-order-evictable-rescue-in-lru-putback.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

