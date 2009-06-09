From: akpm@linux-foundation.org
Subject: [merged] mtd-add-sst39sf040-chip-to-jedec_probe.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:10 -0700
Message-ID: <200906091812.n59ICAVa018439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758995AbZFISMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mirq-linux@rere.qmqm.pl, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: add SST39SF040 chip to jedec_probe
has been removed from the -mm tree.  Its filename was
     mtd-add-sst39sf040-chip-to-jedec_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: add SST39SF040 chip to jedec_probe
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

Add SST39SF040 chip (like SST39SF020A but bigger - 4Mbit).

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/jedec_probe.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/mtd/chips/jedec_probe.c~mtd-add-sst39sf040-chip-to-jedec_probe drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~mtd-add-sst39sf040-chip-to-jedec_probe
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -166,6 +166,7 @@
 #define SST39LF040	0x00D7
 #define SST39SF010A	0x00B5
 #define SST39SF020A	0x00B6
+#define SST39SF040	0x00B7
 #define SST49LF004B	0x0060
 #define SST49LF040B	0x0050
 #define SST49LF008A	0x005a
@@ -1393,6 +1394,18 @@ static const struct amd_flash_info jedec
 		}
 	}, {
 		.mfr_id		= MANUFACTURER_SST,
+		.dev_id		= SST39SF040,
+		.name		= "SST 39SF040",
+		.devtypes	= CFI_DEVICETYPE_X8,
+		.uaddr		= MTD_UADDR_0x5555_0x2AAA,
+		.dev_size	= SIZE_512KiB,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 1,
+		.regions	= {
+			ERASEINFO(0x01000,128),
+		}
+	}, {
+		.mfr_id		= MANUFACTURER_SST,
 		.dev_id		= SST49LF040B,
 		.name		= "SST 49LF040B",
 		.devtypes	= CFI_DEVICETYPE_X8,
_

Patches currently in -mm which might be from mirq-linux@rere.qmqm.pl are

linux-next.patch
pci-quirks-hp-hides-smbus-controller-in-compaq-nx9500-laptops.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch

