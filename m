From: akpm@linux-foundation.org
Subject: + clockevent-simplify-list-operations.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:50:00 -0800
Message-ID: <200711292350.lATNo0aD013577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757740AbXK2XvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:51:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clockevent: simplify list operations
has been added to the -mm tree.  Its filename is
     clockevent-simplify-list-operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -200,6 +200,8 @@ void clockevents_exchange_device(struct 
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
+	struct list_head *node, *tmp;
+
 	spin_lock(&clockevents_lock);
 	clockevents_do_notify(reason, arg);
 
@@ -209,13 +211,8 @@ void clockevents_notify(unsigned long re
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

arm-fix-memset-size-error.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
