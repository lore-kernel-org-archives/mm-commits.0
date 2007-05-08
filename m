From: akpm@linux-foundation.org
Subject: - driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch removed from -mm tree
Date: Mon, 07 May 2007 22:10:13 -0700
Message-ID: <200705080510.l485ADU2014107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967869AbXEHFKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 01:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mreimer@vpop.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     ds1wm: disable interrupts when turning off ds1wm
has been removed from the -mm tree.  Its filename was
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch

This patch was dropped because it was folded into driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch

------------------------------------------------------
Subject: ds1wm: disable interrupts when turning off ds1wm
From: Matt Reimer <mreimer@vpop.net>

Disable interrupts when turning off ds1wm.

Signed-off-by: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/w1/masters/ds1wm.c~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm
+++ a/drivers/w1/masters/ds1wm.c
@@ -237,6 +237,10 @@ static void ds1wm_down(struct ds1wm_data
 {
 	ds1wm_reset(ds1wm_data);
 
+	/* Disable interrupts. */
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
+			     ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0);
+
 	if (ds1wm_data->pdata->disable)
 		ds1wm_data->pdata->disable(ds1wm_data->pdev);
 
_

Patches currently in -mm which might be from mreimer@vpop.net are

w1-allow-bus-master-to-have-reset-and-byte-ops.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch
