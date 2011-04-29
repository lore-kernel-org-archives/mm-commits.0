From: akpm@linux-foundation.org
Subject: [merged] kernel-watchdogc-disable-nmi-perf-event-in-the-error-path-of-enabling-watchdog.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:47:03 -0700
Message-ID: <201104291941.p3TJfYkZ011459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760869Ab1D2Tou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kernel/watchdog.c: disable nmi perf event in the error path of enabling watchdog
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-disable-nmi-perf-event-in-the-error-path-of-enabling-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/watchdog.c: disable nmi perf event in the error path of enabling watchdog
From: Hillf Danton <dhillf@gmail.com>

In corner cases where softlockup watchdog is not setup successfully, the
relevant nmi perf event for hardlockup watchdog could be disabled, then
the status of the underlying hardware remains unchanged.

Also, if the kthread doesn't start then the hrtimer won't run and the
hardlockup detector will falsely fire.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-disable-nmi-perf-event-in-the-error-path-of-enabling-watchdog kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-disable-nmi-perf-event-in-the-error-path-of-enabling-watchdog
+++ a/kernel/watchdog.c
@@ -430,9 +430,12 @@ static int watchdog_enable(int cpu)
 		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
 		if (IS_ERR(p)) {
 			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
-			if (!err)
+			if (!err) {
 				/* if hardlockup hasn't already set this */
 				err = PTR_ERR(p);
+				/* and disable the perf event */
+				watchdog_nmi_disable(cpu);
+			}
 			goto out;
 		}
 		kthread_bind(p, cpu);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch

