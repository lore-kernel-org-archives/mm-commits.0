From: akpm@linux-foundation.org
Subject: - uml-remove-a-useless-function.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:56 -0700
Message-ID: <200804282154.m3SLsuG8018052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935456AbYD1Vy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     uml: remove a useless function
has been removed from the -mm tree.  Its filename was
     uml-remove-a-useless-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove a useless function
From: WANG Cong <xiyou.wangcong@gmail.com>

arch/um/drivers/chan_kern.c::chan_out_fd() is not used by anyone.  Remove it.

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_kern.c |   13 -------------
 arch/um/include/chan_kern.h |    1 -
 2 files changed, 14 deletions(-)

diff -puN arch/um/drivers/chan_kern.c~uml-remove-a-useless-function arch/um/drivers/chan_kern.c
--- a/arch/um/drivers/chan_kern.c~uml-remove-a-useless-function
+++ a/arch/um/drivers/chan_kern.c
@@ -583,19 +583,6 @@ int parse_chan_pair(char *str, struct li
 	return 0;
 }
 
-int chan_out_fd(struct list_head *chans)
-{
-	struct list_head *ele;
-	struct chan *chan;
-
-	list_for_each(ele, chans) {
-		chan = list_entry(ele, struct chan, list);
-		if (chan->primary && chan->output)
-			return chan->fd;
-	}
-	return -1;
-}
