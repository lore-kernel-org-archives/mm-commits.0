From: akpm@linux-foundation.org
Subject: - cris-gpio-undo-locks-before-returning.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:31 -0800
Message-ID: <200711152110.lAFLAVd7015658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760323AbXKOVRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris gpio: undo locks before returning
has been removed from the -mm tree.  Its filename was
     cris-gpio-undo-locks-before-returning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cris gpio: undo locks before returning
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/gpio.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/cris/arch-v10/drivers/gpio.c~cris-gpio-undo-locks-before-returning arch/cris/arch-v10/drivers/gpio.c
--- a/arch/cris/arch-v10/drivers/gpio.c~cris-gpio-undo-locks-before-returning
+++ a/arch/cris/arch-v10/drivers/gpio.c
@@ -297,8 +297,10 @@ gpio_poll(struct file *file,
 		data = *R_PORT_PB_DATA;
 	else if (priv->minor == GPIO_MINOR_G)
 		data = *R_PORT_G_DATA;
-	else
+	else {
+		spin_unlock(&gpio_lock);
 		return 0;
+	}
 	
 	if ((data & priv->highalarm) ||
 	    (~data & priv->lowalarm)) {
@@ -381,18 +383,21 @@ static ssize_t gpio_write(struct file * 
 
 	ssize_t retval = count;
 	if (priv->minor !=GPIO_MINOR_A && priv->minor != GPIO_MINOR_B) {
-		return -EFAULT;
+		retval = -EFAULT;
+		goto out;
 	}
     
 	if (!access_ok(VERIFY_READ, buf, count)) {
-		return -EFAULT;
+		retval = -EFAULT;
+		goto out;
 	}
 	clk_mask = priv->clk_mask;
 	data_mask = priv->data_mask;
 	/* It must have been configured using the IO_CFG_WRITE_MODE */
 	/* Perhaps a better error code? */
 	if (clk_mask == 0 || data_mask == 0) {
-		return -EPERM;
+		retval = -EPERM;
+		goto out;
 	}
 	write_msb = priv->write_msb;
 	D(printk("gpio_write: %lu to data 0x%02X clk 0x%02X msb: %i\n",count, data_mask, clk_mask, write_msb));
@@ -425,6 +430,7 @@ static ssize_t gpio_write(struct file * 
 			}
 		}
 	}
+out:
 	spin_unlock(&gpio_lock);
 	return retval;
 }
@@ -506,6 +512,7 @@ gpio_release(struct inode *inode, struct
 	while (p) {
 		if (p->highalarm | p->lowalarm) {
 			gpio_some_alarms = 1;
+			spin_unlock(&gpio_lock);
 			return 0;
 		}
 		p = p->next;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
git-dvb.patch
git-mips.patch
git-netdev-all.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
