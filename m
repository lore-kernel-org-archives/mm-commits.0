From: akpm@linux-foundation.org
Subject: + bfin_twi-remove-useless-twi_lock-mutex.patch added to -mm tree
Date: Fri, 14 Sep 2007 16:33:42 -0700
Message-ID: <200709142333.l8ENXg0T029675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805AbXINXdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 19:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, francis.moro@gmail.com, sonic.zhang@analog.com


The patch titled
     bfin_twi: Remove useless twi_lock mutex
has been added to the -mm tree.  Its filename is
     bfin_twi-remove-useless-twi_lock-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bfin_twi: Remove useless twi_lock mutex
From: Bryan Wu <bryan.wu@analog.com>

This patch removes this unneeded mutex.  Indeed it was used to serialized
access to the hardware, but this is already done by the i2c-core layer, see
'bus_lock' mutex used by i2c_transfer().

Signed-off-by: Francis Moreau <francis.moro@gmail.com>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-bfin-twi.c |   16 ----------------
 1 files changed, 16 deletions(-)

diff -puN drivers/i2c/busses/i2c-bfin-twi.c~bfin_twi-remove-useless-twi_lock-mutex drivers/i2c/busses/i2c-bfin-twi.c
--- a/drivers/i2c/busses/i2c-bfin-twi.c~bfin_twi-remove-useless-twi_lock-mutex
+++ a/drivers/i2c/busses/i2c-bfin-twi.c
@@ -44,7 +44,6 @@
 #define TWI_I2C_MODE_COMBINED		0x04
 
 struct bfin_twi_iface {
-	struct mutex		twi_lock;
 	int			irq;
 	spinlock_t		lock;
 	char			read_write;
@@ -228,12 +227,8 @@ static int bfin_twi_master_xfer(struct i
 	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
 		return -ENXIO;
 
-	mutex_lock(&iface->twi_lock);
-
 	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
-		mutex_unlock(&iface->twi_lock);
 		yield();
-		mutex_lock(&iface->twi_lock);
 	}
 
 	ret = 0;
@@ -310,9 +305,6 @@ static int bfin_twi_master_xfer(struct i
 			break;
 	}
 
-	/* Release mutex */
-	mutex_unlock(&iface->twi_lock);
-
 	return ret;
 }
 
@@ -330,12 +322,8 @@ int bfin_twi_smbus_xfer(struct i2c_adapt
 	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
 		return -ENXIO;
 
-	mutex_lock(&iface->twi_lock);
-
 	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
-		mutex_unlock(&iface->twi_lock);
 		yield();
-		mutex_lock(&iface->twi_lock);
 	}
 
 	iface->writeNum = 0;
@@ -502,9 +490,6 @@ int bfin_twi_smbus_xfer(struct i2c_adapt
 
 	rc = (iface->result >= 0) ? 0 : -1;
 
-	/* Release mutex */
-	mutex_unlock(&iface->twi_lock);
-
 	return rc;
 }
 
@@ -555,7 +540,6 @@ static int i2c_bfin_twi_probe(struct pla
 	struct i2c_adapter *p_adap;
 	int rc;
 
-	mutex_init(&(iface->twi_lock));
 	spin_lock_init(&(iface->lock));
 	init_completion(&(iface->complete));
 	iface->irq = IRQ_TWI;
_

Patches currently in -mm which might be from bryan.wu@analog.com are

fix-serial_core_console-driver-dependencies.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
bfin_twi-remove-useless-twi_lock-mutex.patch
blackfin-enable-arbitary-speed-serial-setting.patch
kconfig-syntax-cleanups.patch
add-stack-checking-for-blackfin.patch
maintainters-use-our-mail-list-as-blackfin-arch-maintainters.patch
bitops-introduce-lock-ops.patch
