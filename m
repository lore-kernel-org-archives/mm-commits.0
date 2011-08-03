From: akpm@linux-foundation.org
Subject: [folded] mm-a-few-small-updates-for-radix-swap-fix.patch removed from -mm tree
Date: Wed, 03 Aug 2011 16:16:32 -0700
Message-ID: <201108032316.p73NGWId021797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773Ab1HCXQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 19:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: a few small updates for radix-swap fix
has been removed from the -mm tree.  Its filename was
     mm-a-few-small-updates-for-radix-swap-fix.patch

This patch was dropped because it was folded into mm-a-few-small-updates-for-radix-swap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: a few small updates for radix-swap fix
From: Hugh Dickins <hughd@google.com>

Fix NULL dereference I introduced in mincore_page().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/mincore.c~mm-a-few-small-updates-for-radix-swap-fix mm/mincore.c
--- a/mm/mincore.c~mm-a-few-small-updates-for-radix-swap-fix
+++ a/mm/mincore.c
@@ -71,13 +71,13 @@ static unsigned char mincore_page(struct
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
 	page = find_get_page(mapping, pgoff);
-	if (page) {
 #ifdef CONFIG_SWAP
-		if (radix_tree_exceptional_entry(page)) {
-			swp_entry_t swap = radix_to_swp_entry(page);
-			page = find_get_page(&swapper_space, swap.val);
-		}
+	if (radix_tree_exceptional_entry(page)) {
+		swp_entry_t swap = radix_to_swp_entry(page);
+		page = find_get_page(&swapper_space, swap.val);
+	}
 #endif
+	if (page) {
 		present = PageUptodate(page);
 		page_cache_release(page);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
tmpfs-radix_tree-locate_item-to-speed-up-swapoff.patch
mm-clarify-the-radix_tree-exceptional-cases.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch

