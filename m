From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf8583-use-dev_warn-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:38 -0800
Message-ID: <20130222204438.A77E331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:58829 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758377Ab3BVUoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:39 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so104101qcr.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcf8583: use dev_warn() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf8583-use-dev_warn-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcf8583: use dev_warn() instead of printk()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-rtc-pcf8583-use-dev_warn-instead-of-printk drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-rtc-pcf8583-use-dev_warn-instead-of-printk
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -185,8 +185,8 @@ static int pcf8583_rtc_read_time(struct 
 	if (ctrl & (CTRL_STOP | CTRL_HOLD)) {
 		unsigned char new_ctrl = ctrl & ~(CTRL_STOP | CTRL_HOLD);
 
-		printk(KERN_WARNING "RTC: resetting control %02x -> %02x\n",
-		       ctrl, new_ctrl);
+		dev_warn(dev, "resetting control %02x -> %02x\n",
+			ctrl, new_ctrl);
 
 		if ((err = pcf8583_set_ctrl(client, &new_ctrl)) < 0)
 			return err;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

