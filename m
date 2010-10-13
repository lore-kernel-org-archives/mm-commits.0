From: akpm@linux-foundation.org
Subject: + mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix.patch added to -mm tree
Date: Wed, 13 Oct 2010 15:46:39 -0700
Message-ID: <201010132318.o9DNIAkE025067__15222.7854858667$1287012009$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631Ab0JMXT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Oct 2010 19:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au, riel@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, walken@google.com, yinghan@google.com


The patch titled
     mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix
has been added to the -mm tree.  Its filename is
     mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix.patch

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
Subject: mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/filemap.c: In function 'filemap_fault':
mm/filemap.c:1577: warning: passing argument 2 of 'lock_page_or_retry' from incompatible pointer type

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix mm/filemap.c
--- a/mm/filemap.c~mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix
+++ a/mm/filemap.c
@@ -1574,7 +1574,7 @@ retry_find:
 			goto no_cached_page;
 	}
 
-	if (!lock_page_or_retry(page, &vma->vm_mm, vmf->flags))
+	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
 		return ret | VM_FAULT_RETRY;
 
 	/* Did it get truncated? */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-mips-include-asm-fcntlh-needs-typesh.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-low-threshold-to-pwm-backlight.patch
serial8250-ratelimit-too-much-work-error-fix.patch
serial8250-ratelimit-too-much-work-error-fix-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drivers-block-aoe-aoeblkc-ratelimit-a-warning-printk.patch
vfs-allow-mnt_want_write-to-sleep-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-fix.patch
mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix.patch
rmap-make-anon_vma_free-static-fix.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
fs-fs-writebackc-restore-lost-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
hpet-factor-timer-allocate-from-open-fix.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
vcs-add-poll-fasync-support-fix-fix.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

