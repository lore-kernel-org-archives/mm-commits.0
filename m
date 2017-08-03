From: akpm@linux-foundation.org
Subject: + ipc-sem-play-nicer-with-large-nsops-allocations.patch added to
 -mm tree
Date: Thu, 03 Aug 2017 14:53:01 -0700
Message-ID: <59839b3d.J3z4Z98K/BqNcVjV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdHCVxC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 17:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: play nicer with large nsops allocations
has been added to the -mm tree.  Its filename is
     ipc-sem-play-nicer-with-large-nsops-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-play-nicer-with-large-nsops-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-play-nicer-with-large-nsops-allocations.patch

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
Subject: ipc/sem: play nicer with large nsops allocations

Replacing semop()'s kmalloc for kvmalloc was originally proposed by
Manfred on the premise that it can be called for large (than order-1)
sizes.  For example, while Oracle recommends setting SEMOPM to a _minimum_
of 100, some distros[1] encourage the setting to be a factor of the amount
of db tasks (PROCESSES), which can get fishy for large systems (easily
going beyond 1000).

[1] An Example of Semaphore Settings
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-An_Example_of_Semaphore_Settings.html

So let's just convert this to kvmalloc, just like the rest of the
allocations we do in ipc.  While the fallback vmalloc obviously involves
more overhead, this by far the uncommon path, and it's better for the user
than just erroring out with kmalloc.

Link: http://lkml.kernel.org/r/20170803184136.13855-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-sem-play-nicer-with-large-nsops-allocations ipc/sem.c
--- a/ipc/sem.c~ipc-sem-play-nicer-with-large-nsops-allocations
+++ a/ipc/sem.c
@@ -1784,7 +1784,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if (nsops > SEMOPM_FAST) {
-		sops = kmalloc(sizeof(*sops)*nsops, GFP_KERNEL);
+		sops = kvmalloc(sizeof(*sops)*nsops, GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
@@ -2016,7 +2016,7 @@ out_unlock_free:
 	rcu_read_unlock();
 out_free:
 	if (sops != fast_sops)
-		kfree(sops);
+		kvfree(sops);
 	return error;
 }
 
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

