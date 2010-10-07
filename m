From: akpm@linux-foundation.org
Subject: + memblock-add-input-size-checking-to-memblock_find_region-fix.patch added to -mm tree
Date: Thu, 07 Oct 2010 13:51:59 -0700
Message-ID: <201010072123.o97LNLV1024848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640Ab0JGVXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 17:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     memblock-add-input-size-checking-to-memblock_find_region-fix
has been added to the -mm tree.  Its filename is
     memblock-add-input-size-checking-to-memblock_find_region-fix.patch

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
Subject: memblock-add-input-size-checking-to-memblock_find_region-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/memblock.c: In function 'memblock_find_region':
mm/memblock.c:109: warning: format '%#llx' expects type 'long long unsigned int', but argument 4 has type 'phys_addr_t'
mm/memblock.c:109: warning: format '%#llx' expects type 'long long unsigned int', but argument 5 has type 'phys_addr_t'
mm/memblock.c:109: warning: format '%#llx' expects type 'long long unsigned int', but argument 6 has type 'phys_addr_t'

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-add-input-size-checking-to-memblock_find_region-fix mm/memblock.c
--- a/mm/memblock.c~memblock-add-input-size-checking-to-memblock_find_region-fix
+++ a/mm/memblock.c
@@ -106,7 +106,11 @@ static phys_addr_t __init memblock_find_
 	long j;
 
 	/* In case, huge size is requested */
-	if (WARN_ONCE(end < size, "memblock_find_region: wrong range [%#llx-%#llx] size %#llx", start, end, size))
+	if (WARN_ONCE(end < size,
+		  "memblock_find_region: wrong range [%#llx-%#llx] size %#llx",
+		  (unsigned long long)start,
+		  (unsigned long long)end,
+		  (unsigned long long)size))
 		return MEMBLOCK_ERROR;
 
 	base = memblock_align_down((end - size), align);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-haavard-has-moved.patch
sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax-v2.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-mips-include-asm-fcntlh-needs-typesh.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
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
rmap-make-anon_vma_free-static-fix.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
hpet-factor-timer-allocate-from-open-fix.patch
m68k-__pa-cast-arg-to-long.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
vcs-add-poll-fasync-support-fix-fix.patch
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

