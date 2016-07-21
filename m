From: akpm@linux-foundation.org
Subject: +
 rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses.patch
 added to -mm tree
Date: Thu, 21 Jul 2016 11:40:16 -0700
Message-ID: <57911710.XS2G5r6xNMmam3Gv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcGUSkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: remove unnecessary 0x prefixes before %pa extension uses
has been added to the -mm tree.  Its filename is
     rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-remove-unnecessary-0x-prefixes-before-%25pa-extension-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-remove-unnecessary-0x-prefixes-before-%25pa-extension-uses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

printk-create-pr_level-functions.patch
checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
checkpatch-allow-c99-style-comments.patch
checkpatch-yet-another-commit-id-improvement.patch
rapidio-remove-unnecessary-0x-prefixes-before-%pa-extension-uses.patch

