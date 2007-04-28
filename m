From: akpm@linux-foundation.org
Subject: + w1-printk-format-warning.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:23:23 -0700
Message-ID: <200704280023.l3S0NN71011442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757957AbXD1AYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnpol@2ka.mipt.ru


The patch titled
     W1 printk format warning fix
has been added to the -mm tree.  Its filename is
     w1-printk-format-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: W1 printk format warning fix
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/w1.c~w1-printk-format-warning drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-printk-format-warning
+++ a/drivers/w1/w1.c
@@ -457,7 +457,7 @@ static int __w1_attach_slave_device(stru
 		 (unsigned long long) sl->reg_num.id);
 
 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
-		&sl->dev.bus_id[0]);
+		&sl->dev.bus_id[0], sl);
 
 	err = device_register(&sl->dev);
 	if (err < 0) {
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

w1-printk-format-warning.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-w1.patch
