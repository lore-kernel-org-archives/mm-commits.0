From: akpm@linux-foundation.org
Subject: [merged] block-use-lockdep_assert_held-for-queue-locking.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:46 -0700
Message-ID: <20120416201546.5C631A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47053 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2DPUPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:48 -0400
Received: by wejx9 with SMTP id x9so258632wej.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: use lockdep_assert_held() for queue locking
has been removed from the -mm tree.  Its filename was
     block-use-lockdep_assert_held-for-queue-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1218,7 +1218,7 @@ void blk_throtl_drain(struct request_que
 	struct bio_list bl;
 	struct bio *bio;
 
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	bio_list_init(&bl);
 
diff -puN include/linux/blkdev.h~block-use-lockdep_assert_held-for-queue-locking include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-use-lockdep_assert_held-for-queue-locking
+++ a/include/linux/blkdev.h
@@ -426,14 +426,10 @@ struct request_queue {
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
@@ -445,7 +441,7 @@ static inline void queue_flag_set_unlock
 static inline int queue_flag_test_and_clear(unsigned int flag,
 					    struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	if (test_bit(flag, &q->queue_flags)) {
 		__clear_bit(flag, &q->queue_flags);
@@ -458,7 +454,7 @@ static inline int queue_flag_test_and_cl
 static inline int queue_flag_test_and_set(unsigned int flag,
 					  struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 
 	if (!test_bit(flag, &q->queue_flags)) {
 		__set_bit(flag, &q->queue_flags);
@@ -470,7 +466,7 @@ static inline int queue_flag_test_and_se
 
 static inline void queue_flag_set(unsigned int flag, struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 	__set_bit(flag, &q->queue_flags);
 }
 
@@ -487,7 +483,7 @@ static inline int queue_in_flight(struct
 
 static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 {
-	WARN_ON_ONCE(!queue_is_locked(q));
+	queue_lockdep_assert_held(q);
 	__clear_bit(flag, &q->queue_flags);
 }
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
brlocks-lglocks-cleanups.patch
sgi-xp-use-lockdep_assert_held.patch
drivers-scsi-aha152xc-remove-broken-usage-of-spin_is_locked.patch
xfs-fix-lock-assert-on-up.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
futex-use-lockdep_assert_held-for-lock-checking.patch
drivers-net-irda-sir_devc-remove-spin_is_locked.patch
drivers-net-ethernet-smsc-smsc911xh-use-lockdep_assert_held-instead-of-home-grown-buggy-construct.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch
checkpatch-check-for-spin_is_locked.patch

