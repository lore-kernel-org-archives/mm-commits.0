From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-make-radix_tree_find_next_bit-more-useful.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:48:41 -0800
Message-ID: <5852e589.4EHBlSudhsH1Bxe7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754068AbcLOSsm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: make radix_tree_find_next_bit more useful
has been removed from the -mm tree.  Its filename was
     radix-tree-make-radix_tree_find_next_bit-more-useful.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: make radix_tree_find_next_bit more useful

Since this function is specialised to the radix tree, pass in the node and
tag to calculate the address of the bitmap in radix_tree_find_next_bit()
instead of the caller.  Likewise, there is no need to pass in the size of
the bitmap.

Link: http://lkml.kernel.org/r/1480369871-5271-52-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-make-radix_tree_find_next_bit-more-useful lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-make-radix_tree_find_next_bit-more-useful
+++ a/lib/radix-tree.c
@@ -191,13 +191,12 @@ static inline int any_tag_set(struct rad
  * Returns next bit offset, or size if nothing found.
  */
 static __always_inline unsigned long
-radix_tree_find_next_bit(const unsigned long *addr,
-			 unsigned long size, unsigned long offset)
+radix_tree_find_next_bit(struct radix_tree_node *node, unsigned int tag,
+			 unsigned long offset)
 {
-	if (!__builtin_constant_p(size))
-		return find_next_bit(addr, size, offset);
+	const unsigned long *addr = node->tags[tag];
 
-	if (offset < size) {
+	if (offset < RADIX_TREE_MAP_SIZE) {
 		unsigned long tmp;
 
 		addr += offset / BITS_PER_LONG;
@@ -205,14 +204,14 @@ radix_tree_find_next_bit(const unsigned
 		if (tmp)
 			return __ffs(tmp) + offset;
 		offset = (offset + BITS_PER_LONG) & ~(BITS_PER_LONG - 1);
-		while (offset < size) {
+		while (offset < RADIX_TREE_MAP_SIZE) {
 			tmp = *++addr;
 			if (tmp)
 				return __ffs(tmp) + offset;
 			offset += BITS_PER_LONG;
 		}
 	}
-	return size;
+	return RADIX_TREE_MAP_SIZE;
 }
 
 #ifndef __KERNEL__
@@ -1160,9 +1159,7 @@ void **radix_tree_next_chunk(struct radi
 				return NULL;
 
 			if (flags & RADIX_TREE_ITER_TAGGED)
-				offset = radix_tree_find_next_bit(
-						node->tags[tag],
-						RADIX_TREE_MAP_SIZE,
+				offset = radix_tree_find_next_bit(node, tag,
 						offset + 1);
 			else
 				while (++offset	< RADIX_TREE_MAP_SIZE) {
_

Patches currently in -mm which might be from willy@linux.intel.com are

reimplement-idr-and-ida-using-the-radix-tree.patch

