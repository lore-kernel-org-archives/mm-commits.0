From: akpm@linux-foundation.org
Subject: [wrecked] drivers-misc-mei-ratelimit-several-error-messages.patch removed from -mm tree
Date: Fri, 10 Jan 2014 14:01:06 -0800
Message-ID: <52d06da2.yYZZaGfCdp/kd5VB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaAJWBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 17:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomas.winkler@intel.com, greg@kroah.com, imunsie@au1.ibm.com

Subject: [wrecked] drivers-misc-mei-ratelimit-several-error-messages.patch removed from -mm tree
To: imunsie@au1.ibm.com,greg@kroah.com,tomas.winkler@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 14:01:06 -0800


The patch titled
     Subject: drivers/misc/mei: ratelimit several error messages
has been removed from the -mm tree.  Its filename was
     drivers-misc-mei-ratelimit-several-error-messages.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Ian Munsie <imunsie@au1.ibm.com>
Subject: drivers/misc/mei: ratelimit several error messages

I'm unsure of the cause, but I found irq/40-mei_me consuming 100% CPU and
my disk full due to kern.log, syslog and messages rapidly growing in size
filled with these messages:

Dec 23 12:29:57 dukhat kernel: [336224.363138] mei_me 0000:00:16.0: reset: wrong host start response
Dec 23 12:29:57 dukhat kernel: [336224.363140] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Dec 23 12:29:57 dukhat kernel: [336224.363152] mei_me 0000:00:16.0: reset: unexpected enumeration response hbm.
Dec 23 12:29:57 dukhat kernel: [336224.363155] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Dec 23 12:29:57 dukhat kernel: [336224.363185] mei_me 0000:00:16.0: reset: wrong host start response
Dec 23 12:29:57 dukhat kernel: [336224.363187] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Dec 23 12:29:57 dukhat kernel: [336224.363199] mei_me 0000:00:16.0: reset: unexpected enumeration response hbm.
Dec 23 12:29:57 dukhat kernel: [336224.363201] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING

This patch ratelimits those specific messages to reduce the impact if this
problem ever recurs.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/mei/hbm.c  |    4 ++--
 drivers/misc/mei/init.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/mei/hbm.c~drivers-misc-mei-ratelimit-several-error-messages drivers/misc/mei/hbm.c
--- a/drivers/misc/mei/hbm.c~drivers-misc-mei-ratelimit-several-error-messages
+++ a/drivers/misc/mei/hbm.c
@@ -613,7 +613,7 @@ void mei_hbm_dispatch(struct mei_device
 			dev->init_clients_timer = 0;
 			mei_hbm_enum_clients_req(dev);
 		} else {
-			dev_err(&dev->pdev->dev, "reset: wrong host start response\n");
+			dev_err_ratelimited(&dev->pdev->dev, "reset: wrong host start response\n");
 			mei_reset(dev, 1);
 			return;
 		}
@@ -690,7 +690,7 @@ void mei_hbm_dispatch(struct mei_device
 				/* first property reqeust */
 				mei_hbm_prop_req(dev);
 		} else {
-			dev_err(&dev->pdev->dev, "reset: unexpected enumeration response hbm.\n");
+			dev_err_ratelimited(&dev->pdev->dev, "reset: unexpected enumeration response hbm.\n");
 			mei_reset(dev, 1);
 			return;
 		}
diff -puN drivers/misc/mei/init.c~drivers-misc-mei-ratelimit-several-error-messages drivers/misc/mei/init.c
--- a/drivers/misc/mei/init.c~drivers-misc-mei-ratelimit-several-error-messages
+++ a/drivers/misc/mei/init.c
@@ -148,7 +148,7 @@ void mei_reset(struct mei_device *dev, i
 			dev->dev_state != MEI_DEV_POWER_UP);
 
 	if (unexpected)
-		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
+		dev_warn_ratelimited(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
 			 mei_dev_state_str(dev->dev_state));
 
 	ret = mei_hw_reset(dev, interrupts_enabled);
_

Patches currently in -mm which might be from imunsie@au1.ibm.com are


