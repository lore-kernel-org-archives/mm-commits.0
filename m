From: akpm@linux-foundation.org
Subject: + freezer-take-kernel_execve-into-consideration.patch added to -mm tree
Date: Fri, 11 May 2007 12:42:31 -0700
Message-ID: <200705111942.l4BJgVtl024846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763567AbXEKTmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ebiederm@xmission.com, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz


The patch titled
     freezer: take kernel_execve into consideration
has been added to the -mm tree.  Its filename is
     freezer-take-kernel_execve-into-consideration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: take kernel_execve into consideration
From: Rafael J. Wysocki <rjw@sisk.pl>

Kernel threads can become userland processes by calling kernel_execve().  In
particular, this may happen right after
try_to_freeze_tasks(FREEZER_USER_SPACE) has returned, so try_to_freeze_tasks()
needs to take userspace processes into consideration even if it is called with
FREEZER_KERNEL_THREADS.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/power/process.c~freezer-take-kernel_execve-into-consideration kernel/power/process.c
--- a/kernel/power/process.c~freezer-take-kernel_execve-into-consideration
+++ a/kernel/power/process.c
@@ -126,7 +126,7 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			freeze_process(p);
@@ -153,7 +153,7 @@ static unsigned int try_to_freeze_tasks(
 				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			task_lock(p);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
