From: akpm@linux-foundation.org
Subject: + thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix.patch added to -mm tree
Date: Mon, 08 Feb 2010 15:51:09 -0800
Message-ID: <201002082351.o18Np9bm010719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab0BHXvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 18:51:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cascardo@holoscopio.com, hmh@hmh.eng.br, lenb@kernel.org


The patch titled
     thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix
has been added to the -mm tree.  Its filename is
     thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix.patch

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
Subject: thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix
From: Andrew Morton <akpm@linux-foundation.org>

- Avoid ifdefs

- Make sure that hotkey_mutex is held when calling hotkey_poll_setup:
  use hotkey_poll_setup_safe.  Doesn't matter much in __init code.

Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -2597,6 +2597,10 @@ static void hotkey_poll_set_freq(unsigne
 
 #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
 
+static void hotkey_poll_setup(bool __unused)
+{
+}
+
 static void hotkey_poll_setup_safe(bool __unused)
 {
 }
@@ -2694,9 +2698,7 @@ static ssize_t hotkey_mask_store(struct 
 
 	res = hotkey_user_mask_set(t);
 
-#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
 	hotkey_poll_setup(true);
-#endif
 
 	mutex_unlock(&hotkey_mutex);
 
@@ -6273,9 +6275,7 @@ static int __init brightness_init(struct
 				| TP_ACPI_HKEY_BRGHTUP_MASK
 				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
 
-#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
-	hotkey_poll_setup(true);
-#endif
+	hotkey_poll_setup_safe(true);
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
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
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
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

