From: akpm@linux-foundation.org
Subject: + radix-tree-fix-oops-after-radix_tree_iter_retry.patch added to
 -mm tree
Date: Fri, 05 Feb 2016 14:19:44 -0800
Message-ID: <56b52000.iwRb3fty430epDOq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbcBEWTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 17:19:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, jmmahler@gmail.com, ohad@wizery.com, stable@vger.kernel.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix oops after radix_tree_iter_retry
has been added to the -mm tree.  Its filename is
     radix-tree-fix-oops-after-radix_tree_iter_retry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-fix-oops-after-radix_tree_iter_retry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-fix-oops-after-radix_tree_iter_retry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: radix-tree: fix oops after radix_tree_iter_retry

Helper radix_tree_iter_retry() resets next_index to the current index.  In
following radix_tree_next_slot current chunk size becomes zero.  This
isn't checked and it tries to dereference null pointer in slot.

Tagged iterator is fine because retry happens only at slot 0 where tag
bitmask in iter->tags is filled with single bit.

Fixes: 46437f9a554f ("radix-tree: fix race in gang lookup")
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-fix-oops-after-radix_tree_iter_retry include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-fix-oops-after-radix_tree_iter_retry
+++ a/include/linux/radix-tree.h
@@ -400,7 +400,7 @@ void **radix_tree_iter_retry(struct radi
  * @iter:	pointer to radix tree iterator
  * Returns:	current chunk size
  */
-static __always_inline unsigned
+static __always_inline long
 radix_tree_chunk_size(struct radix_tree_iter *iter)
 {
 	return iter->next_index - iter->index;
@@ -434,9 +434,9 @@ radix_tree_next_slot(void **slot, struct
 			return slot + offset + 1;
 		}
 	} else {
-		unsigned size = radix_tree_chunk_size(iter) - 1;
+		long size = radix_tree_chunk_size(iter);
 
-		while (size--) {
+		while (--size > 0) {
 			slot++;
 			iter->index++;
 			if (likely(*slot))
_

Patches currently in -mm which might be from koct9i@gmail.com are

mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write.patch
radix-tree-fix-oops-after-radix_tree_iter_retry.patch

