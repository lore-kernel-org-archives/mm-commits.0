From: akpm@linux-foundation.org
Subject: + drivers-block-aoe-aoeblkc-ratelimit-a-warning-printk.patch added to -mm tree
Date: Mon, 11 Oct 2010 14:38:25 -0700
Message-ID: <201010112138.o9BLcP0E019515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756496Ab0JKVjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 17:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ecashin@coraid.com, roman@rm.pp.ru


The patch titled
     drivers/block/aoe/aoeblk.c: ratelimit a warning printk
has been added to the -mm tree.  Its filename is
     drivers-block-aoe-aoeblkc-ratelimit-a-warning-printk.patch

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
Subject: drivers/block/aoe/aoeblk.c: ratelimit a warning printk
From: Andrew Morton <akpm@linux-foundation.org>

As described in https://bugzilla.kernel.org/show_bug.cgi?id=19922

: I had an AoE device go down overnight, and while a server was trying to
: write to it, it was also writing this message to its logs:
: 
: 209                 printk(KERN_INFO "aoe: device %ld.%d is not up\n",
: 210                         d->aoemajor, d->aoeminor);
: 
: The message appeared many times per second, and over several hours
: produced about 7.5 gigabytes of log files, filling up all free space on
: the root filesystem.

Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Suggested-by: Roman Mamedov <roman@rm.pp.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoeblk.c~drivers-block-aoe-aoeblkc-ratelimit-a-warning-printk drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~drivers-block-aoe-aoeblkc-ratelimit-a-warning-printk
+++ a/drivers/block/aoe/aoeblk.c
@@ -4,12 +4,14 @@
  * block device routines
  */
 
+#include <linux/kernel.h>
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 #include <linux/genhd.h>
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
@@ -207,7 +209,7 @@ aoeblk_make_request(struct request_queue
 	spin_lock_irqsave(&d->lock, flags);
 
 	if ((d->flags & DEVFL_UP) == 0) {
-		printk(KERN_INFO "aoe: device %ld.%d is not up\n",
+		pr_info_ratelimited("aoe: device %ld.%d is not up\n",
 			d->aoemajor, d->aoeminor);
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-mips-include-asm-fcntlh-needs-typesh.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
kernel-auditscc-audit_inc_name_count-add-stack-backtrace.patch
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

