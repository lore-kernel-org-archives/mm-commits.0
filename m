From: akpm@linux-foundation.org
Subject: - clockevent-simplify-list-operations.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:45 -0800
Message-ID: <200802082014.m18KEQuK010417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758626AbYBHVDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clockevent: simplify list operations
has been removed from the -mm tree.  Its filename was
     clockevent-simplify-list-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clockevent: simplify list operations
From: Li Zefan <lizf@cn.fujitsu.com>

list_for_each_safe() suffices here.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clockevents.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/time/clockevents.c~clockevent-simplify-list-operations kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~clockevent-simplify-list-operations
+++ a/kernel/time/clockevents.c
@@ -218,6 +218,8 @@ void clockevents_exchange_device(struct 
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
+	struct list_head *node, *tmp;
+
 	spin_lock(&clockevents_lock);
 	clockevents_do_notify(reason, arg);
 
@@ -227,13 +229,8 @@ void clockevents_notify(unsigned long re
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		while (!list_empty(&clockevents_released)) {
-			struct clock_event_device *dev;
-
-			dev = list_entry(clockevents_released.next,
-					 struct clock_event_device, list);
-			list_del(&dev->list);
-		}
+		list_for_each_safe(node, tmp, &clockevents_released)
+			list_del(node);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
