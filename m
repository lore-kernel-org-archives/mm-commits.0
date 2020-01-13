From: akpm@linux-foundation.org
Subject: + lib-rbtree-avoid-pointless-rb_node-alignment.patch added
 to -mm tree
Date: Mon, 13 Jan 2020 14:57:53 -0800
Message-ID: <20200113225753.FP2Rg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbgAMW5y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 17:57:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dbueso@suse.de, akpm@linux-foundation.org, dave@stgolabs.net


The patch titled
     Subject: include/linux/rbtree.h: avoid pointless rb_node alignment
has been added to the -mm tree.  Its filename is
     lib-rbtree-avoid-pointless-rb_node-alignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rbtree-avoid-pointless-rb_node-alignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rbtree-avoid-pointless-rb_node-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: include/linux/rbtree.h: avoid pointless rb_node alignment

Now that Linux no longer supports the CRIS architecture, we can drop this
fishy alignment.  Apparently this was need to prevent misalignments in
struct address_space.

Link: http://lkml.kernel.org/r/20200110215429.30360-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/rbtree.h~lib-rbtree-avoid-pointless-rb_node-alignment
+++ a/include/linux/rbtree.h
@@ -25,8 +25,7 @@ struct rb_node {
 	unsigned long  __rb_parent_color;
 	struct rb_node *rb_right;
 	struct rb_node *rb_left;
-} __attribute__((aligned(sizeof(long))));
-    /* The alignment might seem pointless, but allegedly CRIS needs it */
+};
 
 struct rb_root {
 	struct rb_node *rb_node;
_

Patches currently in -mm which might be from dave@stgolabs.net are

lib-rbtree-avoid-pointless-rb_node-alignment.patch
ipc-mqueuec-remove-duplicated-code.patch
