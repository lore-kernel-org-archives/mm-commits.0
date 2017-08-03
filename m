From: akpm@linux-foundation.org
Subject: + ipc-sem-drop-sem_checkid-helper.patch added to -mm tree
Date: Thu, 03 Aug 2017 14:52:59 -0700
Message-ID: <59839b3b.P5q13XsX+yiusfxg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdHCVxA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 17:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: drop sem_checkid helper
has been added to the -mm tree.  Its filename is
     ipc-sem-drop-sem_checkid-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-drop-sem_checkid-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-drop-sem_checkid-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: drop sem_checkid helper

... 'tis not used.

Link: http://lkml.kernel.org/r/20170803184136.13855-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN ipc/sem.c~ipc-sem-drop-sem_checkid-helper ipc/sem.c
--- a/ipc/sem.c~ipc-sem-drop-sem_checkid-helper
+++ a/ipc/sem.c
@@ -130,8 +130,6 @@ struct sem_undo_list {
 
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
-#define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
-
 static int newary(struct ipc_namespace *, struct ipc_params *);
 static void freeary(struct ipc_namespace *, struct kern_ipc_perm *);
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
rbtree-optimize-root-check-during-rebalancing-loop.patch
rbtree-add-some-additional-comments-for-rebalancing-cases.patch
lib-rbtree_testc-make-input-module-parameters.patch
lib-rbtree_testc-add-inorder-traversal-test.patch
lib-rbtree_testc-support-rb_root_cached.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch
mem-memcg-cache-rightmost-node.patch
mem-memcg-cache-rightmost-node-fix.patch
block-cfq-cache-rightmost-rb_node.patch
block-cfq-cache-rightmost-rb_node-fix.patch
ipc-sem-drop-sem_checkid-helper.patch
ipc-sem-play-nicer-with-large-nsops-allocations.patch

