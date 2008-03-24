From: akpm@linux-foundation.org
Subject: + pci-revert-smbus-unhide-on-hp-compaq-nx6110.patch added to -mm tree
Date: Mon, 24 Mar 2008 14:45:39 -0700
Message-ID: <200803242145.m2OLjd6X026735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000AbYCXVql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 17:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, gregkh@suse.de, tomek@koprowski.org


The patch titled
     pci: revert SMBus unhide on HP Compaq nx6110
has been added to the -mm tree.  Its filename is
     pci-revert-smbus-unhide-on-hp-compaq-nx6110.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: revert SMBus unhide on HP Compaq nx6110
From: Jean Delvare <khali@linux-fr.org>

This reverts commit 3c0a654e390d00fef9d8faed758f5e1e8078adb5 and
fixes kernel bug #10245.
http://bugzilla.kernel.org/show_bug.cgi?id=10245

The HP Compaq nc6120 has the same PCI sub-device ID as the nx6110, and the
SMBus is used by ACPI for thermal management on the nc6120, so Linux should
not attach a native driver to it.  This means that this quirk is unsafe and
has to be removed.

I also added a comment to help developers realize that adding new IDs to this
SMBus unhiding quirk table should be done only with great care, and in
particular only after checking that ACPI is not making use of the SMBus.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Tomasz Koprowski <tomek@koprowski.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/pci/quirks.c~pci-revert-smbus-unhide-on-hp-compaq-nx6110 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-revert-smbus-unhide-on-hp-compaq-nx6110
+++ a/drivers/pci/quirks.c
@@ -951,6 +951,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
  * accesses to the SMBus registers, with potentially bad effects. Thus you
  * should be very careful when adding new entries: if SMM is accessing the
  * Intel SMBus, this is a very good reason to leave it hidden.
+ *
+ * Likewise, many recent laptops use ACPI for thermal management. If the
+ * ACPI DSDT code accesses the SMBus, then Linux should not access it
+ * natively, and keeping the SMBus hidden is the right thing to do. If you
+ * are about to add an entry in the table below, please first disassemble
+ * the DSDT and double-check that there is no code accessing the SMBus.
  */
 static int asus_hides_smbus;
 
@@ -1028,11 +1034,6 @@ static void __init asus_hides_smbus_host
 			case 0x12bf: /* HP xw4100 */
 				asus_hides_smbus = 1;
 			}
-		else if (dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB)
-			switch (dev->subsystem_device) {
-			case 0x099c: /* HP Compaq nx6110 */
-				asus_hides_smbus = 1;
-			}
        } else if (unlikely(dev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG)) {
                if (dev->device ==  PCI_DEVICE_ID_INTEL_82855PM_HB)
                        switch(dev->subsystem_device) {
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-dvb.patch
git-hwmon.patch
git-hid.patch
dmi-clean-up-dmi-helper-declarations.patch
radeonfb-fix-debug-option.patch
radeonfb-drop-redundant-rtrace-macro.patch
radeonfb-speed-up-the-i2c-buses.patch
savagefb-speed-up-the-i2c-bus.patch
video-replace-remaining-__function__-occurrences.patch
pci-revert-smbus-unhide-on-hp-compaq-nx6110.patch

