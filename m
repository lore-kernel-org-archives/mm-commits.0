From: akpm@linux-foundation.org
Subject: + memstick-move-dev_dbg.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:01:04 -0700
Message-ID: <200908242101.n7OL14n6019303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbZHXVBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:01:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, oakad@yahoo.com


The patch titled
     memstick: move dev_dbg
has been added to the -mm tree.  Its filename is
     memstick-move-dev_dbg.patch

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

md-dm-log-fix-cn_ulog_callback-declaration.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
usb-make-usb_buffer_map_sg-consistent-with-doc.patch
char-riscom8-fix-shutdown-declaration.patch
kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
kcore-use-registerd-physmem-information-fix2.patch
video-console-use-div_round_up.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
memstick-move-dev_dbg.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

