From: akpm@linux-foundation.org
Subject: [patch 109/162] radix-tree: fix deleting a multi-order entry
 through an alias
Date: Fri, 20 May 2016 17:02:02 -0700
Message-ID: <573fa57a.e+lBtUbMgTsqGJ9e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcEUACE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix deleting a multi-order entry through an alias

If we deleted an entry through an index which looked up a sibling pointer,
we'd end up zeroing out the wrong slots in the node.  Use
get_slot_offset() to find the right slot.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~radix-tree-fix-deleting-a-multi-order-entry-through-an-alias lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-deleting-a-multi-order-entry-through-an-alias
+++ a/lib/radix-tree.c
@@ -1558,7 +1558,7 @@ void *radix_tree_delete_item(struct radi
 		return entry;
 	}
 
-	offset = index & RADIX_TREE_MAP_MASK;
+	offset = get_slot_offset(node, slot);
 
 	/*
 	 * Clear all tags associated with the item to be deleted.
_
