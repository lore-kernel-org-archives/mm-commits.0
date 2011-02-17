From: akpm@linux-foundation.org
Subject: + drivers-nfc-pn544c-add-missing-regulator.patch added to -mm tree
Date: Thu, 17 Feb 2011 15:16:57 -0800
Message-ID: <201102172316.p1HNGvS9021790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab1BQXRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 18:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matti.j.aaltonen@nokia.com


The patch titled
     drivers/nfc/pn544.c: add missing regulator
has been added to the -mm tree.  Its filename is
     drivers-nfc-pn544c-add-missing-regulator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/nfc/pn544.c: add missing regulator
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>

Add regulator VSim to the regulator array.

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

drivers-nfc-kconfig-use-full-form-of-the-nfc-acronym.patch
drivers-nfc-pn544c-add-missing-regulator.patch

