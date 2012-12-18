From: akpm@linux-foundation.org
Subject: [merged] aoe-identify-source-of-runt-aoe-packets.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:29 -0800
Message-ID: <20121218201129.9FD53100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:55083 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRULa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:30 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so126310yen.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: identify source of runt AoE packets
has been removed from the -mm tree.  Its filename was
     aoe-identify-source-of-runt-aoe-packets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: identify source of runt AoE packets

This change only affects experimental AoE storage networks.

It modifies the console message about runt packets detected so that the
AoE major and minor addresses of the AoE target that generated the runt
are mentioned.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-identify-source-of-runt-aoe-packets drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-identify-source-of-runt-aoe-packets
+++ a/drivers/block/aoe/aoecmd.c
@@ -1217,8 +1217,10 @@ noskb:		if (buf)
 	case ATA_CMD_PIO_READ:
 	case ATA_CMD_PIO_READ_EXT:
 		if (skb->len < n) {
-			pr_err("aoe: runt data size in read.  skb->len=%d need=%ld\n",
-				skb->len, n);
+			pr_err("%s e%ld.%d.  skb->len=%d need=%ld\n",
+				"aoe: runt data size in read from",
+				(long) d->aoemajor, d->aoeminor,
+			       skb->len, n);
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
@@ -1233,7 +1235,9 @@ noskb:		if (buf)
 		break;
 	case ATA_CMD_ID_ATA:
 		if (skb->len < 512) {
-			pr_info("aoe: runt data size in ataid.  skb->len=%d\n",
+			pr_info("%s e%ld.%d.  skb->len=%d need=512\n",
+				"aoe: runt data size in ataid from",
+				(long) d->aoemajor, d->aoeminor,
 				skb->len);
 			break;
 		}
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

