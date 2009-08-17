From: akpm@linux-foundation.org
Subject: + misdn-fix-reversed-if-in-st_own_ctrl.patch added to -mm tree
Date: Mon, 17 Aug 2009 15:29:27 -0700
Message-ID: <200908172229.n7HMTRlh010299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbZHQW3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 18:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, isdn@linux-pingi.de


The patch titled
     mISDN: fix reversed if in st_own_ctrl()
has been added to the -mm tree.  Its filename is
     misdn-fix-reversed-if-in-st_own_ctrl.patch

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
Subject: mISDN: fix reversed if in st_own_ctrl()
From: Dan Carpenter <error27@gmail.com>

The current code probably returns -EINVAL a lot.  Otherwise it would oops.

Compile tested only.  Found by smatch (http://repo.or.cz/w/smatch.git).

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/stack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/mISDN/stack.c~misdn-fix-reversed-if-in-st_own_ctrl drivers/isdn/mISDN/stack.c
--- a/drivers/isdn/mISDN/stack.c~misdn-fix-reversed-if-in-st_own_ctrl
+++ a/drivers/isdn/mISDN/stack.c
@@ -364,7 +364,7 @@ add_layer2(struct mISDNchannel *ch, stru
 static int
 st_own_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
 {
-	if (!ch->st || ch->st->layer1)
+	if (!ch->st || !ch->st->layer1)
 		return -EINVAL;
 	return ch->st->layer1->ctrl(ch->st->layer1, cmd, arg);
 }
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
misdn-fix-reversed-if-in-st_own_ctrl.patch
drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch

