From: akpm@linux-foundation.org
Subject: [merged] fs-ubifs-use-%pub-to-print-uuids.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:11 -0800
Message-ID: <200912152158.nBFLwBri015791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761345AbZLOWMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:12:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, adrian.hunter@nokia.com, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs/ubifs: use %pUB to print UUIDs
has been removed from the -mm tree.  Its filename was
     fs-ubifs-use-%pub-to-print-uuids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ubifs: use %pUB to print UUIDs
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/debug.c |    9 ++-------
 fs/ubifs/super.c |    7 +------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN fs/ubifs/debug.c~fs-ubifs-use-%pub-to-print-uuids fs/ubifs/debug.c
--- a/fs/ubifs/debug.c~fs-ubifs-use-%pub-to-print-uuids
+++ a/fs/ubifs/debug.c
@@ -350,13 +350,8 @@ void dbg_dump_node(const struct ubifs_in
 		       le32_to_cpu(sup->fmt_version));
 		printk(KERN_DEBUG "\ttime_gran      %u\n",
 		       le32_to_cpu(sup->time_gran));
-		printk(KERN_DEBUG "\tUUID           %02X%02X%02X%02X-%02X%02X"
-		       "-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X\n",
-		       sup->uuid[0], sup->uuid[1], sup->uuid[2], sup->uuid[3],
-		       sup->uuid[4], sup->uuid[5], sup->uuid[6], sup->uuid[7],
-		       sup->uuid[8], sup->uuid[9], sup->uuid[10], sup->uuid[11],
-		       sup->uuid[12], sup->uuid[13], sup->uuid[14],
-		       sup->uuid[15]);
+		printk(KERN_DEBUG "\tUUID           %pUB\n",
+		       sup->uuid);
 		break;
 	}
 	case UBIFS_MST_NODE:
diff -puN fs/ubifs/super.c~fs-ubifs-use-%pub-to-print-uuids fs/ubifs/super.c
--- a/fs/ubifs/super.c~fs-ubifs-use-%pub-to-print-uuids
+++ a/fs/ubifs/super.c
@@ -1393,12 +1393,7 @@ static int mount_ubifs(struct ubifs_info
 		c->leb_size, c->leb_size >> 10);
 	dbg_msg("data journal heads:  %d",
 		c->jhead_cnt - NONDATA_JHEADS_CNT);
-	dbg_msg("UUID:                %02X%02X%02X%02X-%02X%02X"
-	       "-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
-	       c->uuid[0], c->uuid[1], c->uuid[2], c->uuid[3],
-	       c->uuid[4], c->uuid[5], c->uuid[6], c->uuid[7],
-	       c->uuid[8], c->uuid[9], c->uuid[10], c->uuid[11],
-	       c->uuid[12], c->uuid[13], c->uuid[14], c->uuid[15]);
+	dbg_msg("UUID:                %pUB", c->uuid);
 	dbg_msg("big_lpt              %d", c->big_lpt);
 	dbg_msg("log LEBs:            %d (%d - %d)",
 		c->log_lebs, UBIFS_LOG_LNUM, c->log_last);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

