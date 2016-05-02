From: akpm@linux-foundation.org
Subject: + radix-tree-rewrite-radix_tree_locate_item-fix.patch added to
 -mm tree
Date: Mon, 02 May 2016 14:45:17 -0700
Message-ID: <5727ca6d.8gasCuaj5lBR3ngK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbcEBVpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 May 2016 17:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: rewrite radix_tree_locate_item fix
has been added to the -mm tree.  Its filename is
     radix-tree-rewrite-radix_tree_locate_item-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-rewrite-radix_tree_locate_item-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-rewrite-radix_tree_locate_item-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: radix-tree: rewrite radix_tree_locate_item fix

radix_tree_locate_item() is often returning the wrong index, causing
swapoff of shmem to hang because it cannot find the swap entry there.
__locate()'s use of base is bogus, it adds an offset twice into index.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1605012108490.1166@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-radix_tree_locate_item-fix lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-radix_tree_locate_item-fix
+++ a/lib/radix-tree.c
@@ -1315,18 +1315,17 @@ static unsigned long __locate(struct rad
 			      unsigned long index, struct locate_info *info)
 {
 	unsigned int shift, height;
-	unsigned long base, i;
+	unsigned long i;
 
 	height = slot->path & RADIX_TREE_HEIGHT_MASK;
 	shift = height * RADIX_TREE_MAP_SHIFT;
 
 	do {
 		shift -= RADIX_TREE_MAP_SHIFT;
-		base = index & ~((1UL << shift) - 1);
 
 		for (i = (index >> shift) & RADIX_TREE_MAP_MASK;
 		     i < RADIX_TREE_MAP_SIZE;
-		     i++, index = base + (i << shift)) {
+		     i++, index += (1UL << shift)) {
 			struct radix_tree_node *node =
 					rcu_dereference_raw(slot->slots[i]);
 			if (node == RADIX_TREE_RETRY)
_

Patches currently in -mm which might be from hughd@google.com are

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-cma-prevent-nr_isolated_-counters-from-going-negative.patch
mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
radix-tree-rewrite-radix_tree_locate_item-fix.patch

