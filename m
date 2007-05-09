From: akpm@linux-foundation.org
Subject: - vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:01 -0700
Message-ID: <200705090300.l49301NW010484@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032633AbXEIDAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, adaplas@pol.net, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     vt: allow for the palette to be exposed and changed via sysfs
has been removed from the -mm tree.  Its filename was
     vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vt: allow for the palette to be exposed and changed via sysfs
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Allow for the palette to be exposed and changed via sysfs.  A call to
/usr/bin/reset will slurp the new definitions in for the current console.

Already posted at http://lkml.org/lkml/2006/1/15/149

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/vt.c~vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs drivers/char/vt.c
--- a/drivers/char/vt.c~vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs
+++ a/drivers/char/vt.c
@@ -934,6 +934,10 @@ int default_grn[] = {0x00,0x00,0xaa,0x55
 int default_blu[] = {0x00,0x00,0x00,0x00,0xaa,0xaa,0xaa,0xaa,
     0x55,0x55,0x55,0x55,0xff,0xff,0xff,0xff};
 
+module_param_array(default_red, int, NULL, S_IRUGO | S_IWUSR);
+module_param_array(default_grn, int, NULL, S_IRUGO | S_IWUSR);
+module_param_array(default_blu, int, NULL, S_IRUGO | S_IWUSR);
+
 /*
  * gotoxy() must verify all boundaries, because the arguments
  * might also be negative. If the given position is out of
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-dvb.patch
git-watchdog.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
