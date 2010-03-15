From: akpm@linux-foundation.org
Subject: [merged] edac-e752x-fsb-ecc.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:58 -0400
Message-ID: <201003150702.o2F72VhA016876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kolifer@gmail.com, dougthompson@xmission.com, ptyser@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     edac: e752x fsb ecc
has been removed from the -mm tree.  Its filename was
     edac-e752x-fsb-ecc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

