From: akpm@linux-foundation.org
Subject: + rapidio-use-default-route-value-for-cps-switches.patch added to -mm tree
Date: Tue, 04 May 2010 16:25:21 -0700
Message-ID: <201005042325.o44NPLvG025158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934634Ab0EDX0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 19:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: use default route value for CPS switches
has been added to the -mm tree.  Its filename is
     rapidio-use-default-route-value-for-cps-switches.patch

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
Subject: rapidio: use default route value for CPS switches
From: Alexandre Bounine <alexandre.bounine@idt.com>

Fix to use correct default value for routing table entries.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idtcps.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/rapidio/switches/idtcps.c~rapidio-use-default-route-value-for-cps-switches drivers/rapidio/switches/idtcps.c
--- a/drivers/rapidio/switches/idtcps.c~rapidio-use-default-route-value-for-cps-switches
+++ a/drivers/rapidio/switches/idtcps.c
@@ -15,7 +15,8 @@
 #include <linux/rio_ids.h>
 #include "../rio.h"
 
-#define CPS_NO_ROUTE 0xdf
+#define CPS_DEFAULT_ROUTE	0xde
+#define CPS_NO_ROUTE		0xdf
 
 #define IDTCPS_RIO_DOMAIN 0xf20020
 
@@ -53,10 +54,11 @@ idtcps_route_get_entry(struct rio_mport 
 		rio_mport_read_config_32(mport, destid, hopcount,
 				RIO_STD_RTE_CONF_PORT_SEL_CSR, &result);
 
-		if (CPS_NO_ROUTE == (u8)result)
-			result = RIO_INVALID_ROUTE;
-
-		*route_port = (u8)result;
+		if (CPS_DEFAULT_ROUTE == (u8)result ||
+		    CPS_NO_ROUTE == (u8)result)
+			*route_port = RIO_INVALID_ROUTE;
+		else
+			*route_port = (u8)result;
 	}
 
 	return 0;
@@ -74,9 +76,9 @@ idtcps_route_clr_table(struct rio_mport 
 				RIO_STD_RTE_CONF_DESTID_SEL_CSR, i);
 			rio_mport_write_config_32(mport, destid, hopcount,
 				RIO_STD_RTE_CONF_PORT_SEL_CSR,
-				(RIO_INVALID_ROUTE << 24) |
-				(RIO_INVALID_ROUTE << 16) |
-				(RIO_INVALID_ROUTE << 8) | RIO_INVALID_ROUTE);
+				(CPS_DEFAULT_ROUTE << 24) |
+				(CPS_DEFAULT_ROUTE << 16) |
+				(CPS_DEFAULT_ROUTE << 8) | CPS_DEFAULT_ROUTE);
 			i += 4;
 		}
 	}
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch
rapidio-fix-typos-and-minor-edits.patch
rapidio-add-debug-configuration-option.patch
rapidio-modify-initialization-of-switch-operations.patch
rapidio-add-switch-domain-routines.patch
rapidio-use-default-route-value-for-cps-switches.patch

