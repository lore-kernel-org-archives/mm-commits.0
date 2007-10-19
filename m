From: akpm@linux-foundation.org
Subject: - char-rocket-remove-pci_read_config_dwordclass_revision.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:39 -0700
Message-ID: <200710190344.l9J3id5N013161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934479AbXJSDzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: rocket, remove pci_read_config_dword(CLASS_REVISION)
has been removed from the -mm tree.  Its filename was
     char-rocket-remove-pci_read_config_dwordclass_revision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: rocket, remove pci_read_config_dword(CLASS_REVISION)
From: Jiri Slaby <jirislaby@gmail.com>

We may use pdev->revision instead of reading pci config space directly, so
remove pci_read_config_dword invoking.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/char/rocket.c~char-rocket-remove-pci_read_config_dwordclass_revision drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-remove-pci_read_config_dwordclass_revision
+++ a/drivers/char/rocket.c
@@ -1873,8 +1873,6 @@ static __init int register_PCI(int i, st
 	int fast_clock = 0;
 	int altChanRingIndicator = 0;
 	int ports_per_aiop = 8;
-	int ret;
-	unsigned int class_rev;
 	WordIO_t ConfigIO = 0;
 	ByteIO_t UPCIRingInd = 0;
 
@@ -1882,12 +1880,6 @@ static __init int register_PCI(int i, st
 		return 0;
 
 	rcktpt_io_addr[i] = pci_resource_start(dev, 0);
-	ret = pci_read_config_dword(dev, PCI_CLASS_REVISION, &class_rev);
-
-	if (ret) {
-		printk(KERN_INFO "  Error during register_PCI(), unable to read config dword \n");
-		return 0;
-	}
 
 	rcktpt_type[i] = ROCKET_TYPE_NORMAL;
 	rocketModel[i].loadrm2 = 0;
@@ -2041,8 +2033,9 @@ static __init int register_PCI(int i, st
 		ports_per_aiop = 6;
 		str = "6-port";
 
-		/*  If class_rev is 1, the rocketmodem flash must be loaded.  If it is 2 it is a "socketed" version. */
-		if ((class_rev & 0xFF) == 1) {
+		/*  If revision is 1, the rocketmodem flash must be loaded.
+		 *  If it is 2 it is a "socketed" version. */
+		if (dev->revision == 1) {
 			rcktpt_type[i] = ROCKET_TYPE_MODEMII;
 			rocketModel[i].loadrm2 = 1;
 		} else {
@@ -2057,7 +2050,7 @@ static __init int register_PCI(int i, st
 		max_num_aiops = 1;
 		ports_per_aiop = 4;
 		str = "4-port";
-		if ((class_rev & 0xFF) == 1) {
+		if (dev->revision == 1) {
 			rcktpt_type[i] = ROCKET_TYPE_MODEMII;
 			rocketModel[i].loadrm2 = 1;
 		} else {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
misc-phantom-synchronize_irq-on-suspend.patch
misc-phantom-add-comment-about-openhaptics.patch
misc-phantom-improved-data-passing.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
