From: akpm@linux-foundation.org
Subject: - md-dm-reduce-stack-usage-with-stacked-block-devices.patch removed from -mm tree
Date: Fri, 11 May 2007 22:37:13 -0700
Message-ID: <200705120537.l4C5bDfE002444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbXELFha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, agk@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     md/dm: Reduce stack usage with stacked block devices
has been removed from the -mm tree.  Its filename was
     md-dm-reduce-stack-usage-with-stacked-block-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md/dm: Reduce stack usage with stacked block devices
From: Neil Brown <neilb@suse.de>

When stacked block devices are in-use (e.g.  md or dm), the recursive calls
to generic_make_request can use up a lot of space, and we would rather they
didn't.

As generic_make_request is a void function, and as it is generally not
expected that it will have any effect immediately, it is safe to delay any
call to generic_make_request until there is sufficient stack space
available.

As ->bi_next is reserved for the driver to use, it can have no valid value
when generic_make_request is called, and as __make_request implicitly
assumes it will be NULL (ELEVATOR_BACK_MERGE fork of switch) we can be
certain that all callers set it to NULL.  We can therefore safely use
bi_next to link pending requests together, providing we clear it before
making the real call.

So, we choose to allow each thread to only be active in one
generic_make_request at a time.  If a subsequent (recursive) call is made,
the bio is linked into a per-thread list, and is handled when the active
call completes.

As the list of pending bios is per-thread, there are no locking issues to
worry about.

I say above that it is "safe to delay any call...".  There are, however,
some behaviours of a make_request_fn which would make it unsafe.  These
include any behaviour that assumes anything will have changed after a
recursive call to generic_make_request.

These could include:
 - waiting for that call to finish and call it's bi_end_io function.
   md use to sometimes do this (marking the superblock dirty before
   completing a write) but doesn't any more
 - inspecting the bio for fields that generic_make_request might
   change, such as bi_sector or bi_bdev.  It is hard to see a good
   reason for this, and I don't think anyone actually does it.
 - inspecing the queue to see if, e.g. it is 'full' yet.  Again, I
   think this is very unlikely to be useful, or to be done.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <dm-devel@redhat.com>

Alasdair G Kergon <agk@redhat.com> said:

 I can see nothing wrong with this in principle.

 For device-mapper at the moment though it's essential that, while the bio 
 mappings may now get delayed, they still get processed in exactly
 the same order as they were passed to generic_make_request().

 My main concern is whether the timing changes implicit in this patch
 will make the rare data-corrupting races in the existing snapshot code
 more likely. (I'm working on a fix for these races, but the unfinished
 patch is already several hundred lines long.)

 It would be helpful if some people on this mailing list would test 
 this patch in various scenarios and report back.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c     |   53 +++++++++++++++++++++++++++++++++++++++-
 include/linux/sched.h |    4 +++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff -puN block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices
+++ a/block/ll_rw_blk.c
@@ -3116,7 +3116,7 @@ static inline int should_fail_request(st
  * bi_sector for remaps as it sees fit.  So the values of these fields
  * should NOT be depended on after the call to generic_make_request.
  */
-void generic_make_request(struct bio *bio)
+static inline void __generic_make_request(struct bio *bio)
 {
 	request_queue_t *q;
 	sector_t maxsector;
@@ -3215,6 +3215,57 @@ end_io:
 	} while (ret);
 }
 
+/*
+ * We only want one ->make_request_fn to be active at a time,
+ * else stack usage with stacked devices could be a problem.
+ * So use current->bio_{list,tail} to keep a list of requests
+ * submited by a make_request_fn function.
+ * current->bio_tail is also used as a flag to say if
+ * generic_make_request is currently active in this task or not.
+ * If it is NULL, then no make_request is active.  If it is non-NULL,
+ * then a make_request is active, and new requests should be added
+ * at the tail
+ */
+void generic_make_request(struct bio *bio)
+{
+	if (current->bio_tail) {
+		/* make_request is active */
+		*(current->bio_tail) = bio;
+		bio->bi_next = NULL;
+		current->bio_tail = &bio->bi_next;
+		return;
+	}
+	/* following loop may be a bit non-obvious, and so deserves some
+	 * explanation.
+	 * Before entering the loop, bio->bi_next is NULL (as all callers
+	 * ensure that) so we have a list with a single bio.
+	 * We pretend that we have just taken it off a longer list, so
+	 * we assign bio_list to the next (which is NULL) and bio_tail
+	 * to &bio_list, thus initialising the bio_list of new bios to be
+	 * added.  __generic_make_request may indeed add some more bios
+	 * through a recursive call to generic_make_request.  If it
+	 * did, we find a non-NULL value in bio_list and re-enter the loop
+	 * from the top.  In this case we really did just take the bio
+	 * of the top of the list (no pretending) and so fixup bio_list and
+	 * bio_tail or bi_next, and call into __generic_make_request again.
+	 *
+	 * The loop was structured like this to make only one call to
+	 * __generic_make_request (which is important as it is large and
+	 * inlined) and to keep the structure simple.
+	 */
+	BUG_ON(bio->bi_next);
+	do {
+		current->bio_list = bio->bi_next;
+		if (bio->bi_next == NULL)
+			current->bio_tail = &current->bio_list;
+		else
+			bio->bi_next = NULL;
+		__generic_make_request(bio);
+		bio = current->bio_list;
+	} while (bio);
+	current->bio_tail = NULL; /* deactivate */
+}
+
 EXPORT_SYMBOL(generic_make_request);
 
 /**
diff -puN include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices include/linux/sched.h
--- a/include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices
+++ a/include/linux/sched.h
@@ -88,6 +88,7 @@ struct sched_param {
 
 struct exec_domain;
 struct futex_pi_state;
+struct bio;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1033,6 +1034,9 @@ struct task_struct {
 /* journalling filesystem info */
 	void *journal_info;
 
+/* stacked block device info */
+	struct bio *bio_list, **bio_tail;
+
 /* VM state */
 	struct reclaim_state *reclaim_state;
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-md-accel.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
use-menuconfig-objects-ii-md.patch
