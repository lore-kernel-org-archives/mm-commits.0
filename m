From: akpm@linux-foundation.org
Subject: [merged] randomc-use-%pu-to-print-uuids.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:00 -0800
Message-ID: <200912152158.nBFLw0pO015767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933855AbZLOWE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:04:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     random.c: use %pU to print UUIDs
has been removed from the -mm tree.  Its filename was
     randomc-use-%pu-to-print-uuids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random.c: use %pU to print UUIDs
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/char/random.c~randomc-use-%pu-to-print-uuids drivers/char/random.c
--- a/drivers/char/random.c~randomc-use-%pu-to-print-uuids
+++ a/drivers/char/random.c
@@ -1245,12 +1245,8 @@ static int proc_do_uuid(ctl_table *table
 	if (uuid[8] == 0)
 		generate_random_uuid(uuid);
 
-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
-		"%02x%02x%02x%02x%02x%02x",
-		uuid[0],  uuid[1],  uuid[2],  uuid[3],
-		uuid[4],  uuid[5],  uuid[6],  uuid[7],
-		uuid[8],  uuid[9],  uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15]);
+	sprintf(buf, "%pU", uuid);
+
 	fake_table.data = buf;
 	fake_table.maxlen = sizeof(buf);
 
@@ -1310,7 +1306,7 @@ ctl_table random_table[] = {
 
 /********************************************************************
  *
- * Random funtions for networking
+ * Random functions for networking
  *
  ********************************************************************/
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

