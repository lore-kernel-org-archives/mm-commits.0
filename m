From: akpm@linux-foundation.org
Subject: + freezer-remove-redundant-check-in-try_to_freeze_tasks.patch added to -mm tree
Date: Tue, 29 May 2007 15:55:41 -0700
Message-ID: <200705292255.l4TMtgWJ013750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXE2W4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz


The patch titled
     Freezer: remove redundant check in try_to_freeze_tasks
has been added to the -mm tree.  Its filename is
     freezer-remove-redundant-check-in-try_to_freeze_tasks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Freezer: remove redundant check in try_to_freeze_tasks
From: Rafael J. Wysocki <rjw@sisk.pl>

We don't need to check if todo is positive before calling time_after() in
try_to_freeze_tasks(), because if todo is zero at this point, the loop will be
broken anyway due to the while () condition being false.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/process.c~freezer-remove-redundant-check-in-try_to_freeze_tasks kernel/power/process.c
--- a/kernel/power/process.c~freezer-remove-redundant-check-in-try_to_freeze_tasks
+++ a/kernel/power/process.c
@@ -149,7 +149,7 @@ static int try_to_freeze_tasks(int freez
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */
-		if (todo && time_after(jiffies, end_time))
+		if (time_after(jiffies, end_time))
 			break;
 	} while (todo);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
x86_64-pm_trace-support.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
