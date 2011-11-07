From: akpm@linux-foundation.org
Subject: [merged] drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:21 -0800
Message-ID: <201111072028.pA7KSLSJ012672@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1KGU2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b34182@freescale.com, Gang.Liu@freescale.com, alexandre.bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rapidio/rio-scan.c: use discovered bit to test if enumeration is complete
has been removed from the -mm tree.  Its filename was
     drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Liu Gang <b34182@freescale.com>
Subject: drivers/rapidio/rio-scan.c: use discovered bit to test if enumeration is complete

The discovered bit in PGCCSR register indicates if the device has been
discovered by system host.  In Rapidio systems, some agent devices can also
be master devices.  They can issue requests into the system.

Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete
+++ a/drivers/rapidio/rio-scan.c
@@ -923,7 +923,7 @@ static int __devinit rio_enum_peer(struc
  * rio_enum_complete- Tests if enumeration of a network is complete
  * @port: Master port to send transaction
  *
- * Tests the Component Tag CSR for non-zero value (enumeration
+ * Tests the PGCCSR discovered bit for non-zero value (enumeration
  * complete flag). Return %1 if enumeration is complete or %0 if
  * enumeration is incomplete.
  */
@@ -933,7 +933,7 @@ static int rio_enum_complete(struct rio_
 
 	rio_local_read_config_32(port, port->phys_efptr + RIO_PORT_GEN_CTL_CSR,
 				 &regval);
-	return (regval & RIO_PORT_GEN_MASTER) ? 1 : 0;
+	return (regval & RIO_PORT_GEN_DISCOVERED) ? 1 : 0;
 }
 
 /**
_

Patches currently in -mm which might be from b34182@freescale.com are

origin.patch

