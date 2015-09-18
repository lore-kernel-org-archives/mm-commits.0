From: akpm@linux-foundation.org
Subject: + remove-abs64.patch added to -mm tree
Date: Fri, 18 Sep 2015 12:14:00 -0700
Message-ID: <55fc6278.XQRv3R41Meel6pwy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbIRTOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 15:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, john.stultz@linaro.org, masami.hiramatsu.pt@hitachi.com, mina86@mina86.com, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Remove abs64()
has been added to the -mm tree.  Its filename is
     remove-abs64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-abs64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-abs64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Remove abs64()

Switch everything to the new and more capable implementation of abs(). 
Mainly to give the new abs() a bit of a workout.

Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_irq.c             |    4 ++--
 drivers/gpu/drm/tegra/sor.c           |    4 ++--
 drivers/media/i2c/ov9650.c            |    2 +-
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 drivers/thermal/power_allocator.c     |    2 +-
 fs/gfs2/lock_dlm.c                    |    2 +-
 include/linux/kernel.h                |    3 ---
 kernel/time/timekeeping.c             |    2 +-
 lib/div64.c                           |    2 +-
 net/sctp/transport.c                  |    2 +-
 10 files changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/gpu/drm/drm_irq.c~remove-abs64 drivers/gpu/drm/drm_irq.c
