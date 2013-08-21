From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-add-strictlimit-feature.patch added to -mm
 tree
Date: Wed, 21 Aug 2013 13:41:01 -0700
Message-ID: <521525dd.i+BxV1cTsTMzLpy9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3HUUlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Aug 2013 16:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, miklos@szeredi.hu, jack@suse.cz, fengguang.wu@intel.com, MPatlasov@parallels.com, James.Bottomley@HansenPartnership.com, mpatlasov@parallels.com

Subject: + mm-page-writebackc-add-strictlimit-feature.patch added to -mm tree
To: mpatlasov@parallels.com,James.Bottomley@HansenPartnership.com,MPatlasov@parallels.com,fengguang.wu@intel.com,jack@suse.cz,miklos@szeredi.hu,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 21 Aug 2013 13:41:01 -0700


The patch titled
     Subject: mm/page-writeback.c: add strictlimit feature
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-add-strictlimit-feature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-add-strictlimit-feature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-add-strictlimit-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxim Patlasov <mpatlasov@parallels.com>
Subject: mm/page-writeback.c: add strictlimit feature

The feature prevents mistrusted filesystems to grow a large number of
dirty pages before throttling.  For such filesystems balance_dirty_pages
always check bdi counters against bdi limits.  I.e.  even if global
"nr_dirty" is under "freerun", it's not allowed to skip bdi checks.  The
only use case for now is fuse: it sets bdi max_ratio to 1% by default and
system administrators are supposed to expect that this limit won't be
exceeded.

The feature is on if a BDI is marked by BDI_CAP_STRICTLIMIT flag.  A
filesystem may set the flag when it initializes its BDI.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c             |    2 
 include/linux/backing-dev.h |    3 
 mm/page-writeback.c         |  261 ++++++++++++++++++++++++++--------
 3 files changed, 205 insertions(+), 61 deletions(-)

