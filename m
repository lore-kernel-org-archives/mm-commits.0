From: akpm@linux-foundation.org
Subject: + fs-compat_ioctlc-suppress-two-warnings.patch added to -mm tree
Date: Fri, 05 Feb 2010 14:03:59 -0800
Message-ID: <201002052203.o15M3xwU023927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933910Ab0BEWEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 17:04:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amwang@redhat.com, arnd@arndb.de, viro@zeniv.linux.org.uk


The patch titled
     fs/compat_ioctl.c: suppress two warnings
has been added to the -mm tree.  Its filename is
     fs-compat_ioctlc-suppress-two-warnings.patch

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
Subject: fs/compat_ioctl.c: suppress two warnings
From: Andrew Morton <akpm@linux-foundation.org>

fs/compat_ioctl.c: In function 'do_ioctl_trans':
fs/compat_ioctl.c:534: warning: 'karg' may be used uninitialized in this function
fs/compat_ioctl.c:533: warning: 'kcmd' may be used uninitialized in this function
fs/compat_ioctl.c:656: warning: 'ret' may be used uninitialized in this function

Reduces text size by 44 bytes.

If someone calls one of these functions with an unexpected argument, the
code's buggy as-is.

Amerigo Wang <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/compat_ioctl.c~fs-compat_ioctlc-suppress-two-warnings fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~fs-compat_ioctlc-suppress-two-warnings
+++ a/fs/compat_ioctl.c
@@ -539,7 +539,7 @@ static int mt_ioctl_trans(unsigned int f
 		kcmd = MTIOCPOS;
 		karg = &pos;
 		break;
-	case MTIOCGET32:
+	default:	/* MTIOCGET32 */
 		kcmd = MTIOCGET;
 		karg = &get;
 		break;
@@ -657,7 +657,7 @@ static int raw_ioctl(unsigned fd, unsign
 
         switch (cmd) {
         case RAW_SETBIND:
-        case RAW_GETBIND: {
+        default: {	/* RAW_GETBIND */
                 struct raw_config_request req;
                 mm_segment_t oldfs = get_fs();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix.patch
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
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

