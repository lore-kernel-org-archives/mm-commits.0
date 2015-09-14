From: akpm@linux-foundation.org
Subject: [merged]
 drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null.patch removed from -mm tree
Date: Mon, 14 Sep 2015 10:28:56 -0700
Message-ID: <55f703d8.nh+kfD1/puE+EhqA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbINR24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:28:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, alex.aring@gmail.com, marcel@holtmann.org, stefan@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/net/ieee802154/at86rf230.c: seq_printf() now returns NULL
has been removed from the -mm tree.  Its filename was
     drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: drivers/net/ieee802154/at86rf230.c: seq_printf() now returns NULL

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexander Aring <alex.aring@gmail.com>
Cc: Stefan Schmidt <stefan@osg.samsung.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ieee802154/at86rf230.c |   28 ++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN drivers/net/ieee802154/at86rf230.c~drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null drivers/net/ieee802154/at86rf230.c
--- a/drivers/net/ieee802154/at86rf230.c~drivers-net-ieee802154-at86rf230c-seq_printf-now-returns-null
+++ a/drivers/net/ieee802154/at86rf230.c
@@ -1647,30 +1647,16 @@ static int at86rf230_stats_show(struct s
 	struct at86rf230_local *lp = file->private;
 	int ret;
 
-	ret = seq_printf(file, "SUCCESS:\t\t%8llu\n", lp->trac.success);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "SUCCESS_DATA_PENDING:\t%8llu\n",
+	seq_printf(file, "SUCCESS:\t\t%8llu\n", lp->trac.success);
+	seq_printf(file, "SUCCESS_DATA_PENDING:\t%8llu\n",
 			 lp->trac.success_data_pending);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "SUCCESS_WAIT_FOR_ACK:\t%8llu\n",
+	seq_printf(file, "SUCCESS_WAIT_FOR_ACK:\t%8llu\n",
 			 lp->trac.success_wait_for_ack);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "CHANNEL_ACCESS_FAILURE:\t%8llu\n",
+	seq_printf(file, "CHANNEL_ACCESS_FAILURE:\t%8llu\n",
 			 lp->trac.channel_access_failure);
-	if (ret < 0)
-		return ret;
-
-	ret = seq_printf(file, "NO_ACK:\t\t\t%8llu\n", lp->trac.no_ack);
-	if (ret < 0)
-		return ret;