diff -puN fs/fuse/inode.c~mm-strictlimit-feature-v4 fs/fuse/inode.c
--- a/fs/fuse/inode.c~mm-strictlimit-feature-v4
+++ a/fs/fuse/inode.c
@@ -929,7 +929,7 @@ static int fuse_bdi_init(struct fuse_con
 	fc->bdi.name = "fuse";
 	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	/* fuse does it's own writeback accounting */
-	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
+	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB | BDI_CAP_STRICTLIMIT;
 
 	err = bdi_init(&fc->bdi);
 	if (err)
diff -puN include/linux/backing-dev.h~mm-strictlimit-feature-v4 include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-strictlimit-feature-v4
+++ a/include/linux/backing-dev.h
@@ -243,6 +243,8 @@ int bdi_set_max_ratio(struct backing_dev
  * BDI_CAP_EXEC_MAP:       Can be mapped for execution
  *
  * BDI_CAP_SWAP_BACKED:    Count shmem/tmpfs objects as swap-backed.
+ *
+ * BDI_CAP_STRICTLIMIT:    Keep number of dirty pages below bdi threshold.
  */
 #define BDI_CAP_NO_ACCT_DIRTY	0x00000001
 #define BDI_CAP_NO_WRITEBACK	0x00000002
@@ -254,6 +256,7 @@ int bdi_set_max_ratio(struct backing_dev
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
 #define BDI_CAP_STABLE_WRITES	0x00000200
+#define BDI_CAP_STRICTLIMIT	0x00000400
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
diff -puN mm/page-writeback.c~mm-strictlimit-feature-v4 mm/page-writeback.c
--- a/mm/page-writeback.c~mm-strictlimit-feature-v4
+++ a/mm/page-writeback.c
@@ -585,6 +585,37 @@ unsigned long bdi_dirty_limit(struct bac
 }
 
 /*
+ *                           setpoint - dirty 3
+ *        f(dirty) := 1.0 + (----------------)
+ *                           limit - setpoint
+ *
+ * it's a 3rd order polynomial that subjects to
+ *
+ * (1) f(freerun)  = 2.0 => rampup dirty_ratelimit reasonably fast
+ * (2) f(setpoint) = 1.0 => the balance point
+ * (3) f(limit)    = 0   => the hard limit
+ * (4) df/dx      <= 0	 => negative feedback control
+ * (5) the closer to setpoint, the smaller |df/dx| (and the reverse)
+ *     => fast response on large errors; small oscillation near setpoint
+ */
+static inline long long pos_ratio_polynom(unsigned long setpoint,
+					  unsigned long dirty,
+					  unsigned long limit)
+{
+	long long pos_ratio;
+	long x;
+
+	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
+		    limit - setpoint + 1);
+	pos_ratio = x;
+	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
+	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
+	pos_ratio += 1 << RATELIMIT_CALC_SHIFT;
+
+	return clamp(pos_ratio, 0LL, 2LL << RATELIMIT_CALC_SHIFT);
+}
+
+/*
  * Dirty position control.
  *
  * (o) global/bdi setpoints
@@ -682,26 +713,80 @@ static unsigned long bdi_position_ratio(
 	/*
 	 * global setpoint
 	 *
-	 *                           setpoint - dirty 3
-	 *        f(dirty) := 1.0 + (----------------)
-	 *                           limit - setpoint
-	 *
-	 * it's a 3rd order polynomial that subjects to
-	 *
-	 * (1) f(freerun)  = 2.0 => rampup dirty_ratelimit reasonably fast
-	 * (2) f(setpoint) = 1.0 => the balance point
-	 * (3) f(limit)    = 0   => the hard limit
-	 * (4) df/dx      <= 0	 => negative feedback control
-	 * (5) the closer to setpoint, the smaller |df/dx| (and the reverse)
-	 *     => fast response on large errors; small oscillation near setpoint
+	 * See comment for pos_ratio_polynom().
 	 */
 	setpoint = (freerun + limit) / 2;
-	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
-		    limit - setpoint + 1);
-	pos_ratio = x;
-	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
-	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
-	pos_ratio += 1 << RATELIMIT_CALC_SHIFT;
+	pos_ratio = pos_ratio_polynom(setpoint, dirty, limit);
+
+	/*
+	 * The strictlimit feature is a tool preventing mistrusted filesystems
+	 * from growing a large number of dirty pages before throttling. For
+	 * such filesystems balance_dirty_pages always checks bdi counters
+	 * against bdi limits. Even if global "nr_dirty" is under "freerun".
+	 * This is especially important for fuse which sets bdi->max_ratio to
+	 * 1% by default. Without strictlimit feature, fuse writeback may
+	 * consume arbitrary amount of RAM because it is accounted in
+	 * NR_WRITEBACK_TEMP which is not involved in calculating "nr_dirty".
+	 *
+	 * Here, in bdi_position_ratio(), we calculate pos_ratio based on
+	 * two values: bdi_dirty and bdi_thresh. Let's consider an example:
+	 * total amount of RAM is 16GB, bdi->max_ratio is equal to 1%, global
+	 * limits are set by default to 10% and 20% (background and throttle).
+	 * Then bdi_thresh is 1% of 20% of 16GB. This amounts to ~8K pages.
+	 * bdi_dirty_limit(bdi, bg_thresh) is about ~4K pages. bdi_setpoint is
+	 * about ~6K pages (as the average of background and throttle bdi
+	 * limits). The 3rd order polynomial will provide positive feedback if
+	 * bdi_dirty is under bdi_setpoint and vice versa.
+	 *
+	 * Note, that we cannot use global counters in these calculations
+	 * because we want to throttle process writing to a strictlimit BDI
+	 * much earlier than global "freerun" is reached (~23MB vs. ~2.3GB
+	 * in the example above).
+	 */
+	if (unlikely(bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
+		long long bdi_pos_ratio;
+		unsigned long bdi_bg_thresh;
+
+		if (bdi_dirty < 8)
+			return min_t(long long, pos_ratio * 2,
+				     2 << RATELIMIT_CALC_SHIFT);
+
+		if (bdi_dirty >= bdi_thresh)
+			return 0;
+
+		bdi_bg_thresh = div_u64((u64)bdi_thresh * bg_thresh, thresh);
+		bdi_setpoint = dirty_freerun_ceiling(bdi_thresh,
+						     bdi_bg_thresh);
+
+		if (bdi_setpoint == 0 || bdi_setpoint == bdi_thresh)
+			return 0;
+
+		bdi_pos_ratio = pos_ratio_polynom(bdi_setpoint, bdi_dirty,
+						  bdi_thresh);
+
+		/*
+		 * Typically, for strictlimit case, bdi_setpoint << setpoint
+		 * and pos_ratio >> bdi_pos_ratio. In the other words global
+		 * state ("dirty") is not limiting factor and we have to
+		 * make decision based on bdi counters. But there is an
+		 * important case when global pos_ratio should get precedence:
+		 * global limits are exceeded (e.g. due to activities on other
+		 * BDIs) while given strictlimit BDI is below limit.
+		 *
+		 * "pos_ratio * bdi_pos_ratio" would work for the case above,
+		 * but it would look too non-natural for the case of all
+		 * activity in the system coming from a single strictlimit BDI
+		 * with bdi->max_ratio == 100%.
+		 *
+		 * Note that min() below somewhat changes the dynamics of the
+		 * control system. Normally, pos_ratio value can be well over 3
+		 * (when globally we are at freerun and bdi is well below bdi
+		 * setpoint). Now the maximum pos_ratio in the same situation
+		 * is 2. We might want to tweak this if we observe the control
+		 * system is too slow to adapt.
+		 */
+		return min(pos_ratio, bdi_pos_ratio);
+	}
 
 	/*
 	 * We have computed basic pos_ratio above based on global situation. If
@@ -994,6 +1079,27 @@ static void bdi_update_dirty_ratelimit(s
 	 * keep that period small to reduce time lags).
 	 */
 	step = 0;
+
+	/*
+	 * For strictlimit case, calculations above were based on bdi counters
+	 * and limits (starting from pos_ratio = bdi_position_ratio() and up to
+	 * balanced_dirty_ratelimit = task_ratelimit * write_bw / dirty_rate).
+	 * Hence, to calculate "step" properly, we have to use bdi_dirty as
+	 * "dirty" and bdi_setpoint as "setpoint".
+	 *
+	 * We rampup dirty_ratelimit forcibly if bdi_dirty is low because
+	 * it's possible that bdi_thresh is close to zero due to inactivity
+	 * of backing device (see the implementation of bdi_dirty_limit()).
+	 */
+	if (unlikely(bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
+		dirty = bdi_dirty;
+		if (bdi_dirty < 8)
+			setpoint = bdi_dirty + 1;
+		else
+			setpoint = (bdi_thresh +
+				    bdi_dirty_limit(bdi, bg_thresh)) / 2;
+	}
+
 	if (dirty < setpoint) {
 		x = min(bdi->balanced_dirty_ratelimit,
 			 min(balanced_dirty_ratelimit, task_ratelimit));
@@ -1198,6 +1304,56 @@ static long bdi_min_pause(struct backing
 	return pages >= DIRTY_POLL_THRESH ? 1 + t / 2 : t;
 }
 
+static inline void bdi_dirty_limits(struct backing_dev_info *bdi,
+				    unsigned long dirty_thresh,
+				    unsigned long background_thresh,
+				    unsigned long *bdi_dirty,
+				    unsigned long *bdi_thresh,
+				    unsigned long *bdi_bg_thresh)
+{
+	unsigned long bdi_reclaimable;
+
+	/*
+	 * bdi_thresh is not treated as some limiting factor as
+	 * dirty_thresh, due to reasons
+	 * - in JBOD setup, bdi_thresh can fluctuate a lot
+	 * - in a system with HDD and USB key, the USB key may somehow
+	 *   go into state (bdi_dirty >> bdi_thresh) either because
+	 *   bdi_dirty starts high, or because bdi_thresh drops low.
+	 *   In this case we don't want to hard throttle the USB key
+	 *   dirtiers for 100 seconds until bdi_dirty drops under
+	 *   bdi_thresh. Instead the auxiliary bdi control line in
+	 *   bdi_position_ratio() will let the dirtier task progress
+	 *   at some rate <= (write_bw / 2) for bringing down bdi_dirty.
+	 */
+	*bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+
+	if (bdi_bg_thresh)
+		*bdi_bg_thresh = div_u64((u64)*bdi_thresh *
+					 background_thresh,
+					 dirty_thresh);
+
+	/*
+	 * In order to avoid the stacked BDI deadlock we need
+	 * to ensure we accurately count the 'dirty' pages when
+	 * the threshold is low.
+	 *
+	 * Otherwise it would be possible to get thresh+n pages
+	 * reported dirty, even though there are thresh-m pages
+	 * actually dirty; with m+n sitting in the percpu
+	 * deltas.
+	 */
+	if (*bdi_thresh < 2 * bdi_stat_error(bdi)) {
+		bdi_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
+		*bdi_dirty = bdi_reclaimable +
+			bdi_stat_sum(bdi, BDI_WRITEBACK);
+	} else {
+		bdi_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
+		*bdi_dirty = bdi_reclaimable +
+			bdi_stat(bdi, BDI_WRITEBACK);
+	}
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -1209,10 +1365,8 @@ static void balance_dirty_pages(struct a
 				unsigned long pages_dirtied)
 {
 	unsigned long nr_reclaimable;	/* = file_dirty + unstable_nfs */
-	unsigned long bdi_reclaimable;
 	unsigned long nr_dirty;  /* = file_dirty + writeback + unstable_nfs */
 	unsigned long bdi_dirty;
-	unsigned long freerun;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
@@ -1226,10 +1380,14 @@ static void balance_dirty_pages(struct a
 	unsigned long dirty_ratelimit;
 	unsigned long pos_ratio;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	bool strictlimit = bdi->capabilities & BDI_CAP_STRICTLIMIT;
 	unsigned long start_time = jiffies;
 
 	for (;;) {
 		unsigned long now = jiffies;
+		unsigned long dirty;
+		unsigned long thresh;
+		unsigned long bg_thresh;
 
 		/*
 		 * Unstable writes are a feature of certain networked
@@ -1243,61 +1401,44 @@ static void balance_dirty_pages(struct a
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
+		if (unlikely(strictlimit)) {
+			bdi_dirty_limits(bdi, dirty_thresh, background_thresh,
+					 &bdi_dirty, &bdi_thresh, &bg_thresh);
+
+			dirty = bdi_dirty;
+			thresh = bdi_thresh;
+		} else {
+			dirty = nr_dirty;
+			thresh = dirty_thresh;
+			bg_thresh = background_thresh;
+		}
+
 		/*
 		 * Throttle it only when the background writeback cannot
 		 * catch-up. This avoids (excessively) small writeouts
-		 * when the bdi limits are ramping up.
+		 * when the bdi limits are ramping up in case of !strictlimit.
+		 *
+		 * In strictlimit case make decision based on the bdi counters
+		 * and limits. Small writeouts when the bdi limits are ramping
+		 * up are the price we consciously pay for strictlimit-ing.
 		 */
-		freerun = dirty_freerun_ceiling(dirty_thresh,
-						background_thresh);
-		if (nr_dirty <= freerun) {
+		if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh)) {
 			current->dirty_paused_when = now;
 			current->nr_dirtied = 0;
 			current->nr_dirtied_pause =
-				dirty_poll_interval(nr_dirty, dirty_thresh);
+				dirty_poll_interval(dirty, thresh);
 			break;
 		}
 
 		if (unlikely(!writeback_in_progress(bdi)))
 			bdi_start_background_writeback(bdi);
 
-		/*
-		 * bdi_thresh is not treated as some limiting factor as
-		 * dirty_thresh, due to reasons
-		 * - in JBOD setup, bdi_thresh can fluctuate a lot
-		 * - in a system with HDD and USB key, the USB key may somehow
-		 *   go into state (bdi_dirty >> bdi_thresh) either because
-		 *   bdi_dirty starts high, or because bdi_thresh drops low.
-		 *   In this case we don't want to hard throttle the USB key
-		 *   dirtiers for 100 seconds until bdi_dirty drops under
-		 *   bdi_thresh. Instead the auxiliary bdi control line in
-		 *   bdi_position_ratio() will let the dirtier task progress
-		 *   at some rate <= (write_bw / 2) for bringing down bdi_dirty.
-		 */
-		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
-
-		/*
-		 * In order to avoid the stacked BDI deadlock we need
-		 * to ensure we accurately count the 'dirty' pages when
-		 * the threshold is low.
-		 *
-		 * Otherwise it would be possible to get thresh+n pages
-		 * reported dirty, even though there are thresh-m pages
-		 * actually dirty; with m+n sitting in the percpu
-		 * deltas.
-		 */
-		if (bdi_thresh < 2 * bdi_stat_error(bdi)) {
-			bdi_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-			bdi_dirty = bdi_reclaimable +
-				    bdi_stat_sum(bdi, BDI_WRITEBACK);
-		} else {
-			bdi_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_dirty = bdi_reclaimable +
-				    bdi_stat(bdi, BDI_WRITEBACK);
-		}
+		if (!strictlimit)
+			bdi_dirty_limits(bdi, dirty_thresh, background_thresh,
+					 &bdi_dirty, &bdi_thresh, NULL);
 
 		dirty_exceeded = (bdi_dirty > bdi_thresh) &&
-				  (nr_dirty > dirty_thresh);
+				 ((nr_dirty > dirty_thresh) || strictlimit);
 		if (dirty_exceeded && !bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
_

Patches currently in -mm which might be from mpatlasov@parallels.com are

mm-page-writebackc-add-strictlimit-feature.patch

