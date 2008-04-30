From: akpm@linux-foundation.org
Subject: - drivers-media-build-fix-for-modular-builds.patch removed from -mm tree
Date: Wed, 30 Apr 2008 04:56:37 -0700
Message-ID: <200804301156.m3UBubjW012129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757930AbYD3L53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 07:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mchehab@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media build fix for modular builds
has been removed from the -mm tree.  Its filename was
     drivers-media-build-fix-for-modular-builds.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media build fix for modular builds
From: Ingo Molnar <mingo@elte.hu>

fix allmodconfig build bug introduced in latest -git by commit 7c91f0624a9
("V4L/DVB(7767): Move tuners to common/tuners"):

  LD      kernel/built-in.o
  LD      drivers/built-in.o
  ld: drivers/media/built-in.o: No such file: No such file or directory

which happens if all media drivers are modular:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_09_24_48_CEST_2008.bad

In that case there's no obj-y rule connecting all the built-in.o files and
the link tree breaks.

the fix is to add a guaranteed obj-y rule for the core vmlinux to build.
(which results in an empty object file if all media drivers are modular)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/media/Makefile~drivers-media-build-fix-for-modular-builds drivers/media/Makefile
--- a/drivers/media/Makefile~drivers-media-build-fix-for-modular-builds
+++ a/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+obj-y := common/
+
 obj-$(CONFIG_VIDEO_MEDIA) += common/
 
 # Since hybrid devices are here, should be compiled if DVB and/or V4L
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
make-marker_debug-static.patch
asm-futexh-should-include-linux-uaccessh.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
kernel-replace-remaining-__function__-occurances.patch
cpusets-update-maintainers.patch
pci-export-resource_wc-in-pci-sysfs.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
git-x86.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
x86-ptrace-pebs-support.patch
x86-ptrace-pebs-support-warning-fix.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
drivers-media-build-fix-for-modular-builds.patch
git-kvm.patch
git-sched.patch
sched-add-debug-checks-to-idle-functions.patch
mutex-debug-check-mutex-magic-before-owner.patch
show_schedstat-fix-memleak.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
rcu-add-call_rcu_sched.patch
rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch
rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch
rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch
aes-x86_64-asm-implementation-optimization.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
rename-div64_64-to-div64_u64.patch
remove-div_long_long_rem.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

