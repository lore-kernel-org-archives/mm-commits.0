From: akpm@linux-foundation.org
Subject: + add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Feb 2010 14:58:59 -0800
Message-ID: <201002222259.o1MMwxRa028697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713Ab0BVXCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 18:02:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, atrigent@ccs.neu.edu


The patch titled
     add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch

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
Subject: add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#35: FILE: drivers/char/vt_ioctl.c:891:
+		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS && tmp.mode != VT_PROCESS_AUTO) {

WARNING: line over 80 characters
#44: FILE: drivers/char/vt_ioctl.c:1625:
+	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {

WARNING: line over 80 characters
#53: FILE: drivers/char/vt_ioctl.c:1685:
+	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {

ERROR: space required before the open parenthesis '('
#61: FILE: drivers/char/vt_ioctl.c:1696:
+			if(vc->vt_mode.mode == VT_PROCESS)

WARNING: line over 80 characters
#73: FILE: drivers/char/vt_ioctl.c:1705:
+			 * The controlling process has died, so we revert back to

WARNING: line over 80 characters
#74: FILE: drivers/char/vt_ioctl.c:1706:
+			 * normal operation. In this case, we'll also change back

WARNING: line over 80 characters
#75: FILE: drivers/char/vt_ioctl.c:1707:
+			 * to KD_TEXT mode. I'm not sure if this is strictly correct

WARNING: line over 80 characters
#76: FILE: drivers/char/vt_ioctl.c:1708:
+			 * but it saves the agony when the X server dies and the screen

WARNING: line over 80 characters
#77: FILE: drivers/char/vt_ioctl.c:1709:
+			 * remains blanked due to KD_GRAPHICS! It would be nice to do

WARNING: line over 80 characters
#78: FILE: drivers/char/vt_ioctl.c:1710:
+			 * this outside of VT_PROCESS but there is no single process

WARNING: line over 80 characters
#79: FILE: drivers/char/vt_ioctl.c:1711:
+			 * to account for and tracking tty count may be undesirable.

WARNING: line over 80 characters
#98: FILE: drivers/char/vt_ioctl.c:1717:
+		 * Fall through to normal (VT_AUTO and VT_PROCESS_AUTO) handling of the switch...

total: 1 errors, 11 warnings, 83 lines checked

./patches/add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ari Entlich <atrigent@ccs.neu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt_ioctl.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN drivers/char/vt_ioctl.c~add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes
+++ a/drivers/char/vt_ioctl.c
@@ -888,7 +888,8 @@ int vt_ioctl(struct tty_struct *tty, str
 			ret = -EFAULT;
 			goto out;
 		}
-		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS && tmp.mode != VT_PROCESS_AUTO) {
+		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS &&
+				tmp.mode != VT_PROCESS_AUTO) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1622,7 +1623,8 @@ static void complete_change_console(stru
 	 * telling it that it has acquired. Also check if it has died and
 	 * clean up (similar to logic employed in change_console())
 	 */
-	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
+	if (vc->vt_mode.mode == VT_PROCESS ||
+			vc->vt_mode.mode == VT_PROCESS_AUTO) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1682,7 +1684,8 @@ void change_console(struct vc_data *new_
 	 * vt to auto control.
 	 */
 	vc = vc_cons[fg_console].d;
-	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
+	if (vc->vt_mode.mode == VT_PROCESS ||
+			vc->vt_mode.mode == VT_PROCESS_AUTO) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1693,28 +1696,31 @@ void change_console(struct vc_data *new_
 		 */
 		vc->vt_newvt = new_vc->vc_num;
 		if (kill_pid(vc->vt_pid, vc->vt_mode.relsig, 1) == 0) {
-			if(vc->vt_mode.mode == VT_PROCESS)
+			if (vc->vt_mode.mode == VT_PROCESS) {
 				/*
 				 * It worked. Mark the vt to switch to and
 				 * return. The process needs to send us a
 				 * VT_RELDISP ioctl to complete the switch.
 				 */
 				return;
+			}
 		} else {
 			/*
-			 * The controlling process has died, so we revert back to
-			 * normal operation. In this case, we'll also change back
-			 * to KD_TEXT mode. I'm not sure if this is strictly correct
-			 * but it saves the agony when the X server dies and the screen
-			 * remains blanked due to KD_GRAPHICS! It would be nice to do
-			 * this outside of VT_PROCESS but there is no single process
-			 * to account for and tracking tty count may be undesirable.
+			 * The controlling process has died, so we revert back
+			 * to normal operation. In this case, we'll also change
+			 * back to KD_TEXT mode. I'm not sure if this is
+			 * strictly correct but it saves the agony when the X
+			 * server dies and the screen remains blanked due to
+			 * KD_GRAPHICS! It would be nice to do this outside of
+			 * VT_PROCESS but there is no single process to account
+			 * for and tracking tty count may be undesirable.
 			 */
 			reset_vc(vc);
 		}
 
 		/*
-		 * Fall through to normal (VT_AUTO and VT_PROCESS_AUTO) handling of the switch...
+		 * Fall through to normal (VT_AUTO and VT_PROCESS_AUTO) handling
+		 * of the switch...
 		 */
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-serial-clients-support-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

