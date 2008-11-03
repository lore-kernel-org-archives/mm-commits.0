From: akpm@linux-foundation.org
Subject: + drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix.patch added to -mm tree
Date: Mon, 03 Nov 2008 15:27:35 -0800
Message-ID: <200811032327.mA3NRa0C031092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025AbYKCX2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 18:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu, steven.noonan@uplinklabs.net, steven@uplinklabs.net


The patch titled
     drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix
has been added to the -mm tree.  Its filename is
     drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix.patch

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
Subject: drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Steven Noonan <steven.noonan@uplinklabs.net>
Cc: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/pci-quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/pci-quirks.c~drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix drivers/usb/host/pci-quirks.c
--- a/drivers/usb/host/pci-quirks.c~drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix
+++ a/drivers/usb/host/pci-quirks.c
@@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_
 			/* if boot firmware now owns EHCI, spin till
 			 * it hands it over.
 			 */
-			msec = 250;
+			msec = 1000;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
 				msleep(10);
@@ -287,7 +287,7 @@ static void __devinit quirk_usb_disable_
 				pci_write_config_byte(pdev, offset + 2, 0);
 
 				/* verify that the BIOS handoff was forced */
-				msec = 250;
+				msec = 1000;
 				while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 					msleep(10);
 					msec -= 10;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
drivers-usb-host-pci-quirksc-wait-for-ehci-handoff-far-too-long-in-quirk_usb_disable_ehci-fix.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

