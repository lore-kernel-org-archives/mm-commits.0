From: akpm@linux-foundation.org
Subject: + drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch added to -mm tree
Date: Mon, 22 Aug 2011 17:04:30 -0700
Message-ID: <201108230004.p7N04Ui8015167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab1HWAFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 20:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b34182@freescale.com, Gang.Liu@freescale.com, alexandre.bounine@idt.com


The patch titled
     drivers/rapidio/rio-scan.c: use discovered bit to test if enumeration is complete
has been added to the -mm tree.  Its filename is
     drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch

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
Subject: drivers/rapidio/rio-scan.c: use discovered bit to test if enumeration is complete
From: Liu Gang <b34182@freescale.com>

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

drivers-rapidio-rio-scanc-use-discovered-bit-to-test-if-enumeration-is-complete.patch

