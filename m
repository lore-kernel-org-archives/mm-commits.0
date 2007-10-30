From: akpm@linux-foundation.org
Subject: - lmc_ioctl-dont-return-with-locks-held.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:52 -0700
Message-ID: <200710301806.l9UI6qWu020557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbXJ3SS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:18:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     lmc_ioctl: don't return with locks held
has been removed from the -mm tree.  Its filename was
     lmc_ioctl-dont-return-with-locks-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lmc_ioctl: don't return with locks held
From: Roel Kluin <12o3l@tiscali.nl>

(akpm: it's doing copy_to_user() inside spin_lock_irqsave(): this driver
appears to be beyond help).

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/lmc/lmc_main.c |   55 +++++++++++++++++++------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff -puN drivers/net/wan/lmc/lmc_main.c~lmc_ioctl-dont-return-with-locks-held drivers/net/wan/lmc/lmc_main.c
--- a/drivers/net/wan/lmc/lmc_main.c~lmc_ioctl-dont-return-with-locks-held
+++ a/drivers/net/wan/lmc/lmc_main.c
@@ -142,9 +142,10 @@ int lmc_ioctl (struct net_device *dev, s
          * To date internally, just copy this out to the user.
          */
     case LMCIOCGINFO: /*fold01*/
-        if (copy_to_user(ifr->ifr_data, &sc->ictl, sizeof (lmc_ctl_t)))
-            return -EFAULT;
-        ret = 0;
+	if (copy_to_user(ifr->ifr_data, &sc->ictl, sizeof(lmc_ctl_t)))
+		ret = -EFAULT;
+	else
+		ret = 0;
         break;
 
     case LMCIOCSINFO: /*fold01*/
@@ -159,8 +160,10 @@ int lmc_ioctl (struct net_device *dev, s
             break;
         }
 
-        if (copy_from_user(&ctl, ifr->ifr_data, sizeof (lmc_ctl_t)))
-            return -EFAULT;
+	if (copy_from_user(&ctl, ifr->ifr_data, sizeof(lmc_ctl_t))) {
+		ret = -EFAULT;
+		break;
+	}
 
         sc->lmc_media->set_status (sc, &ctl);
 
@@ -190,8 +193,10 @@ int lmc_ioctl (struct net_device *dev, s
 		break;
 	    }
 
-	    if (copy_from_user(&new_type, ifr->ifr_data, sizeof(u_int16_t)))
-                return -EFAULT;
+	    if (copy_from_user(&new_type, ifr->ifr_data, sizeof(u_int16_t))) {
+		ret = -EFAULT;
+		break;
+	    }
 
             
 	    if (new_type == old_type)
@@ -229,9 +234,10 @@ int lmc_ioctl (struct net_device *dev, s
         sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
 
         if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
-                         sizeof (struct lmc_xinfo)))
-            return -EFAULT;
-        ret = 0;
+					sizeof(struct lmc_xinfo))) {
+		ret = -EFAULT;
+	else
+		ret = 0;
 
         break;
 
@@ -262,9 +268,9 @@ int lmc_ioctl (struct net_device *dev, s
 
         if (copy_to_user(ifr->ifr_data, &sc->stats,
                          sizeof (struct lmc_statistics)))
-            return -EFAULT;
-
-        ret = 0;
+		ret = -EFAULT;
+	else
+		ret = 0;
         break;
 
     case LMCIOCCLEARLMCSTATS: /*fold01*/
@@ -292,8 +298,10 @@ int lmc_ioctl (struct net_device *dev, s
             break;
         }
 
-        if (copy_from_user(&ctl, ifr->ifr_data, sizeof (lmc_ctl_t)))
-            return -EFAULT;
+	if (copy_from_user(&ctl, ifr->ifr_data, sizeof(lmc_ctl_t))) {
+		ret = -EFAULT;
+		break;
+	}
         sc->lmc_media->set_circuit_type(sc, ctl.circuit_type);
         sc->ictl.circuit_type = ctl.circuit_type;
         ret = 0;
@@ -318,12 +326,15 @@ int lmc_ioctl (struct net_device *dev, s
 
 #ifdef DEBUG
     case LMCIOCDUMPEVENTLOG:
-        if (copy_to_user(ifr->ifr_data, &lmcEventLogIndex, sizeof (u32)))
-            return -EFAULT;
+	if (copy_to_user(ifr->ifr_data, &lmcEventLogIndex, sizeof(u32))) {
+		ret = -EFAULT;
+		break;
+	}
         if (copy_to_user(ifr->ifr_data + sizeof (u32), lmcEventLogBuf, sizeof (lmcEventLogBuf)))
-            return -EFAULT;
+		ret = -EFAULT;
+	else
+		ret = 0;
 
-        ret = 0;
         break;
 #endif /* end ifdef _DBG_EVENTLOG */
     case LMCIOCT1CONTROL: /*fold01*/
@@ -346,8 +357,10 @@ int lmc_ioctl (struct net_device *dev, s
              */
             netif_stop_queue(dev);
 
-            if (copy_from_user(&xc, ifr->ifr_data, sizeof (struct lmc_xilinx_control)))
-                return -EFAULT;
+	if (copy_from_user(&xc, ifr->ifr_data, sizeof(struct lmc_xilinx_control))) {
+		ret = -EFAULT;
+		break;
+	}
             switch(xc.command){
             case lmc_xilinx_reset: /*fold02*/
                 {
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
i4l-errors-with-assignments-in-if.patch
git-arm-master.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
git-s390.patch
git-watchdog.patch
cris-gpio-undo-locks-before-returning.patch
arch-ia64-sn-kernel-mcac-undo-lock-when-sn_oemdata-cant-be-extended.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
