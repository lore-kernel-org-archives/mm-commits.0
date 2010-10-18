From: akpm@linux-foundation.org
Subject: + rapidio-fix-destructive-port-em-initialization-for-tsi568.patch added to -mm tree
Date: Mon, 18 Oct 2010 12:53:27 -0700
Message-ID: <201010181953.o9IJrRsR030724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933204Ab0JRTyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 15:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: fix destructive port EM initialization for Tsi568
has been added to the -mm tree.  Its filename is
     rapidio-fix-destructive-port-em-initialization-for-tsi568.patch

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
Subject: rapidio: fix destructive port EM initialization for Tsi568
From: Alexandre Bounine <alexandre.bounine@idt.com>

Replace possibly damaging broadcast writes into the per-port SP_MODE
registers with individual writes for each port.  This will preserve
individual port configurations in case if ports are configured
differently.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/tsi568.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/switches/tsi568.c~rapidio-fix-destructive-port-em-initialization-for-tsi568 drivers/rapidio/switches/tsi568.c
--- a/drivers/rapidio/switches/tsi568.c~rapidio-fix-destructive-port-em-initialization-for-tsi568
+++ a/drivers/rapidio/switches/tsi568.c
@@ -29,7 +29,7 @@
 #define SPP_ROUTE_CFG_DESTID(n)	(0x11070 + 0x100*n)
 #define SPP_ROUTE_CFG_PORT(n)	(0x11074 + 0x100*n)
 
-#define TSI568_SP_MODE_BC	0x10004
+#define TSI568_SP_MODE(n)	(0x11004 + 0x100*n)
 #define  TSI568_SP_MODE_PW_DIS	0x08000000
 
 static int
@@ -117,14 +117,19 @@ tsi568_em_init(struct rio_dev *rdev)
 	u16 destid = rdev->rswitch->destid;
 	u8 hopcount = rdev->rswitch->hopcount;
 	u32 regval;
+	int portnum;
 
 	pr_debug("TSI568 %s [%d:%d]\n", __func__, destid, hopcount);
 
 	/* Make sure that Port-Writes are disabled (for all ports) */
-	rio_mport_read_config_32(mport, destid, hopcount,
-			TSI568_SP_MODE_BC, &regval);
-	rio_mport_write_config_32(mport, destid, hopcount,
-			TSI568_SP_MODE_BC, regval | TSI568_SP_MODE_PW_DIS);
+	for (portnum = 0;
+	     portnum < RIO_GET_TOTAL_PORTS(rdev->swpinfo); portnum++) {
+		rio_mport_read_config_32(mport, destid, hopcount,
+				TSI568_SP_MODE(portnum), &regval);
+		rio_mport_write_config_32(mport, destid, hopcount,
+				TSI568_SP_MODE(portnum),
+				regval | TSI568_SP_MODE_PW_DIS);
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-rapidio-sysfs-hierarchy.patch
rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch
rapidio-use-stored-ingress-port-number-instead-of-register-read.patch
rapidio-add-relation-links-between-rio-device-structures.patch
rapidio-add-default-handler-for-error-stopped-state.patch
rapidio-modify-sysfs-initialization-for-switches.patch
rapidio-add-handling-of-orphan-port-write-message.patch
rapidio-add-device-access-check-into-the-enumeration.patch
rapidio-add-support-for-idt-cps-gen2-switches.patch
rapidio-add-handling-of-redundant-routes.patch
rapidio-fix-idle2-bits-corruption.patch
rapidio-fix-maximum-port-number-in-tsi57x-em-initialization.patch
rapidio-fix-destructive-port-em-initialization-for-tsi568.patch

