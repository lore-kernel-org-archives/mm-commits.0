From: akpm@linux-foundation.org
Subject: [merged] memstick-move-dev_dbg.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:04 -0700
Message-ID: <200909241937.n8OJb4AP003797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbZIXThV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: move dev_dbg
has been removed from the -mm tree.  Its filename was
     memstick-move-dev_dbg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: move dev_dbg
From: Jiri Slaby <jirislaby@gmail.com>

id_reg.if_mode might be unitialized when (*mrq)->error is nonzero.  move
dev_dbg() inside the if so that we are sure we can use id_reg values.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/memstick.c~memstick-move-dev_dbg drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-move-dev_dbg
+++ a/drivers/memstick/core/memstick.c
@@ -339,9 +339,9 @@ static int h_memstick_read_dev_id(struct
 			card->id.type = id_reg.type;
 			card->id.category = id_reg.category;
 			card->id.class = id_reg.class;
+			dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
 		}
 		complete(&card->mrq_complete);
-		dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
 		return -EAGAIN;
 	}
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

