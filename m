From: akpm@linux-foundation.org
Subject: - ps3-ignore-storage-devices-that-are-still-being.patch removed from -mm tree
Date: Tue, 11 Sep 2007 13:21:08 -0700
Message-ID: <200709112021.l8BKL8kY027764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967122AbXIKUVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 16:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PS3: ignore storage devices that are still being probed
has been removed from the -mm tree.  Its filename was
     ps3-ignore-storage-devices-that-are-still-being.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PS3: ignore storage devices that are still being probed
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

A storage device may show up in the repository before the hypervisor has
finished probing:

  - If its type is not yet known, it shows up as PS3_DEV_TYPE_STOR_DUMMY,
  - If its regions are being probed, it shows up as having zero regions.

If any of these happen, consider the device not yet present.  The storage
probe thread will retry later.

This fixes the timing-dependent problem where a kernel booted from FLASH ROM
sometimes cannot find the hard disk.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/ps3/platform.h   |    1 
 arch/powerpc/platforms/ps3/repository.c |   29 ++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN arch/powerpc/platforms/ps3/platform.h~ps3-ignore-storage-devices-that-are-still-being arch/powerpc/platforms/ps3/platform.h
--- a/arch/powerpc/platforms/ps3/platform.h~ps3-ignore-storage-devices-that-are-still-being
+++ a/arch/powerpc/platforms/ps3/platform.h
@@ -83,6 +83,7 @@ enum ps3_dev_type {
 	PS3_DEV_TYPE_STOR_ROM = TYPE_ROM,	/* 5 */
 	PS3_DEV_TYPE_SB_GPIO = 6,
 	PS3_DEV_TYPE_STOR_FLASH = TYPE_RBC,	/* 14 */
+	PS3_DEV_TYPE_STOR_DUMMY = 32,
 	PS3_DEV_TYPE_NOACCESS = 255,
 };
 
diff -puN arch/powerpc/platforms/ps3/repository.c~ps3-ignore-storage-devices-that-are-still-being arch/powerpc/platforms/ps3/repository.c
--- a/arch/powerpc/platforms/ps3/repository.c~ps3-ignore-storage-devices-that-are-still-being
+++ a/arch/powerpc/platforms/ps3/repository.c
@@ -349,6 +349,35 @@ int ps3_repository_find_device(struct ps
 		return result;
 	}
 
+	if (tmp.bus_type == PS3_BUS_TYPE_STORAGE) {
+		/*
+		 * A storage device may show up in the repository before the
+		 * hypervisor has finished probing its type and regions
+		 */
+		unsigned int num_regions;
+
+		if (tmp.dev_type == PS3_DEV_TYPE_STOR_DUMMY) {
+			pr_debug("%s:%u storage device not ready\n", __func__,
+				 __LINE__);
+			return -ENODEV;
+		}
+
+		result = ps3_repository_read_stor_dev_num_regions(tmp.bus_index,
+								  tmp.dev_index,
+								  &num_regions);
+		if (result) {
+			pr_debug("%s:%d read_stor_dev_num_regions failed\n",
+				 __func__, __LINE__);
+			return result;
+		}
+
+		if (!num_regions) {
+			pr_debug("%s:%u storage device has no regions yet\n",
+				 __func__, __LINE__);
+			return -ENODEV;
+		}
+	}
+
 	result = ps3_repository_read_dev_id(tmp.bus_index, tmp.dev_index,
 		&tmp.dev_id);
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-scsi-misc.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
