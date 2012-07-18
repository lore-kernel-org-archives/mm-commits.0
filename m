From: akpm@linux-foundation.org
Subject: + ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch added to -mm tree
Date: Wed, 18 Jul 2012 14:05:27 -0700
Message-ID: <20120718210528.0A3045C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:35427 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2GRVFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 17:05:30 -0400
Received: by weyr1 with SMTP id r1so107285wey.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 14:05:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dledford@redhat.com


The patch titled
     Subject: ipc/mqueue: remove unnecessary rb_init_node() calls
has been added to the -mm tree.  Its filename is
     ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1041,7 +1040,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 
 	if (!info->node_cache && new_leaf) {
 		/* Save our speculative allocation into the cache */
-		rb_init_node(&new_leaf->rb_node);
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
@@ -1149,7 +1147,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 
 	if (!info->node_cache && new_leaf) {
 		/* Save our speculative allocation into the cache */
-		rb_init_node(&new_leaf->rb_node);
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
_
Subject: Subject: ipc/mqueue: remove unnecessary rb_init_node() calls

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch

