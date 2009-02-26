From: akpm@linux-foundation.org
Subject: + airo-reduce-stack-memory-footprint.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:13:12 -0800
Message-ID: <200902262213.n1QMDC7Y027721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbZBZWOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frank@f-seidel.de, dcbw@redhat.com, linville@tuxdriver.com


The patch titled
     airo: reduce stack memory footprint
has been added to the -mm tree.  Its filename is
     airo-reduce-stack-memory-footprint.patch

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
airo-reduce-stack-memory-footprint.patch

