From: akpm@linux-foundation.org
Subject: + lib-rhashtable-fix-comment-on-locks_mul-default-value.patch
 added to -mm tree
Date: Tue, 15 Aug 2017 15:00:06 -0700
Message-ID: <59936ee6.Hql/I+tm/GBoZU8W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdHOWAH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 18:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, fw@strlen.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rhashtable: fix comment on locks_mul default value
has been added to the -mm tree.  Its filename is
     lib-rhashtable-fix-comment-on-locks_mul-default-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rhashtable-fix-comment-on-locks_mul-default-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rhashtable-fix-comment-on-locks_mul-default-value.patch

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
Subject: lib/rhashtable: fix comment on locks_mul default value

As of 4cf0b354d92 ("rhashtable: avoid large lock-array allocations"), the
default value for the locks multiplier was reduced from 128 to 32.  Update
the header file to reflect this.

Link: http://lkml.kernel.org/r/20170815215401.30745-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rhashtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rhashtable.h~lib-rhashtable-fix-comment-on-locks_mul-default-value include/linux/rhashtable.h
--- a/include/linux/rhashtable.h~lib-rhashtable-fix-comment-on-locks_mul-default-value
+++ a/include/linux/rhashtable.h
@@ -127,7 +127,7 @@ struct rhashtable;
  * @head_offset: Offset of rhash_head in struct to be hashed
  * @max_size: Maximum size while expanding
  * @min_size: Minimum size while shrinking
- * @locks_mul: Number of bucket locks to allocate per cpu (default: 128)
+ * @locks_mul: Number of bucket locks to allocate per cpu (default: 32)
  * @automatic_shrinking: Enable automatic shrinking of tables
  * @nulls_base: Base value to generate nulls marker
  * @hashfn: Hash function (default: jhash2 if !(key_len % 4), or jhash)
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
lib-rhashtable-fix-comment-on-locks_mul-default-value.patch
ipc-sem-drop-sem_checkid-helper.patch
ipc-sem-play-nicer-with-large-nsops-allocations.patch