--- a/drivers/gpu/drm/drm_irq.c~remove-abs64
+++ a/drivers/gpu/drm/drm_irq.c
@@ -261,7 +261,7 @@ static void vblank_disable_and_save(stru
 	 * available. In that case we can't account for this and just
 	 * hope for the best.
 	 */
-	if (vblrc && (abs64(diff_ns) > 1000000))
+	if (vblrc && (abs(diff_ns) > 1000000))
 		store_vblank(dev, pipe, 1, &tvblank);
 
 	spin_unlock_irqrestore(&dev->vblank_time_lock, irqflags);
@@ -1772,7 +1772,7 @@ bool drm_handle_vblank(struct drm_device
 	 * e.g., due to spurious vblank interrupts. We need to
 	 * ignore those for accounting.
 	 */
-	if (abs64(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS)
+	if (abs(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS)
 		store_vblank(dev, pipe, 1, &tvblank);
 	else
 		DRM_DEBUG("crtc %u: Redundant vblirq ignored. diff_ns = %d\n",
diff -puN drivers/gpu/drm/tegra/sor.c~remove-abs64 drivers/gpu/drm/tegra/sor.c
--- a/drivers/gpu/drm/tegra/sor.c~remove-abs64
+++ a/drivers/gpu/drm/tegra/sor.c
@@ -555,11 +555,11 @@ static int tegra_sor_compute_params(stru
 	error = div_s64(active_sym - approx, tu_size);
 	error *= params->num_clocks;
 
-	if (error <= 0 && abs64(error) < params->error) {
+	if (error <= 0 && abs(error) < params->error) {
 		params->active_count = div_u64(active_count, f);
 		params->active_polarity = active_polarity;
 		params->active_frac = active_frac;
-		params->error = abs64(error);
+		params->error = abs(error);
 		params->tu_size = tu_size;
 
 		if (error == 0)
diff -puN drivers/media/i2c/ov9650.c~remove-abs64 drivers/media/i2c/ov9650.c
--- a/drivers/media/i2c/ov9650.c~remove-abs64
+++ a/drivers/media/i2c/ov9650.c
@@ -1133,7 +1133,7 @@ static int __ov965x_set_frame_interval(s
 		if (mbus_fmt->width != iv->size.width ||
 		    mbus_fmt->height != iv->size.height)
 			continue;
-		err = abs64((u64)(iv->interval.numerator * 10000) /
+		err = abs((u64)(iv->interval.numerator * 10000) /
 			    iv->interval.denominator - req_int);
 		if (err < min_err) {
 			fiv = iv;
diff -puN drivers/net/wireless/mac80211_hwsim.c~remove-abs64 drivers/net/wireless/mac80211_hwsim.c
--- a/drivers/net/wireless/mac80211_hwsim.c~remove-abs64
+++ a/drivers/net/wireless/mac80211_hwsim.c
@@ -787,7 +787,7 @@ static void mac80211_hwsim_set_tsf(struc
 	struct mac80211_hwsim_data *data = hw->priv;
 	u64 now = mac80211_hwsim_get_tsf(hw, vif);
 	u32 bcn_int = data->beacon_int;
-	u64 delta = abs64(tsf - now);
+	u64 delta = abs(tsf - now);
 
 	/* adjust after beaconing with new timestamp at old TBTT */
 	if (tsf > now) {
diff -puN drivers/thermal/power_allocator.c~remove-abs64 drivers/thermal/power_allocator.c
--- a/drivers/thermal/power_allocator.c~remove-abs64
+++ a/drivers/thermal/power_allocator.c
@@ -119,7 +119,7 @@ static u32 pid_controller(struct thermal
 	if (err < int_to_frac(tz->tzp->integral_cutoff)) {
 		s64 i_next = i + mul_frac(tz->tzp->k_i, err);
 
-		if (abs64(i_next) < max_power_frac) {
+		if (abs(i_next) < max_power_frac) {
 			i = i_next;
 			params->err_integral += err;
 		}
diff -puN fs/gfs2/lock_dlm.c~remove-abs64 fs/gfs2/lock_dlm.c
--- a/fs/gfs2/lock_dlm.c~remove-abs64
+++ a/fs/gfs2/lock_dlm.c
@@ -50,7 +50,7 @@ static inline void gfs2_update_stats(str
 	s64 delta = sample - s->stats[index];
 	s->stats[index] += (delta >> 3);
 	index++;
-	s->stats[index] += ((abs64(delta) - s->stats[index]) >> 2);
+	s->stats[index] += ((abs(delta) - s->stats[index]) >> 2);
 }
 
 /**
diff -puN include/linux/kernel.h~remove-abs64 include/linux/kernel.h
--- a/include/linux/kernel.h~remove-abs64
+++ a/include/linux/kernel.h
@@ -223,9 +223,6 @@ extern int _cond_resched(void);
 		ret;							\
 	}))
 
-/* Deprecated, use abs instead. */
-#define abs64(x) abs((s64)(x))
-
 /**
  * reciprocal_scale - "scale" a value into range [0, ep_ro)
  * @val: value
diff -puN kernel/time/timekeeping.c~remove-abs64 kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~remove-abs64
+++ a/kernel/time/timekeeping.c
@@ -1614,7 +1614,7 @@ static __always_inline void timekeeping_
 	negative = (tick_error < 0);
 
 	/* Sort out the magnitude of the correction */
-	tick_error = abs64(tick_error);
+	tick_error = abs(tick_error);
 	for (adj = 0; tick_error > interval; adj++)
 		tick_error >>= 1;
 
diff -puN lib/div64.c~remove-abs64 lib/div64.c
--- a/lib/div64.c~remove-abs64
+++ a/lib/div64.c
@@ -162,7 +162,7 @@ s64 div64_s64(s64 dividend, s64 divisor)
 {
 	s64 quot, t;
 
-	quot = div64_u64(abs64(dividend), abs64(divisor));
+	quot = div64_u64(abs(dividend), abs(divisor));
 	t = (dividend ^ divisor) >> 63;
 
 	return (quot ^ t) - t;
diff -puN net/sctp/transport.c~remove-abs64 net/sctp/transport.c
--- a/net/sctp/transport.c~remove-abs64
+++ a/net/sctp/transport.c
@@ -331,7 +331,7 @@ void sctp_transport_update_rto(struct sc
 		 * 1/8, rto_alpha would be expressed as 3.
 		 */
 		tp->rttvar = tp->rttvar - (tp->rttvar >> net->sctp.rto_beta)
-			+ (((__u32)abs64((__s64)tp->srtt - (__s64)rtt)) >> net->sctp.rto_beta);
+			+ (((__u32)abs((__s64)tp->srtt - (__s64)rtt)) >> net->sctp.rto_beta);
 		tp->srtt = tp->srtt - (tp->srtt >> net->sctp.rto_alpha)
 			+ (rtt >> net->sctp.rto_alpha);
 	} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
remove-abs64.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

