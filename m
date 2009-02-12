From: akpm@linux-foundation.org
Subject: + aoe-ignore-vendor-extension-aoe-responses.patch added to -mm tree
Date: Wed, 11 Feb 2009 16:29:06 -0800
Message-ID: <200902120029.n1C0T6SP025325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755897AbZBLA3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:29:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, karaluh@karaluh.pl


The patch titled
     aoe: ignore vendor extension AoE responses
has been added to the -mm tree.  Its filename is
     aoe-ignore-vendor-extension-aoe-responses.patch

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
Subject: aoe: ignore vendor extension AoE responses
From: Ed Cashin <ecashin@coraid.com>

The Welland ME-747K-SI AoE target generates unsolicited AoE responses that
are marked as vendor extensions.  Instead of ignoring these packets, the
aoe driver was generating kernel messages for each unrecognized response
received.  This patch corrects the behavior.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Reported-by: <karaluh@karaluh.pl>
Tested-by: <karaluh@karaluh.pl>
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

aoe-ignore-vendor-extension-aoe-responses.patch

