From: akpm@linux-foundation.org
Subject: + idr-fix-idr_pre_get-locking-description-fix.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:52:38 -0700
Message-ID: <201009212252.o8LMqcdY007502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab0IUWxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, naota@elisp.net


The patch titled
     idr-fix-idr_pre_get-locking-description-fix
has been added to the -mm tree.  Its filename is
     idr-fix-idr_pre_get-locking-description-fix.patch

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
Subject: idr-fix-idr_pre_get-locking-description-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Naohiro Aota <naota@elisp.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN lib/idr.c~idr-fix-idr_pre_get-locking-description-fix lib/idr.c
--- a/lib/idr.c~idr-fix-idr_pre_get-locking-description-fix
+++ a/lib/idr.c
@@ -110,10 +110,10 @@ static void idr_mark_full(struct idr_lay
  * @idp:	idr handle
  * @gfp_mask:	memory allocation flags
  *
- * This function should be called prior to calling the idr_get_new*
- * functions. It preallocates enough memory to satisfy the worst
- * possible allocation. You can sleep in this function iff without
- * holding spinlock.
+ * This function should be called prior to calling the idr_get_new* functions.
+ * It preallocates enough memory to satisfy the worst possible allocation. The
+ * caller should pass in GFP_KERNEL if possible.  This of course requires that
+ * no spinning locks be held.
  *
  * If the system is REALLY out of memory this function returns 0,
  * otherwise 1.
@@ -291,8 +291,11 @@ static int idr_get_new_above_int(struct 
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should go back to
- * the idr_pre_get() call. If the idr is full, it will return -ENOSPC.
+ * If allocation from IDR's private freelist fails, idr_get_new_above() will
+ * return -EAGAIN.  The caller should retry the idr_pre_get() call to refill
+ * IDR's preallocation and then retry the idr_get_new_above() call.
+ *
+ * If the idr is full idr_get_new_above() will return -ENOSPC.
  *
  * @id returns a value in the range @starting_id ... 0x7fffffff
  */
@@ -318,11 +321,11 @@ EXPORT_SYMBOL(idr_get_new_above);
  * @ptr: pointer you want associated with the id
  * @id: pointer to the allocated handle
  *
- * This is the allocate id function.  It should be called with any
- * required locks.
+ * If allocation from IDR's private freelist fails, idr_get_new_above() will
+ * return -EAGAIN.  The caller should retry the idr_pre_get() call to refill
+ * IDR's preallocation and then retry the idr_get_new_above() call.
  *
- * If memory is required, it will return -EAGAIN, you should go back to
- * the idr_pre_get() call. If the idr is full, it will return -ENOSPC.
+ * If the idr is full idr_get_new_above() will return -ENOSPC.
  *
  * @id returns a value in the range 0 ... 0x7fffffff
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
mm-vmap-area-cache.patch
drivers-pci-intel-iommuc-fix-build-with-older-gccs.patch
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
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
sdhci-get-rid-of-card-detect-work-fix.patch
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

