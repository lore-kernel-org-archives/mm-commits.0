From: akpm@linux-foundation.org
Subject: - overrun-in-drivers-char-rio-riocmdc.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:57 -0700
Message-ID: <200705120533.l4C5XviY002153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127AbXELFeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snakebyte@gmx.de, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Overrun in drivers/char/rio/riocmd.c
has been removed from the -mm tree.  Its filename was
     overrun-in-drivers-char-rio-riocmdc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Overrun in drivers/char/rio/riocmd.c
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>

This got somehow lost in the noise.  This fixes coverity bug id #1025, if
Rup is greater or equal to MAX_RUP, we run past the Mapping Array.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/riocmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/rio/riocmd.c~overrun-in-drivers-char-rio-riocmdc drivers/char/rio/riocmd.c
--- a/drivers/char/rio/riocmd.c~overrun-in-drivers-char-rio-riocmdc
+++ a/drivers/char/rio/riocmd.c
@@ -402,7 +402,7 @@ static int RIOCommandRup(struct rio_info
 		rio_dprintk(RIO_DEBUG_CMD, "CONTROL information: Host number %Zd, name ``%s''\n", HostP - p->RIOHosts, HostP->Name);
 		rio_dprintk(RIO_DEBUG_CMD, "CONTROL information: Rup number  0x%x\n", rup);
 
-		if (Rup >= (unsigned short) MAX_RUP) {
+		if (Rup < (unsigned short) MAX_RUP) {
 			rio_dprintk(RIO_DEBUG_CMD, "CONTROL information: This is the RUP for RTA ``%s''\n", HostP->Mapping[Rup].Name);
 		} else
 			rio_dprintk(RIO_DEBUG_CMD, "CONTROL information: This is the RUP for link ``%c'' of host ``%s''\n", ('A' + Rup - MAX_RUP), HostP->Name);
_

Patches currently in -mm which might be from snakebyte@gmx.de are

origin.patch
git-ubi.patch
remove-unnecessary-check-in-drivers-scsi-sgc.patch
