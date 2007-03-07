From: akpm@linux-foundation.org
Subject: - ds1374-check-for-workqueue-creation.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:04 -0800
Message-ID: <200703070422.l274M4eG018961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbXCGEWH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     DS1374: check for workqueue creation
has been removed from the -mm tree.  Its filename was
     ds1374-check-for-workqueue-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DS1374: check for workqueue creation
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

Check if workqueue creation failed.  Further usage of NULL pointed
workqueue is not good I guess ;)

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/ds1374.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/i2c/chips/ds1374.c~ds1374-check-for-workqueue-creation drivers/i2c/chips/ds1374.c
--- a/drivers/i2c/chips/ds1374.c~ds1374-check-for-workqueue-creation
+++ a/drivers/i2c/chips/ds1374.c
@@ -207,6 +207,10 @@ static int ds1374_probe(struct i2c_adapt
 	client->driver = &ds1374_driver;
 
 	ds1374_workqueue = create_singlethread_workqueue("ds1374");
+	if (!ds1374_workqueue) {
+		kfree(client);
+		return -ENOMEM;	/* most expected reason */
+	}
 
 	if ((rc = i2c_attach_client(client)) != 0) {
 		kfree(client);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

mtd-esb2-check-for-closed-rom-window.patch
usb-elan-ftdi-check-for-workqueue-creation-v2.patch
