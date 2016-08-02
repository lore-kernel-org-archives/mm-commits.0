From: akpm@linux-foundation.org
Subject: [patch 089/111] rapidio: remove unnecessary 0x prefixes before
 %pa extension uses
Date: Tue, 02 Aug 2016 14:06:28 -0700
Message-ID: <57a10b54.RLv2Fjp8ESN0oY8X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbcHBVXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org

From: Joe Perches <joe@perches.com>
Subject: rapidio: remove unnecessary 0x prefixes before %pa extension uses

Patch series "RapidIO subsystem updates".

This set of patches contains RapidIO subsystem fixes and updates that have
been made since kernel v4.6.  The most significant update brings changes
related to the latest revision of RapidIO specification (rev.3.x) and
introduction of next generation of RapidIO switches by IDT (RXS1632 and
RXS2448).



This patch (of 13):

This is RapidIO part of the original patch submitted by Joe Perches.
(see: https://lkml.org/lkml/2016/3/5/19)

Since commit 3cab1e711297 ("lib/vsprintf: refactor duplicate code
to special_hex_number()") %pa uses have been output with a 0x prefix.

These 0x prefixes in the formats are unnecessary.

Link: http://lkml.kernel.org/r/1469125134-16523-2-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    4 ++--
 drivers/rapidio/devices/tsi721.c         |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rapidio/devices/rio_mport_cdev.c~rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses drivers/rapidio/devices/rio_mport_cdev.c
--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2242,7 +2242,7 @@ static void mport_mm_open(struct vm_area
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
 
-rmcd_debug(MMAP, "0x%pad", &map->phys_addr);
+	rmcd_debug(MMAP, "%pad", &map->phys_addr);
 	kref_get(&map->ref);
 }
 
@@ -2250,7 +2250,7 @@ static void mport_mm_close(struct vm_are
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
 
-rmcd_debug(MMAP, "0x%pad", &map->phys_addr);
+	rmcd_debug(MMAP, "%pad", &map->phys_addr);
 	mutex_lock(&map->md->buf_mutex);
 	kref_put(&map->ref, mport_release_mapping);
 	mutex_unlock(&map->md->buf_mutex);
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses
+++ a/drivers/rapidio/devices/tsi721.c
@@ -1101,7 +1101,7 @@ static int tsi721_rio_map_inb_mem(struct
 		ibw_start = lstart & ~(ibw_size - 1);
 
 		tsi_debug(IBW, &priv->pdev->dev,
-			"Direct (RIO_0x%llx -> PCIe_0x%pad), size=0x%x, ibw_start = 0x%llx",
+			"Direct (RIO_0x%llx -> PCIe_%pad), size=0x%x, ibw_start = 0x%llx",
 			rstart, &lstart, size, ibw_start);
 
 		while ((lstart + size) > (ibw_start + ibw_size)) {
@@ -1120,7 +1120,7 @@ static int tsi721_rio_map_inb_mem(struct
 
 	} else {
 		tsi_debug(IBW, &priv->pdev->dev,
-			"Translated (RIO_0x%llx -> PCIe_0x%pad), size=0x%x",
+			"Translated (RIO_0x%llx -> PCIe_%pad), size=0x%x",
 			rstart, &lstart, size);
 
 		if (!is_power_of_2(size) || size < 0x1000 ||
@@ -1215,7 +1215,7 @@ static int tsi721_rio_map_inb_mem(struct
 	priv->ibwin_cnt--;
 
 	tsi_debug(IBW, &priv->pdev->dev,
-		"Configured IBWIN%d (RIO_0x%llx -> PCIe_0x%pad), size=0x%llx",
+		"Configured IBWIN%d (RIO_0x%llx -> PCIe_%pad), size=0x%llx",
 		i, ibw_start, &loc_start, ibw_size);
 
 	return 0;
@@ -1237,7 +1237,7 @@ static void tsi721_rio_unmap_inb_mem(str
 	int i;
 
 	tsi_debug(IBW, &priv->pdev->dev,
-		"Unmap IBW mapped to PCIe_0x%pad", &lstart);
+		"Unmap IBW mapped to PCIe_%pad", &lstart);
 
 	/* Search for matching active inbound translation window */
 	for (i = 0; i < TSI721_IBWIN_NUM; i++) {
_
