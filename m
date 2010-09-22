From: akpm@linux-foundation.org
Subject: + arch-alpha-kernel-systblss-remove-debug-check.patch added to -mm tree
Date: Wed, 22 Sep 2010 14:44:34 -0700
Message-ID: <201009222215.o8MMFY6l020068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab0IVWQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Sep 2010 18:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     arch/alpha/kernel/systbls.S: remove debug check
has been added to the -mm tree.  Its filename is
     arch-alpha-kernel-systblss-remove-debug-check.patch

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
Subject: arch/alpha/kernel/systbls.S: remove debug check
From: Andrew Morton <akpm@linux-foundation.org>

-mm only patch, I guess.

My old gas-2.16.1 says

arch/alpha/kernel/systbls.S: Assembler messages:
arch/alpha/kernel/systbls.S:523: Error: non-constant expression in ".if" statement
arch/alpha/kernel/systbls.S:524: Error: .err encountered

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/systbls.S |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/alpha/kernel/systbls.S~arch-alpha-kernel-systblss-remove-debug-check arch/alpha/kernel/systbls.S
--- a/arch/alpha/kernel/systbls.S~arch-alpha-kernel-systblss-remove-debug-check
+++ a/arch/alpha/kernel/systbls.S
@@ -519,7 +519,3 @@ sys_call_table:
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
 
-/* Remember to update everything, kids.  */
-.ifne (. - sys_call_table) - (NR_SYSCALLS * 8)
-.err
-.endif
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

