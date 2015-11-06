From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:24 -0800
Message-ID: <563d0840.bTsIh70uF/E8OnxS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032971AbbKFUGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: remove {get|put}_online_cpus() from watchdog_{park|unpark}_threads()
has been removed from the -mm tree.  Its filename was
     watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kernel/watchdog.c: remove {get|put}_online_cpus() from watchdog_{park|unpark}_threads()

watchdog_{park|unpark}_threads() are now called in code paths that protect
themselves against CPU hotplug, so {get|put}_online_cpus() calls are
redundant and can be removed.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/watchdog.c~watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-remove-getput_online_cpus-from-watchdog_parkunpark_threads
+++ a/kernel/watchdog.c
@@ -683,33 +683,35 @@ static struct smp_hotplug_thread watchdo
  * be parked and the watchdog threads of other CPUs can still be runnable.
  * Callers are expected to handle this special condition as appropriate in
  * their context.
+ *
+ * This function may only be called in a context that is protected against
+ * races with CPU hotplug - for example, via get_online_cpus().
  */
 static int watchdog_park_threads(void)
 {
 	int cpu, ret = 0;
 
-	get_online_cpus();
 	for_each_watchdog_cpu(cpu) {
 		ret = kthread_park(per_cpu(softlockup_watchdog, cpu));
 		if (ret)
 			break;
 	}
-	put_online_cpus();
 
 	return ret;
 }
 
 /*
  * unpark all watchdog threads that are specified in 'watchdog_cpumask'
+ *
+ * This function may only be called in a context that is protected against
+ * races with CPU hotplug - for example, via get_online_cpus().
  */
 static void watchdog_unpark_threads(void)
 {
 	int cpu;
 
-	get_online_cpus();
 	for_each_watchdog_cpu(cpu)
 		kthread_unpark(per_cpu(softlockup_watchdog, cpu));
-	put_online_cpus();
 }
 
 /*
_

Patches currently in -mm which might be from uobergfe@redhat.com are


