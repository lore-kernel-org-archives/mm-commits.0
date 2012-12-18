From: akpm@linux-foundation.org
Subject: [merged] aoe-err-device-include-mac-addresses-for-unexpected-responses.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:16 -0800
Message-ID: <20121218201017.1771F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:64577 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:19 -0500
Received: by mail-lb0-f201.google.com with SMTP id m4so69928lbo.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: err device: include MAC addresses for unexpected responses
has been removed from the -mm tree.  Its filename was
     aoe-err-device-include-mac-addresses-for-unexpected-responses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: err device: include MAC addresses for unexpected responses

The /dev/etherd/err character device provides low-level information about
normal but sometimes interesting AoE command retransmits and "unexpected
responses", i.e., responses for packets that have already been
retransmitted.

This change adds MAC addresses to the messages about unexpected responses,
so that when they occur, it's more easy to determine the network paths to
which they belong.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-err-device-include-mac-addresses-for-unexpected-responses drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-err-device-include-mac-addresses-for-unexpected-responses
+++ a/drivers/block/aoe/aoecmd.c
@@ -1204,12 +1204,14 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			spin_unlock_irqrestore(&d->lock, flags);
 			aoedev_put(d);
 			snprintf(ebuf, sizeof(ebuf),
-				 "%15s e%d.%d    tag=%08x@%08lx\n",
+				 "%15s e%d.%d    tag=%08x@%08lx s=%pm d=%pm\n",
 				 "unexpected rsp",
 				 get_unaligned_be16(&h->major),
 				 h->minor,
 				 get_unaligned_be32(&h->tag),
-				 jiffies);
+				 jiffies,
+				 h->src,
+				 h->dst);
 			aoechr_error(ebuf);
 			return skb;
 		}
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

