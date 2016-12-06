From: akpm@linux-foundation.org
Subject: + radix-tree-make-radix_tree_find_next_bit-more-useful.patch
 added to -mm tree
Date: Tue, 06 Dec 2016 12:50:42 -0800
Message-ID: <584724a2.nR11ZMWrs9JAMTPY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUuM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: make radix_tree_find_next_bit more useful
has been added to the -mm tree.  Its filename is
     radix-tree-make-radix_tree_find_next_bit-more-useful.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-make-radix_tree_find_next_bit-more-useful.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-make-radix_tree_find_next_bit-more-useful.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-make-radix_tree_find_next_bit-more-useful lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-make-radix_tree_find_next_bit-more-useful
+++ a/lib/radix-tree.c
@@ -190,13 +190,12 @@ static inline int any_tag_set(struct rad
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
@@ -204,14 +203,14 @@ radix_tree_find_next_bit(const unsigned
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
@@ -1159,9 +1158,7 @@ void **radix_tree_next_chunk(struct radi
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

tools-add-warn_on_once.patch
radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch
tools-add-more-bitmap-functions.patch
radix-tree-test-suite-use-common-find-bit-code.patch
radix-tree-fix-typo.patch
radix-tree-create-node_tag_set.patch
radix-tree-make-radix_tree_find_next_bit-more-useful.patch
radix-tree-add-radix_tree_join.patch
radix-tree-add-radix_tree_split.patch
radix-tree-add-radix_tree_split_preload.patch
idr-add-ida_is_empty.patch
idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch
radix-tree-test-suite-add-some-more-functionality.patch
reimplement-idr-and-ida-using-the-radix-tree.patch

