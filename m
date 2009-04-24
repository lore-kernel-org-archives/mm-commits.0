From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-platform-x86-toshiba_acpic-fix-acpi_install_notify_handler-arg.patch removed from -mm tree
Date: Fri, 24 Apr 2009 12:27:26 -0700
Message-ID: <200904241927.n3OJRQ68015728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbZDXT3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 15:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, len.brown@intel.com, mjg59@srcf.ucam.org, mm-commits@vger.kernel.org


The patch titled
     drivers/platform/x86/toshiba_acpi.c: fix acpi_install_notify_handler() arg
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-toshiba_acpic-fix-acpi_install_notify_handler-arg.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/platform/x86/toshiba_acpi.c: fix acpi_install_notify_handler() arg
From: Andrew Morton <akpm@linux-foundation.org>

drivers/platform/x86/toshiba_acpi.c: In function 'toshiba_acpi_setup_keyboard':
drivers/platform/x86/toshiba_acpi.c:854: warning: passing argument 3 of 'acpi_install_notify_handler' from incompatible pointer type
drivers/platform/x86/toshiba_acpi.c: In function 'toshiba_acpi_exit':
drivers/platform/x86/toshiba_acpi.c:903: warning: passing argument 3 of 'acpi_remove_notify_handler' from incompatible pointer type

Fix this, and make toshiba_acpi_notify()'s argument names match up with the
acpi_notify_handler() declaration.

Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/toshiba_acpi.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/platform/x86/toshiba_acpi.c~drivers-platform-x86-toshiba_acpic-fix-acpi_install_notify_handler-arg drivers/platform/x86/toshiba_acpi.c
--- a/drivers/platform/x86/toshiba_acpi.c~drivers-platform-x86-toshiba_acpic-fix-acpi_install_notify_handler-arg
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -792,24 +792,25 @@ static int toshiba_acpi_setkeycode(struc
 	return -EINVAL;
 }
 
-static void toshiba_acpi_notify(acpi_handle handle, u32 event, void **data)
+static void toshiba_acpi_notify(acpi_handle device, u32 value, void *context)
 {
-	u32 hci_result, value;
+	u32 hci_result;
 	struct key_entry *key;
 
-	if (event != 0x80)
+	if (value != 0x80)
 		return;
 	do {
-		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+		u32 val;
+		hci_read1(HCI_SYSTEM_EVENT, &val, &hci_result);
 		if (hci_result == HCI_SUCCESS) {
-			if (value == 0x100)
+			if (val == 0x100)
 				continue;
-			else if (value & 0x80) {
+			else if (val & 0x80) {
 				key = toshiba_acpi_get_entry_by_scancode
-					(value & ~0x80);
+					(val & ~0x80);
 				if (!key) {
 					printk(MY_INFO "Unknown key %x\n",
-					       value & ~0x80);
+					       val & ~0x80);
 					continue;
 				}
 				input_report_key(toshiba_acpi.hotkey_dev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
block-turn-some-buggy-macros-into-c-functions.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-platform-x86-toshiba_acpic-fix-acpi_install_notify_handler-arg.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

