From: akpm@linux-foundation.org
Subject: - fix-drivers-media-common-tuners-build-bug.patch removed from -mm tree
Date: Thu, 01 May 2008 02:34:01 -0700
Message-ID: <200805010934.m419Y1Fq031173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000AbYEAJeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mchehab@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     fix drivers/media/common/tuners/ build bug
has been removed from the -mm tree.  Its filename was
     fix-drivers-media-common-tuners-build-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix drivers/media/common/tuners/ build bug
From: Ingo Molnar <mingo@elte.hu>

x86.git randconfig testing found a build failure on latest -git:

 drivers/built-in.o: In function `set_type':
 tuner-core.c:(.text+0x2a9a26): undefined reference to `tea5761_attach'
 tuner-core.c:(.text+0x2a9d05): undefined reference to `tda9887_attach'
 tuner-core.c:(.text+0x2a9d51): undefined reference to `xc2028_attach'
 tuner-core.c:(.text+0x2a9e22): undefined reference to `tda829x_attach'
 tuner-core.c:(.text+0x2a9e3f): undefined reference to `microtune_attach'
 drivers/built-in.o: In function `tuner_probe':
 tuner-core.c:(.text+0x2aa18a): undefined reference to `tda829x_probe'
 tuner-core.c:(.text+0x2aa302): undefined reference to `tea5761_autodetection'

with the following config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_10_21_40_CEST_2008.bad

the problem is caused by the drivers/media/common/tuners/ subdirectory
not being part of the kbuild hierarchy anymore, due to commit
7c91f0624 ("V4L/DVB(7767): Move tuners to common/tuners").

this seems similar to the problem also reported by Mike Galbraith.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/common/Makefile~fix-drivers-media-common-tuners-build-bug drivers/media/common/Makefile
--- a/drivers/media/common/Makefile~fix-drivers-media-common-tuners-build-bug
+++ a/drivers/media/common/Makefile
@@ -2,6 +2,7 @@ saa7146-objs    := saa7146_i2c.o saa7146
 saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
 ir-common-objs  := ir-functions.o ir-keymaps.o
 
+obj-y += tuners/
 obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
 obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
cpusets-update-maintainers.patch
fix-cpu-hotplug-problem-in-softirq-code.patch
rename-div64_64-to-div64_u64.patch
remove-div_long_long_rem.patch
isdn-hysdn_procconfc-build-fix.patch
pci-export-resource_wc-in-pci-sysfs.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
acpi-acpi_numa_init-build-fix.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
git-x86.patch
git-x86-fixup.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch
arch-x86-video-fbdevc-add-module_license.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
git-kvm.patch
git-sched.patch
mutex-debug-check-mutex-magic-before-owner.patch
show_schedstat-fix-memleak.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch
rcu-add-call_rcu_sched.patch
rcu-add-memory-barriers-and-comments-to-rcu_check_callbacks.patch
rcu-add-call_rcu_sched-and-friends-to-rcutorture.patch
rcu-1q08-rcu-doc-update-add-call_rcu_sched.patch
aes-x86_64-asm-implementation-optimization.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

