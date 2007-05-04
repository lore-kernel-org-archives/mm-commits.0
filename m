From: akpm@linux-foundation.org
Subject: + driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch added to -mm tree
Date: Fri, 04 May 2007 01:56:52 -0700
Message-ID: <200705040856.l448uqqf000375@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767764AbXEDI5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 04:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mreimer@vpop.net, johnpol@2ka.mipt.ru


The patch titled
     ds1wm: disable interrupts when turning off ds1wm
has been added to the -mm tree.  Its filename is
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch
