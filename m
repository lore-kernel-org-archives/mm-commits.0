From: akpm@linux-foundation.org
Subject: - drivers-isdn-misdn-teic-use-rwlock-runtime-init.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:17 -0800
Message-ID: <200812152002.mBFK2Hnv030828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbYLOUCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, kkeil@suse.de, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/mISDN/tei.c: use rwlock runtime init 
has been removed from the -mm tree.  Its filename was
     drivers-isdn-misdn-teic-use-rwlock-runtime-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
dvb-remove-deprecated-use-of-rw_lock_unlocked-in-frontends.patch
net-ipv4-netfilter-nf_nat_rulec-update-rwlock-initialization-for-nat_table.patch
checkpatch-struct-file_operations-should-normally-be-const.patch

