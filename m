From: akpm@linux-foundation.org
Subject: + gigaset-fix-module-reference-counting.patch added to -mm tree
Date: Fri, 06 Jun 2008 22:59:14 -0700
Message-ID: <200806070559.m575xEnM006183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549AbYFGF72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 7 Jun 2008 01:59:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aherrman@arcor.de, hjlipp@web.de, kkeil@suse.de, tilman@imap.cc


The patch titled
     gigaset: fix module reference counting
has been added to the -mm tree.  Its filename is
     gigaset-fix-module-reference-counting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gigaset: fix module reference counting
From: Andreas Herrmann <aherrman@arcor.de>

bas_gigaset can't be unloaded due to wrong module reference counting.
Ensure that module_put is called whenever a channel is freed.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: Tilmann Schmidt <tilman@imap.cc>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/common.c  |    5 +----
 drivers/isdn/gigaset/gigaset.h |    1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/isdn/gigaset/common.c~gigaset-fix-module-reference-counting drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~gigaset-fix-module-reference-counting
+++ a/drivers/isdn/gigaset/common.c
@@ -184,7 +184,6 @@ int gigaset_get_channel(struct bc_state 
 		return 0;
 	}
 	++bcs->use_count;
-	bcs->busy = 1;
 	gig_dbg(DEBUG_ANY, "allocated channel %d", bcs->channel);
 	spin_unlock_irqrestore(&bcs->cs->lock, flags);
 	return 1;
@@ -195,13 +194,12 @@ void gigaset_free_channel(struct bc_stat
 	unsigned long flags;
 
 	spin_lock_irqsave(&bcs->cs->lock, flags);
-	if (!bcs->busy) {
+	if (!bcs->use_count) {
 		gig_dbg(DEBUG_ANY, "could not free channel %d", bcs->channel);
 		spin_unlock_irqrestore(&bcs->cs->lock, flags);
 		return;
 	}
 	--bcs->use_count;
-	bcs->busy = 0;
 	module_put(bcs->cs->driver->owner);
 	gig_dbg(DEBUG_ANY, "freed channel %d", bcs->channel);
 	spin_unlock_irqrestore(&bcs->cs->lock, flags);
@@ -589,7 +587,6 @@ static struct bc_state *gigaset_initbcs(
 
 	bcs->chstate = 0;
 	bcs->use_count = 1;
-	bcs->busy = 0;
 	bcs->ignore = cs->ignoreframes;
 
 	for (i = 0; i < AT_NUM; ++i)
diff -puN drivers/isdn/gigaset/gigaset.h~gigaset-fix-module-reference-counting drivers/isdn/gigaset/gigaset.h
--- a/drivers/isdn/gigaset/gigaset.h~gigaset-fix-module-reference-counting
+++ a/drivers/isdn/gigaset/gigaset.h
@@ -419,7 +419,6 @@ struct bc_state {
 #ifdef CONFIG_GIGASET_DEBUG
 	int emptycount;
 #endif
-	int busy;
 	int use_count;
 
 	/* private data of hardware drivers */
_

Patches currently in -mm which might be from aherrman@arcor.de are

gigaset-fix-module-reference-counting.patch

