From: akpm@linux-foundation.org
Subject: + block-use-lockdep_assert_held-for-queue-locking.patch added to -mm tree
Date: Thu, 29 Mar 2012 14:38:41 -0700
Message-ID: <20120329213842.38696A05B5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35761 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245Ab2C2Vin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 17:38:43 -0400
Received: by yhgm50 with SMTP id m50so323182yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 14:38:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk


The patch titled
     Subject: block: use lockdep_assert_held() for queue locking
has been added to the -mm tree.  Its filename is
     block-use-lockdep_assert_held-for-queue-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: block: use lockdep_assert_held() for queue locking

Instead of an ugly open coded variant.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-throttle.c   |    2 +-
 include/linux/blkdev.h |   18 +++++++-----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff -puN block/blk-throttle.c~block-use-lockdep_assert_held-for-queue-locking block/blk-throttle.c
--- a/block/blk-throttle.c~block-use-lockdep_assert_held-for-queue-locking
+++ a/block/blk-throttle.c
@@ -993,7 +993,7 @@ void blk_throtl_drain(struct request_que
 	struct bio_list bl;
 	struct bio *bio;
 
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	bio_list_init(&bl);
 
diff -puN include/linux/blkdev.h~block-use-lockdep_assert_held-for-queue-locking include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-use-lockdep_assert_held-for-queue-locking
+++ a/include/linux/blkdev.h
@@ -435,14 +435,10 @@ struct request_queue {
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
 				 (1 << QUEUE_FLAG_ADD_RANDOM))
 
-static inline int queue_is_locked(struct request_queue *q)
+static inline void queue_lockdep_assert_held(struct request_queue *q)
 {
-#ifdef CONFIG_SMP
-	spinlock_t *lock = q->queue_lock;
-	return lock && spin_is_locked(lock);
-#else
-	return 1;
-#endif
+	if (q->queue_lock)
+		lockdep_assert_held(q->queue_lock);
 }
 
 static inline void queue_flag_set_unlocked(unsigned int flag,
@@ -454,7 +450,7 @@ static inline void queue_flag_set_unlock
 static inline int queue_flag_test_and_clear(unsigned int flag,
 					    struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	if (test_bit(flag, &q->queue_flags)) {
 		__clear_bit(flag, &q->queue_flags);
@@ -467,7 +463,7 @@ static inline int queue_flag_test_and_cl
 static inline int queue_flag_test_and_set(unsigned int flag,
 					  struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	if (!test_bit(flag, &q->queue_flags)) {
 		__set_bit(flag, &q->queue_flags);
@@ -479,7 +475,7 @@ static inline int queue_flag_test_and_se
 
 static inline void queue_flag_set(unsigned int flag, struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 	__set_bit(flag, &q->queue_flags);
 }
 
@@ -496,7 +492,7 @@ static inline int queue_in_flight(struct
 
 static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 	__clear_bit(flag, &q->queue_flags);
 }
 
_
Subject: Subject: block: use lockdep_assert_held() for queue locking

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
brlocks-lglocks-cleanups.patch
block-use-lockdep_assert_held-for-queue-locking.patch
sgi-xp-use-lockdep_assert_held.patch
ada152x-remove-broken-usage-of-spin_is_locked.patch
xfs-fix-lock-assert-on-up.patch
huge-memory-use-lockdep_assert_held.patch
futex-use-lockdep_assert_held-for-lock-checking.patch
irda-remove-spin_is_locked.patch
smsc911x-use-lockdep_assert_held-instead-of-home-grown-buggy-construct.patch
add-a-discussion-on-why-spin_is_locked-is-bad-to-spinlockstxt.patch
add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-usage.patch
checkpatch-check-for-spin_is_locked.patch

