From: akpm@linux-foundation.org
Subject: + netconsole-make-netconsole_target-enabled-a-bool.patch added to -mm tree
Date: Thu, 14 May 2015 13:28:56 -0700
Message-ID: <55550588.dVRb5ZdxqS7op1Ww%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbbENU25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, kay@vrfy.org, penguin-kernel@I-love.SAKURA.ne.jp, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: netconsole: make netconsole_target->enabled a bool
has been added to the -mm tree.  Its filename is
     netconsole-make-netconsole_target-enabled-a-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/netconsole-make-netconsole_target-enabled-a-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/netconsole-make-netconsole_target-enabled-a-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: netconsole: make netconsole_target->enabled a bool

netconsole uses both bool and int for boolean values.  Let's convert
nt->enabled to bool for consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/net/netconsole.c~netconsole-make-netconsole_target-enabled-a-bool drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-make-netconsole_target-enabled-a-bool
+++ a/drivers/net/netconsole.c
@@ -104,7 +104,7 @@ struct netconsole_target {
 #ifdef	CONFIG_NETCONSOLE_DYNAMIC
 	struct config_item	item;
 #endif
-	int			enabled;
+	bool			enabled;
 	struct mutex		mutex;
 	struct netpoll		np;
 };
@@ -197,7 +197,7 @@ static struct netconsole_target *alloc_p
 	if (err)
 		goto fail;
 
-	nt->enabled = 1;
+	nt->enabled = true;
 
 	return nt;
 
@@ -322,13 +322,13 @@ static ssize_t store_enabled(struct netc
 		return err;
 	if (enabled < 0 || enabled > 1)
 		return -EINVAL;
-	if (enabled == nt->enabled) {
+	if ((bool)enabled == nt->enabled) {
 		pr_info("network logging has already %s\n",
 			nt->enabled ? "started" : "stopped");
 		return -EINVAL;
 	}
 
-	if (enabled) {	/* 1 */
+	if (enabled) {	/* true */
 		/*
 		 * Skip netpoll_parse_options() -- all the attributes are
 		 * already configured via configfs. Just print them out.
@@ -340,13 +340,13 @@ static ssize_t store_enabled(struct netc
 			return err;
 
 		pr_info("netconsole: network logging started\n");
-	} else {	/* 0 */
+	} else {	/* false */
 		/* We need to disable the netconsole before cleaning it up
 		 * otherwise we might end up in write_msg() with
-		 * nt->np.dev == NULL and nt->enabled == 1
+		 * nt->np.dev == NULL and nt->enabled == true
 		 */
 		spin_lock_irqsave(&target_list_lock, flags);
-		nt->enabled = 0;
+		nt->enabled = false;
 		spin_unlock_irqrestore(&target_list_lock, flags);
 		netpoll_cleanup(&nt->np);
 	}
@@ -594,7 +594,7 @@ static struct config_item *make_netconso
 
 	/*
 	 * Allocate and initialize with defaults.
-	 * Target is disabled at creation (enabled == 0).
+	 * Target is disabled at creation (!enabled).
 	 */
 	nt = kzalloc(sizeof(*nt), GFP_KERNEL);
 	if (!nt)
@@ -695,7 +695,7 @@ restart:
 				spin_lock_irqsave(&target_list_lock, flags);
 				dev_put(nt->np.dev);
 				nt->np.dev = NULL;
-				nt->enabled = 0;
+				nt->enabled = false;
 				stopped = true;
 				netconsole_target_put(nt);
 				goto restart;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
gfp-add-__gfp_noaccount.patch
gfp-add-__gfp_noaccount-v2.patch
gfp-add-__gfp_noaccount-v2-fix.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
printk-factor-out-message-formatting-from-devkmsg_read.patch
printk-implement-support-for-extended-console-drivers.patch
netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
netconsole-make-netconsole_target-enabled-a-bool.patch
netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
netconsole-implement-extended-console-support.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

