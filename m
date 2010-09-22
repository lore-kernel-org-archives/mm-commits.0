From: akpm@linux-foundation.org
Subject: + alpha-asm-irqflagsh-needs-asm-systemh.patch added to -mm tree
Date: Wed, 22 Sep 2010 14:44:42 -0700
Message-ID: <201009222215.o8MMFgYl020074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab0IVWQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Sep 2010 18:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: asm/irqflags.h needs asm/system.h
has been added to the -mm tree.  Its filename is
     alpha-asm-irqflagsh-needs-asm-systemh.patch

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
Subject: alpha: asm/irqflags.h needs asm/system.h
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/alpha/kernel/asm-offsets.c:9:
arch/alpha/include/asm/irqflags.h: In function 'arch_local_save_flags':
arch/alpha/include/asm/irqflags.h:26: error: implicit declaration of function 'rdps'
arch/alpha/include/asm/irqflags.h: In function 'arch_local_irq_disable':
arch/alpha/include/asm/irqflags.h:31: error: implicit declaration of function 'swpipl'

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/irqflags.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/alpha/include/asm/irqflags.h~alpha-asm-irqflagsh-needs-asm-systemh arch/alpha/include/asm/irqflags.h
--- a/arch/alpha/include/asm/irqflags.h~alpha-asm-irqflagsh-needs-asm-systemh
+++ a/arch/alpha/include/asm/irqflags.h
@@ -1,6 +1,8 @@
 #ifndef __ALPHA_IRQFLAGS_H
 #define __ALPHA_IRQFLAGS_H
 
+#include <asm/system.h>
+
 #define IPL_MIN		0
 #define IPL_SW0		1
 #define IPL_SW1		2
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware.patch
drivers-pci-intel-iommuc-fix-build-with-older-gccs.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
alpha-asm-irqflagsh-needs-asm-systemh.patch
drivers-serial-mfdc-needs-slabh.patch
mm-vmap-area-cache.patch
acpi-apei-fix-erst-move_data-instruction-implementation.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes.patch
serial-add-sc16is7x2-driver-update-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
viafb-add-interface-for-output-device-configuration.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

