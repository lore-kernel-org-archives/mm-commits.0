From: akpm@linux-foundation.org
Subject: + 82596-free-nonexistent-resource-fix.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:39:27 -0800
Message-ID: <200711060039.lA60dRYA027886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbXKFAkC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:40:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     82596: free nonexistent resource fix
has been added to the -mm tree.  Its filename is
     82596-free-nonexistent-resource-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
82596-free-nonexistent-resource-fix.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
