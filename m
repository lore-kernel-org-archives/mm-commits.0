From: akpm@linux-foundation.org
Subject: - drivers-isdn-gigaset-reduce-mutex-scope.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:10 -0800
Message-ID: <200702122244.l1CMiAbv013557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030256AbXBLWoN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/gigaset: reduce mutex scope
has been removed from the -mm tree.  Its filename was
     drivers-isdn-gigaset-reduce-mutex-scope.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/isdn/gigaset: reduce mutex scope
From: Tilman Schmidt <tilman@imap.cc>

Do not lock the cardstate structure mutex earlier than necessary.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/common.c    |    4 +---
 drivers/isdn/gigaset/interface.c |    3 +++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/gigaset/common.c~drivers-isdn-gigaset-reduce-mutex-scope drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~drivers-isdn-gigaset-reduce-mutex-scope
+++ a/drivers/isdn/gigaset/common.c
@@ -640,7 +640,6 @@ struct cardstate *gigaset_initcs(struct 
 		return NULL;
 	}
 	mutex_init(&cs->mutex);
-	mutex_lock(&cs->mutex);
 
 	gig_dbg(DEBUG_INIT, "allocating bcs[0..%d]", channels - 1);
 	cs->bcs = kmalloc(channels * sizeof(struct bc_state), GFP_KERNEL);
@@ -738,6 +737,7 @@ struct cardstate *gigaset_initcs(struct 
 
 	++cs->cs_init;
 
+	/* set up character device */
 	gigaset_if_init(cs);
 
 	/* set up device sysfs */
@@ -753,11 +753,9 @@ struct cardstate *gigaset_initcs(struct 
 	add_timer(&cs->timer);
 
 	gig_dbg(DEBUG_INIT, "cs initialized");
-	mutex_unlock(&cs->mutex);
 	return cs;
 
 error:
-	mutex_unlock(&cs->mutex);
 	gig_dbg(DEBUG_INIT, "failed");
 	gigaset_freecs(cs);
 	return NULL;
diff -puN drivers/isdn/gigaset/interface.c~drivers-isdn-gigaset-reduce-mutex-scope drivers/isdn/gigaset/interface.c
--- a/drivers/isdn/gigaset/interface.c~drivers-isdn-gigaset-reduce-mutex-scope
+++ a/drivers/isdn/gigaset/interface.c
@@ -615,6 +615,8 @@ void gigaset_if_init(struct cardstate *c
 		return;
 
 	tasklet_init(&cs->if_wake_tasklet, &if_wake, (unsigned long) cs);
+
+	mutex_lock(&cs->mutex);
 	cs->tty_dev = tty_register_device(drv->tty, cs->minor_index, NULL);
 
 	if (!IS_ERR(cs->tty_dev))
@@ -623,6 +625,7 @@ void gigaset_if_init(struct cardstate *c
 		warn("could not register device to the tty subsystem");
 		cs->tty_dev = NULL;
 	}
+	mutex_unlock(&cs->mutex);
 }
 
 void gigaset_if_free(struct cardstate *cs)
_

Patches currently in -mm which might be from tilman@imap.cc are

origin.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
