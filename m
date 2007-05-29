From: akpm@linux-foundation.org
Subject: - freezer-take-kernel_execve-into-consideration.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:12 -0700
Message-ID: <200705291850.l4TIoBkn008243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbXE2Su6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ebiederm@xmission.com, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer: take kernel_execve into consideration
has been removed from the -mm tree.  Its filename was
     freezer-take-kernel_execve-into-consideration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -120,7 +120,7 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			freeze_process(p);
@@ -147,7 +147,7 @@ static unsigned int try_to_freeze_tasks(
 				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (is_user_space(p) == !freeze_user_space)
+			if (freeze_user_space && !is_user_space(p))
 				continue;
 
 			task_lock(p);
_

Patches currently in -mm which might be from rjw@sisk.pl are

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
