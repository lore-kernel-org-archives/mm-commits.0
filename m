From: akpm@linux-foundation.org
Subject: + radix-tree-remove-unused-looping-macros.patch added to -mm tree
Date: Fri, 15 Apr 2016 22:58:08 -0700
Message-ID: <5711d470.nQkk549AjwIzL4f6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcDPF6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: remove unused looping macros
has been added to the -mm tree.  Its filename is
     radix-tree-remove-unused-looping-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-remove-unused-looping-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-remove-unused-looping-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: remove unused looping macros

radix_tree_for_each_chunk() and radix_tree_for_each_chunk_slot() have
never been used in the kernel since their introduction in 2012, so remove
them.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-remove-unused-looping-macros include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-remove-unused-looping-macros
+++ a/include/linux/radix-tree.h
@@ -479,34 +479,6 @@ radix_tree_next_slot(void **slot, struct
 }
 
 /**
- * radix_tree_for_each_chunk - iterate over chunks
- *
- * @slot:	the void** variable for pointer to chunk first slot
- * @root:	the struct radix_tree_root pointer
- * @iter:	the struct radix_tree_iter pointer
- * @start:	iteration starting index
- * @flags:	RADIX_TREE_ITER_* and tag index
- *
- * Locks can be released and reacquired between iterations.
- */
-#define radix_tree_for_each_chunk(slot, root, iter, start, flags)	\
-	for (slot = radix_tree_iter_init(iter, start) ;			\
-	      (slot = radix_tree_next_chunk(root, iter, flags)) ;)
-
-/**
- * radix_tree_for_each_chunk_slot - iterate over slots in one chunk
- *
- * @slot:	the void** variable, at the beginning points to chunk first slot
- * @iter:	the struct radix_tree_iter pointer
- * @flags:	RADIX_TREE_ITER_*, should be constant
- *
- * This macro is designed to be nested inside radix_tree_for_each_chunk().
- * @slot points to the radix tree slot, @iter->index contains its index.
- */
-#define radix_tree_for_each_chunk_slot(slot, iter, flags)		\
-	for (; slot ; slot = radix_tree_next_slot(slot, iter, flags))
