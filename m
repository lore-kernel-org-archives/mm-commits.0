From: akpm@linux-foundation.org
Subject: + rapidio-fix-idle2-bits-corruption.patch added to -mm tree
Date: Mon, 04 Oct 2010 15:25:59 -0700
Message-ID: <201010042225.o94MPx50019223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793Ab0JDW05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 18:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     RapidIO: fix IDLE2 bits corruption
has been added to the -mm tree.  Its filename is
     rapidio-fix-idle2-bits-corruption.patch

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
Subject: RapidIO: fix IDLE2 bits corruption
From: Alexandre Bounine <alexandre.bounine@idt.com>

RapidIO spec v.2.1 adds Idle Sequence 2 into LP-Serial Physical Layer. 
The fix ensures that corresponding bits are not corrupted during error
handling.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c    |    9 ++-------
 include/linux/rio_regs.h |    3 +--
 2 files changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-fix-idle2-bits-corruption drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-fix-idle2-bits-corruption
+++ a/drivers/rapidio/rio.c
@@ -871,15 +871,10 @@ int rio_inb_pwrite_handler(union rio_pw_
 			rdev->em_efptr + RIO_EM_LTL_ERR_DETECT, 0);
 	}
 
-	/* Clear remaining error bits */
+	/* Clear remaining error bits and Port-Write Pending bit */
 	rio_mport_write_config_32(mport, destid, hopcount,
 			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			err_status & RIO_PORT_N_ERR_STS_CLR_MASK);
-
-	/* Clear Port-Write Pending bit */
-	rio_mport_write_config_32(mport, destid, hopcount,
-			rdev->phys_efptr + RIO_PORT_N_ERR_STS_CSR(portnum),
-			RIO_PORT_N_ERR_STS_PW_PEND);
+			err_status);
 
 	return 0;
 }
diff -puN include/linux/rio_regs.h~rapidio-fix-idle2-bits-corruption include/linux/rio_regs.h
--- a/include/linux/rio_regs.h~rapidio-fix-idle2-bits-corruption
+++ a/include/linux/rio_regs.h
@@ -229,7 +229,7 @@
 #define  RIO_MNT_REQ_CMD_IS		0x04	/* Input-status command */
 #define RIO_PORT_N_MNT_RSP_CSR(x)	(0x0044 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_MNT_RSP_RVAL	0x80000000 /* Response Valid */
-#define  RIO_PORT_N_MNT_RSP_ASTAT	0x000003e0 /* ackID Status */
+#define  RIO_PORT_N_MNT_RSP_ASTAT	0x000007e0 /* ackID Status */
 #define  RIO_PORT_N_MNT_RSP_LSTAT	0x0000001f /* Link Status */
 #define RIO_PORT_N_ACK_STS_CSR(x)	(0x0048 + x*0x20)	/* 0x0002 */
 #define  RIO_PORT_N_ACK_CLEAR		0x80000000
@@ -243,7 +243,6 @@
 #define  RIO_PORT_N_ERR_STS_PORT_ERR	0x00000004
 #define  RIO_PORT_N_ERR_STS_PORT_OK	0x00000002
 #define  RIO_PORT_N_ERR_STS_PORT_UNINIT	0x00000001
-#define  RIO_PORT_N_ERR_STS_CLR_MASK	0x07120204
 #define RIO_PORT_N_CTL_CSR(x)		(0x005c + x*0x20)
 #define  RIO_PORT_N_CTL_PWIDTH		0xc0000000
 #define  RIO_PORT_N_CTL_PWIDTH_1	0x00000000
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

