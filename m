From: akpm@linux-foundation.org
Subject: + overrun-in-drivers-char-rio-riocmdc.patch added to -mm tree
Date: Thu, 10 May 2007 15:56:55 -0700
Message-ID: <200705102256.l4AMutBr000690@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173AbXEJW5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, jirislaby@gmail.com


The patch titled
     Overrun in drivers/char/rio/riocmd.c
has been added to the -mm tree.  Its filename is
     overrun-in-drivers-char-rio-riocmdc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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
git-net.patch
remove-unnecessary-check-in-drivers-scsi-sgc.patch
overrun-in-drivers-char-rio-riocmdc.patch
