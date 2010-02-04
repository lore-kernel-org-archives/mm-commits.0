From: akpm@linux-foundation.org
Subject: + edac-e752x-fsb-ecc.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:43:55 -0800
Message-ID: <201002041843.o14IhtPu014792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757441Ab0BDSn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kolifer@gmail.com, dougthompson@xmission.com, ptyser@xes-inc.com


The patch titled
     edac: e752x fsb ecc
has been added to the -mm tree.  Its filename is
     edac-e752x-fsb-ecc.patch

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
Subject: edac: e752x fsb ecc
From: Konstantin Olifer <kolifer@gmail.com>

FSB parity is only supported on the Xeon processor.  Previously it was
incorrectly enabled for the Celeron as well.

Signed-off-by: Konstantin Olifer <kolifer@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/edac/e752x_edac.c~edac-e752x-fsb-ecc drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-e752x-fsb-ecc
+++ a/drivers/edac/e752x_edac.c
@@ -1073,10 +1073,7 @@ fail:
 
 /* Setup system bus parity mask register.
  * Sysbus parity supported on:
- *   e7320/e7520/e7525 + Xeon
- *   i3100 + Xeon/Celeron
- * Sysbus parity not supported on:
- *   i3100 + Pentium M/Celeron M/Core Duo/Core2 Duo
+ * e7320/e7520/e7525 + Xeon
  */
 static void e752x_init_sysbus_parity_mask(struct e752x_pvt *pvt)
 {
@@ -1087,10 +1084,7 @@ static void e752x_init_sysbus_parity_mas
 	/* Allow module parameter override, else see if CPU supports parity */
 	if (sysbus_parity != -1) {
 		enable = sysbus_parity;
-	} else if (cpu_id[0] &&
-		   ((strstr(cpu_id, "Pentium") && strstr(cpu_id, " M ")) ||
-		    (strstr(cpu_id, "Celeron") && strstr(cpu_id, " M ")) ||
-		    (strstr(cpu_id, "Core") && strstr(cpu_id, "Duo")))) {
+	} else if (cpu_id[0] && !strstr(cpu_id, "Xeon")) {
 		e752x_printk(KERN_INFO, "System Bus Parity not "
 			     "supported by CPU, disabling\n");
 		enable = 0;
_

Patches currently in -mm which might be from kolifer@gmail.com are

edac-e752x-fsb-ecc.patch

