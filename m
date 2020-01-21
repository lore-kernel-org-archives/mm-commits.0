From: akpm@linux-foundation.org
Subject: [failures]
 lib-rbtree-avoid-pointless-rb_node-alignment.patch removed from -mm tree
Date: Tue, 21 Jan 2020 13:27:39 -0800
Message-ID: <20200121212739.MJ84H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbgAUV1k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jan 2020 16:27:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, Jason@zx2c4.com, geert@linux-m68k.org, dbueso@suse.de, akpm@linux-foundation.org, dave@stgolabs.net


The patch titled
     Subject: include/linux/rbtree.h: avoid pointless rb_node alignment
has been removed from the -mm tree.  Its filename was
     lib-rbtree-avoid-pointless-rb_node-alignment.patch

This patch was dropped because it had testing failures

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

ipc-mqueuec-remove-duplicated-code.patch
