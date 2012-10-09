From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:49 -0700
Message-ID: <20121009180850.637C8200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50789 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2JISIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:52 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so362977lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dledford@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: remove unnecessary rb_init_node() calls
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: ipc/mqueue: remove unnecessary rb_init_node() calls

d6629859 ("ipc/mqueue: improve performance of send/recv") and ce2d52cc
("ipc/mqueue: add rbtree node caching support") introduced an rbtree of
message priorities, and usage of rb_init_node() to initialize the
corresponding nodes.  As it turns out, rb_init_node() is unnecessary here,
as the nodes are fully initialized on insertion by rb_link_node() and the
code doesn't access nodes that aren't inserted on the rbtree.

Removing the rb_init_node() calls as I removed that function during
rbtree API cleanups (the only other use of it was in a place that similarly
didn't require it).

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-remove-unnecessary-rb_init_node-calls ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-remove-unnecessary-rb_init_node-calls
+++ a/ipc/mqueue.c
@@ -142,7 +142,6 @@ static int msg_insert(struct msg_msg *ms
 		leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
 		if (!leaf)
 			return -ENOMEM;
-		rb_init_node(&leaf->rb_node);
 		INIT_LIST_HEAD(&leaf->msg_list);
 		info->qsize += sizeof(*leaf);
 	}
@@ -1013,7 +1012,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 
 	if (!info->node_cache && new_leaf) {
 		/* Save our speculative allocation into the cache */
-		rb_init_node(&new_leaf->rb_node);
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
@@ -1121,7 +1119,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 
 	if (!info->node_cache && new_leaf) {
 		/* Save our speculative allocation into the cache */
-		rb_init_node(&new_leaf->rb_node);
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

