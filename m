From: akpm@linux-foundation.org
Subject: [merged] aoe-ignore-vendor-extension-aoe-responses.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:21 -0800
Message-ID: <200902191916.n1JJGLpA016244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbZBSTQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, alex.buell@munted.org.uk, karaluh@karaluh.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     aoe: ignore vendor extension AoE responses
has been removed from the -mm tree.  Its filename was
     aoe-ignore-vendor-extension-aoe-responses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: ignore vendor extension AoE responses
From: Ed Cashin <ecashin@coraid.com>

The Welland ME-747K-SI AoE target generates unsolicited AoE responses that
are marked as vendor extensions.  Instead of ignoring these packets, the
aoe driver was generating kernel messages for each unrecognized response
received.  This patch corrects the behavior.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Reported-by: <karaluh@karaluh.pl>
Tested-by: <karaluh@karaluh.pl>
Cc: <stable@kernel.org>
Cc: Alex Buell <alex.buell@munted.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    1 +
 drivers/block/aoe/aoenet.c |    2 ++
 2 files changed, 3 insertions(+)

diff -puN drivers/block/aoe/aoe.h~aoe-ignore-vendor-extension-aoe-responses drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-ignore-vendor-extension-aoe-responses
+++ a/drivers/block/aoe/aoe.h
@@ -18,6 +18,7 @@
 enum {
 	AOECMD_ATA,
 	AOECMD_CFG,
+	AOECMD_VEND_MIN = 0xf0,
 
 	AOEFL_RSP = (1<<3),
 	AOEFL_ERR = (1<<2),
diff -puN drivers/block/aoe/aoenet.c~aoe-ignore-vendor-extension-aoe-responses drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-ignore-vendor-extension-aoe-responses
+++ a/drivers/block/aoe/aoenet.c
@@ -142,6 +142,8 @@ aoenet_rcv(struct sk_buff *skb, struct n
 		aoecmd_cfg_rsp(skb);
 		break;
 	default:
+		if (h->cmd >= AOECMD_VEND_MIN)
+			break;	/* don't complain about vendor commands */
 		printk(KERN_INFO "aoe: unknown cmd %d\n", h->cmd);
 	}
 exit:
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

