From: akpm@linux-foundation.org
Subject: + kernelh-add-minmax3-macros-fix.patch added to -mm tree
Date: Fri, 27 Aug 2010 15:15:19 -0700
Message-ID: <201008272245.o7RMjg1i020655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab0H0Wq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 18:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, hagen@jauu.net, herbert@gondor.hengli.com.au, hsweeten@visionengravers.com, joe@perches.com, linux@arm.linux.org.uk, mingo@elte.hu, penberg@cs.helsinki.fi, rolandd@cisco.com, sean.hefty@intel.com, tglx@linutronix.de


The patch titled
     kernelh-add-minmax3-macros-fix
has been added to the -mm tree.  Its filename is
     kernelh-add-minmax3-macros-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernelh-add-minmax3-macros-fix
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/cpu/intel_cacheinfo.c: In function 'amd_calc_l3_indices':
arch/x86/kernel/cpu/intel_cacheinfo.c:330: warning: comparisons like X<=Y<=Z do not have their mathematical meaning
arch/x86/kernel/cpu/intel_cacheinfo.c:330: warning: comparisons like X<=Y<=Z do not have their mathematical meaning

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~kernelh-add-minmax3-macros-fix include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-minmax3-macros-fix
+++ a/include/linux/kernel.h
@@ -644,7 +644,8 @@ static inline void ftrace_dump(enum ftra
 	typeof(x) _min1 = (x);			\
 	typeof(y) _min2 = (y);			\
 	typeof(z) _min3 = (z);			\
-	(void) (&_min1 == &_min2 == &_min3);	\
+	(void) (&_min1 == &_min2);		\
+	(void) (&_min1 == &_min3);		\
 	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
 		(_min2 < _min3 ? _min2 : _min3); })
 
@@ -652,7 +653,8 @@ static inline void ftrace_dump(enum ftra
 	typeof(x) _max1 = (x);			\
 	typeof(y) _max2 = (y);			\
 	typeof(z) _max3 = (z);			\
-	(void) (&_max1 == &_max2 == &_max3);	\
+	(void) (&_max1 == &_max2);		\
+	(void) (&_max1 == &_max3);		\
 	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
 		(_max2 > _max3 ? _max2 : _max3); })
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

