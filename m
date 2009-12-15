From: akpm@linux-foundation.org
Subject: [merged] drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:03 -0800
Message-ID: <200912152158.nBFLw3HC015774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933826AbZLOV7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jgarzik@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/firmware/dmi_scan.c: use %pUB to print UUIDs
has been removed from the -mm tree.  Its filename was
     drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/firmware/dmi_scan.c: use %pUB to print UUIDs
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-use-%pub-to-print-uuids drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~drivers-firmware-dmi_scanc-use-%pub-to-print-uuids
+++ a/drivers/firmware/dmi_scan.c
@@ -169,10 +169,7 @@ static void __init dmi_save_uuid(const s
 	if (!s)
 		return;
 
-	sprintf(s,
-		"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
-		d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7],
-		d[8], d[9], d[10], d[11], d[12], d[13], d[14], d[15]);
+	sprintf(s, "%pUB", d);
 
         dmi_ident[slot] = s;
 }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

