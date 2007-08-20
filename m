From: akpm@linux-foundation.org
Subject: - dtc-clean-up-indent-damage-and-add-printk-levels.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:11 -0700
Message-ID: <200708201913.l7KJDBD9018416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759734AbXHTTVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dtc: clean up indent damage and add printk levels
has been removed from the -mm tree.  Its filename was
     dtc-clean-up-indent-damage-and-add-printk-levels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dtc: clean up indent damage and add printk levels
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dtc.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/dtc.c~dtc-clean-up-indent-damage-and-add-printk-levels drivers/scsi/dtc.c
--- a/drivers/scsi/dtc.c~dtc-clean-up-indent-damage-and-add-printk-levels
+++ a/drivers/scsi/dtc.c
@@ -137,11 +137,9 @@ static struct override {
 #ifdef OVERRIDE
 [] __initdata = OVERRIDE;
 #else
-[4] __initdata = { {
-0, IRQ_AUTO}, {
-0, IRQ_AUTO}, {
-0, IRQ_AUTO}, {
-0, IRQ_AUTO}};
+[4] __initdata = {
+	{ 0, IRQ_AUTO }, { 0, IRQ_AUTO }, { 0, IRQ_AUTO }, { 0, IRQ_AUTO }
+};
 #endif
 
 #define NO_OVERRIDES ARRAY_SIZE(overrides)
@@ -176,7 +174,7 @@ static const struct signature {
  * Inputs : str - unused, ints - array of integer parameters with ints[0]
  *	equal to the number of ints.
  *
-*/
+ */
 
 static void __init dtc_setup(char *str, int *ints)
 {
@@ -233,7 +231,7 @@ static int __init dtc_detect(struct scsi
 		} else
 			for (; !addr && (current_base < NO_BASES); ++current_base) {
 #if (DTCDEBUG & DTCDEBUG_INIT)
-				printk("scsi-dtc : probing address %08x\n", bases[current_base].address);
+				printk(KERN_DEBUG "scsi-dtc : probing address %08x\n", bases[current_base].address);
 #endif
 				if (bases[current_base].noauto)
 					continue;
@@ -244,7 +242,7 @@ static int __init dtc_detect(struct scsi
 					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
 						addr = bases[current_base].address;
 #if (DTCDEBUG & DTCDEBUG_INIT)
-						printk("scsi-dtc : detected board.\n");
+						printk(KERB_DEBUG "scsi-dtc : detected board.\n");
 #endif
 						goto found;
 					}
@@ -253,7 +251,7 @@ static int __init dtc_detect(struct scsi
 			}
 
 #if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
-		printk("scsi-dtc : base = %08x\n", addr);
+		printk(KERN_DEBUG "scsi-dtc : base = %08x\n", addr);
 #endif
 
 		if (!addr)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
