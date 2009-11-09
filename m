From: akpm@linux-foundation.org
Subject: [merged] misdn-fix-reversed-if-in-st_own_ctrl.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:12 -0800
Message-ID: <200911091955.nA9JtCP6023330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbZKITzM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     mISDN: fix reversed if in st_own_ctrl()
has been removed from the -mm tree.  Its filename was
     misdn-fix-reversed-if-in-st_own_ctrl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

