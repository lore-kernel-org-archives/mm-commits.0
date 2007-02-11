From: akpm@linux-foundation.org
Subject: - change-constant-zero-to-notify_done-in-ratelimit_handler.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:22 -0800
Message-ID: <200702112255.l1BMtMEg016314@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbXBKXAM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 18:00:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Change constant zero to NOTIFY_DONE in ratelimit_handler()
has been removed from the -mm tree.  Its filename was
     change-constant-zero-to-notify_done-in-ratelimit_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Change constant zero to NOTIFY_DONE in ratelimit_handler()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Change a hard-coded constant 0 to the symbolic equivalent NOTIFY_DONE in
the ratelimit_handler() CPU notifier handler function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~change-constant-zero-to-notify_done-in-ratelimit_handler mm/page-writeback.c
--- a/mm/page-writeback.c~change-constant-zero-to-notify_done-in-ratelimit_handler
+++ a/mm/page-writeback.c
@@ -515,7 +515,7 @@ static int __cpuinit
 ratelimit_handler(struct notifier_block *self, unsigned long u, void *v)
 {
 	writeback_set_ratelimit();
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block __cpuinitdata ratelimit_nb = {
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
add-an-rcu-version-of-list-splicing.patch
git-block.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
