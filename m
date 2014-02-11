From: akpm@linux-foundation.org
Subject: [merged]
 drivers-message-i2o-i2o_configc-fix-deadlock-in-compat_ioctli2ogetiops.patch removed from -mm tree
Date: Tue, 11 Feb 2014 11:23:24 -0800
Message-ID: <52fa78ac.Q+pOWoAfEI9FLzMS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaBKTXY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khoroshilov@ispras.ru

Subject: [merged] drivers-message-i2o-i2o_configc-fix-deadlock-in-compat_ioctli2ogetiops.patch removed from -mm tree
To: khoroshilov@ispras.ru,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:24 -0800


The patch titled
     Subject: drivers/message/i2o/i2o_config.c: fix deadlock in compat_ioctl(I2OGETIOPS)
has been removed from the -mm tree.  Its filename was
     drivers-message-i2o-i2o_configc-fix-deadlock-in-compat_ioctli2ogetiops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: drivers/message/i2o/i2o_config.c: fix deadlock in compat_ioctl(I2OGETIOPS)

i2o_cfg_compat_ioctl(I2OGETIOPS) locks i2o_cfg_mutex and then calls
i2o_cfg_ioctl(I2OGETIOPS) that locks i2o_cfg_mutex as well.  A deadlock is
guaranteed.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_config.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/message/i2o/i2o_config.c~drivers-message-i2o-i2o_configc-fix-deadlock-in-compat_ioctli2ogetiops drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~drivers-message-i2o-i2o_configc-fix-deadlock-in-compat_ioctli2ogetiops
+++ a/drivers/message/i2o/i2o_config.c
@@ -754,19 +754,19 @@ static long i2o_cfg_compat_ioctl(struct
 				 unsigned long arg)
 {
 	int ret;
-	mutex_lock(&i2o_cfg_mutex);
 	switch (cmd) {
 	case I2OGETIOPS:
 		ret = i2o_cfg_ioctl(file, cmd, arg);
 		break;
 	case I2OPASSTHRU32:
+		mutex_lock(&i2o_cfg_mutex);
 		ret = i2o_cfg_passthru32(file, cmd, arg);
+		mutex_unlock(&i2o_cfg_mutex);
 		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
_

Patches currently in -mm which might be from khoroshilov@ispras.ru are

origin.patch
linux-next.patch

