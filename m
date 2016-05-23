From: akpm@linux-foundation.org
Subject: [merged] drivers-hwspinlock-use-correct-radix-tree-api.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:50:33 -0700
Message-ID: <57435f09.klM+xJSI0nu8eKes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbcEWTue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/hwspinlock: use correct radix tree API
has been removed from the -mm tree.  Its filename was
     drivers-hwspinlock-use-correct-radix-tree-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: drivers/hwspinlock: use correct radix tree API

radix_tree_is_indirect_ptr() is an internal API.  The correct call to use
is radix_tree_deref_retry() which has the appropriate unlikely()
annotation.

Fixes: c6400ba7e13a ("drivers/hwspinlock: fix race between radix tree insertion and lookup")
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwspinlock/hwspinlock_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwspinlock/hwspinlock_core.c~drivers-hwspinlock-use-correct-radix-tree-api drivers/hwspinlock/hwspinlock_core.c
--- a/drivers/hwspinlock/hwspinlock_core.c~drivers-hwspinlock-use-correct-radix-tree-api
+++ a/drivers/hwspinlock/hwspinlock_core.c
@@ -313,7 +313,7 @@ int of_hwspin_lock_get_id(struct device_
 		hwlock = radix_tree_deref_slot(slot);
 		if (unlikely(!hwlock))
 			continue;
-		if (radix_tree_is_indirect_ptr(hwlock)) {
+		if (radix_tree_deref_retry(hwlock)) {
 			slot = radix_tree_iter_retry(&iter);
 			continue;
 		}
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-miscellaneous-fixes.patch
radix-tree-split-node-path-into-offset-and-height.patch
radix-tree-replace-node-height-with-node-shift.patch
radix-tree-remove-a-use-of-root-height-from-delete_node.patch
radix-tree-test-suite-remove-dependencies-on-height.patch
radix-tree-remove-root-height.patch
radix-tree-rename-indirect_ptr-to-internal_node.patch
radix-tree-rename-ptr_to_indirect-to-node_to_entry.patch
radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch
radix-tree-rename-radix_tree_is_indirect_ptr.patch
radix-tree-change-naming-conventions-in-radix_tree_shrink.patch
radix-tree-tidy-up-next_chunk.patch
radix-tree-tidy-up-range_tag_if_tagged.patch
radix-tree-tidy-up-__radix_tree_create.patch
radix-tree-introduce-radix_tree_replace_clear_tags.patch
radix-tree-make-radix_tree_descend-more-useful.patch
radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

