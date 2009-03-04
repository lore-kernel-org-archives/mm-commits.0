From: akpm@linux-foundation.org
Subject: [merged] airo-reduce-stack-memory-footprint.patch removed from -mm tree
Date: Wed, 04 Mar 2009 10:37:12 -0800
Message-ID: <200903041837.n24IbCvE020563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923AbZCDSiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 13:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: frank@f-seidel.de, dcbw@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     airo: reduce stack memory footprint
has been removed from the -mm tree.  Its filename was
     airo-reduce-stack-memory-footprint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: airo: reduce stack memory footprint
From: Frank Seidel <frank@f-seidel.de>

Before> 1124 bytes on i386, now 876.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/net/wireless/airo.c~airo-reduce-stack-memory-footprint drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~airo-reduce-stack-memory-footprint
+++ a/drivers/net/wireless/airo.c
@@ -7147,11 +7147,15 @@ static int airo_get_aplist(struct net_de
 {
 	struct airo_info *local = dev->ml_priv;
 	struct sockaddr *address = (struct sockaddr *) extra;
-	struct iw_quality qual[IW_MAX_AP];
+	struct iw_quality *qual;
 	BSSListRid BSSList;
 	int i;
 	int loseSync = capable(CAP_NET_ADMIN) ? 1: -1;
 
+	qual = kmalloc(IW_MAX_AP * sizeof(*qual), GFP_KERNEL);
+	if (!qual)
+		return -ENOMEM;
+
 	for (i = 0; i < IW_MAX_AP; i++) {
 		u16 dBm;
 		if (readBSSListRid(local, loseSync, &BSSList))
@@ -7206,6 +7210,7 @@ static int airo_get_aplist(struct net_de
 	}
 	dwrq->length = i;
 
+	kfree(qual);
 	return 0;
 }
 
_

Patches currently in -mm which might be from frank@f-seidel.de are

linux-next.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
misdn-l1oip-reduce-stack-memory-footprint-cleanup.patch

