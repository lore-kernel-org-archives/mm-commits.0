From: akpm@linux-foundation.org
Subject: - 82596-free-nonexistent-resource-fix.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:53:41 -0800
Message-ID: <200711060553.lA65rf5x007527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbXKFFzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:55:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     82596: free nonexistent resource fix
has been removed from the -mm tree.  Its filename was
     82596-free-nonexistent-resource-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 82596: free nonexistent resource fix
From: Evgeniy Dushistov <dushistov@mail.ru>

During booting of last vanilla kernel I got:
Trying to free nonexistent resource...

This because of if "ENABLE_APRICOT" is on we do:
request_region(ioaddr,...)
if (checksum test failed)
  goto out1;
dev->base_addr = ioaddr;//<-here mistake

out1:
release_region(dev->base_addr,...)

Here patch which fixes this bug for me.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/82596.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/82596.c~82596-free-nonexistent-resource-fix drivers/net/82596.c
--- a/drivers/net/82596.c~82596-free-nonexistent-resource-fix
+++ a/drivers/net/82596.c
@@ -1192,6 +1192,8 @@ struct net_device * __init i82596_probe(
 			goto out;
 		}
 
+		dev->base_addr = ioaddr;
+
 		for (i = 0; i < 8; i++) {
 			eth_addr[i] = inb(ioaddr + 8 + i);
 			checksum += eth_addr[i];
@@ -1209,7 +1211,6 @@ struct net_device * __init i82596_probe(
 			goto out1;
 		}
 
-		dev->base_addr = ioaddr;
 		dev->irq = 10;
 	}
 #endif
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
git-netdev-all.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
