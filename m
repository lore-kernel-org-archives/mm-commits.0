From: akpm@linux-foundation.org
Subject: - usb-fix-debug-output-of-ark3116.patch removed from -mm tree
Date: Tue, 22 May 2007 13:57:00 -0700
Message-ID: <200705222056.l4MKux9u009602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873AbXEVU6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:58:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     usb: fix debug output of ark3116
has been removed from the -mm tree.  Its filename was
     usb-fix-debug-output-of-ark3116.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: fix debug output of ark3116
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Fix debug output.  Previously, it would output "0xFFFFFFB0" on 32-bit archs
(and probably "0xFFFFFFFFFFFFFFB0" on 64-bits), because buf is taken as
signed char, which is promoted to signed int, while %x always expects an
unsigned int.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ark3116.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/usb/serial/ark3116.c~usb-fix-debug-output-of-ark3116 drivers/usb/serial/ark3116.c
--- a/drivers/usb/serial/ark3116.c~usb-fix-debug-output-of-ark3116
+++ a/drivers/usb/serial/ark3116.c
@@ -63,7 +63,8 @@ static inline void ARK3116_RCV(struct us
 				 request, requesttype, value, index,
 				 buf, 0x0000001, 1000);
 	if (result)
-		dbg("%03d < %d bytes [0x%02X]", seq, result, buf[0]);
+		dbg("%03d < %d bytes [0x%02X]", seq, result,
+		    ((unsigned char *)buf)[0]);
 	else
 		dbg("%03d < 0 bytes", seq);
 }
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch
