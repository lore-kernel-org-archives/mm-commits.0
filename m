From: akpm@linux-foundation.org
Subject: + drivers-isdn-misdn-teic-use-rwlock-runtime-init.patch added to -mm tree
Date: Thu, 11 Dec 2008 14:50:57 -0800
Message-ID: <200812112250.mBBMov40021061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396AbYLKWvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 17:51:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, kkeil@suse.de, srostedt@redhat.com


The patch titled
     drivers/isdn/mISDN/tei.c: use rwlock runtime init 
has been added to the -mm tree.  Its filename is
     drivers-isdn-misdn-teic-use-rwlock-runtime-init.patch

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
Subject: drivers/isdn/mISDN/tei.c: use rwlock runtime init 
From: Steven Rostedt <rostedt@goodmis.org>

__RW_LOCK_UNLOCKED(lock) is meant for compile time initializations. 
rwlock_init(&lock) is used for run time initialization.

This patch converts drivers/isdn/mISDN/tei.c to initialize the mrg->lock
rwlock.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/tei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/mISDN/tei.c~drivers-isdn-misdn-teic-use-rwlock-runtime-init drivers/isdn/mISDN/tei.c
--- a/drivers/isdn/mISDN/tei.c~drivers-isdn-misdn-teic-use-rwlock-runtime-init
+++ a/drivers/isdn/mISDN/tei.c
@@ -1287,7 +1287,7 @@ create_teimanager(struct mISDNdevice *de
 	if (!mgr)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&mgr->layer2);
-	mgr->lock = __RW_LOCK_UNLOCKED(mgr->lock);
+	rwlock_init(&mgr->lock);
 	skb_queue_head_init(&mgr->sendq);
 	mgr->nextid = 1;
 	mgr->lastid = MISDN_ID_NONE;
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch
drivers-isdn-misdn-teic-use-rwlock-runtime-init.patch
checkpatch-struct-file_operations-should-normally-be-const.patch

