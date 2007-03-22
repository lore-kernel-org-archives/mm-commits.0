From: akpm@linux-foundation.org
Subject: - add-support-for-deferrable-timers-tidy.patch removed from -mm tree
Date: Thu, 22 Mar 2007 03:18:46 -0800
Message-ID: <200703221118.l2MBIkIs019068@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030463AbXCVLY1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 07:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     add-support-for-deferrable-timers-tidy
has been removed from the -mm tree.  Its filename was
     add-support-for-deferrable-timers-tidy.patch

This patch was dropped because it was folded into add-support-for-deferrable-timers.patch

------------------------------------------------------
Subject: add-support-for-deferrable-timers-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Whitespace repairs

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timer.h |    2 +-
 kernel/timer.c        |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/timer.h~add-support-for-deferrable-timers-tidy include/linux/timer.h
--- a/include/linux/timer.h~add-support-for-deferrable-timers-tidy
+++ a/include/linux/timer.h
@@ -45,7 +45,7 @@ extern struct tvec_t_base_s boot_tvec_ba
 		TIMER_INITIALIZER(_function, _expires, _data)
 
 void fastcall init_timer(struct timer_list * timer);
-void fastcall init_timer_deferrable(struct timer_list * timer);
+void fastcall init_timer_deferrable(struct timer_list *timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
diff -puN kernel/timer.c~add-support-for-deferrable-timers-tidy kernel/timer.c
--- a/kernel/timer.c~add-support-for-deferrable-timers-tidy
+++ a/kernel/timer.c
@@ -86,35 +86,35 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
  * The lowest bit of base ptr in timer is used as a flag to indicate
  * 'deferrable' nature of the timer. Functions below help us manage that flag.
  */
-static inline struct tvec_t_base_s *tbase_get_base_ptr(
-	struct tvec_t_base_s *base)
+static inline struct tvec_t_base_s *
+tbase_get_base_ptr(struct tvec_t_base_s *base)
 {
 	return ((struct tvec_t_base_s *)
 			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
 }
 
-static inline unsigned long tbase_get_deferrable_flag(
-	struct tvec_t_base_s *base)
+static inline unsigned long
+tbase_get_deferrable_flag(struct tvec_t_base_s *base)
 {
 	return ((unsigned long)base & TBASE_DEFERRABLE_FLAG);
 }
 
-static inline struct tvec_t_base_s *tbase_set_deferrable_flag(
-	struct tvec_t_base_s *base)
+static inline struct tvec_t_base_s *
+tbase_set_deferrable_flag(struct tvec_t_base_s *base)
 {
 	return ((struct tvec_t_base_s *)
 			((unsigned long)base | TBASE_DEFERRABLE_FLAG));
 }
 
-static inline struct tvec_t_base_s *tbase_clear_deferrable_flag(
-	struct tvec_t_base_s *base)
+static inline struct tvec_t_base_s *
+tbase_clear_deferrable_flag(struct tvec_t_base_s *base)
 {
 	return ((struct tvec_t_base_s *)
 			((unsigned long)base & (~TBASE_DEFERRABLE_FLAG)));
 }
 
-static inline struct tvec_t_base_s *tbase_merge_deferrable_flag(
-	struct tvec_t_base_s *base, unsigned long flag)
+static inline struct tvec_t_base_s *
+tbase_merge_deferrable_flag(struct tvec_t_base_s *base, unsigned long flag)
 {
 	if (flag & TBASE_DEFERRABLE_FLAG)
 		return tbase_set_deferrable_flag(base);
@@ -418,8 +418,8 @@ int __mod_timer(struct timer_list *timer
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
-			timer->base =
-				tbase_merge_deferrable_flag(new_base, tflag);
+			timer->base = tbase_merge_deferrable_flag(new_base,
+								tflag);
 		}
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
add-support-for-deferrable-timers.patch
add-support-for-deferrable-timers-tidy.patch
export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor-tidy.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
