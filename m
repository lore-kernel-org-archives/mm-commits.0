From: akpm@linux-foundation.org
Subject: [merged] drivers-nfc-pn544c-add-missing-regulator.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:10:39 -0800
Message-ID: <201102282110.p1SLAdYj029322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187Ab1B1VLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matti.j.aaltonen@nokia.com, mm-commits@vger.kernel.org


The patch titled
     drivers/nfc/pn544.c: add missing regulator
has been removed from the -mm tree.  Its filename was
     drivers-nfc-pn544c-add-missing-regulator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/nfc/pn544.c: add missing regulator
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>

The regulator framework is used for power management.  The regulators are
only named in the driver code, the actual control stuff is in the board
file for each architecture or use case.  

The PN544 chip has three regulators that can be controlled or not -
depending on the architecture where the chip is being used.  So some of
the regulators may not be controllable.  In our current case the third
regulator, which was missing from the code, went unnoticed because we
didn't need to control it.  To be as general as possible - in this respect
- the driver needs to list all regulators.  Then the board file can be
used to actually set the usage.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nfc/pn544.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/nfc/pn544.c~drivers-nfc-pn544c-add-missing-regulator drivers/nfc/pn544.c
--- a/drivers/nfc/pn544.c~drivers-nfc-pn544c-add-missing-regulator
+++ a/drivers/nfc/pn544.c
@@ -60,7 +60,7 @@ enum pn544_irq {
 struct pn544_info {
 	struct miscdevice miscdev;
 	struct i2c_client *i2c_dev;
-	struct regulator_bulk_data regs[2];
+	struct regulator_bulk_data regs[3];
 
 	enum pn544_state state;
 	wait_queue_head_t read_wait;
@@ -74,6 +74,7 @@ struct pn544_info {
 
 static const char reg_vdd_io[]	= "Vdd_IO";
 static const char reg_vbat[]	= "VBat";
+static const char reg_vsim[]	= "VSim";
 
 /* sysfs interface */
 static ssize_t pn544_test(struct device *dev,
@@ -740,6 +741,7 @@ static int __devinit pn544_probe(struct 
 
 	info->regs[0].supply = reg_vdd_io;
 	info->regs[1].supply = reg_vbat;
+	info->regs[2].supply = reg_vsim;
 	r = regulator_bulk_get(&client->dev, ARRAY_SIZE(info->regs),
 				 info->regs);
 	if (r < 0)
_

Patches currently in -mm which might be from matti.j.aaltonen@nokia.com are

origin.patch

