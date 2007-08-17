From: akpm@linux-foundation.org
Subject: + rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch added to -mm tree
Date: Fri, 17 Aug 2007 12:42:13 -0700
Message-ID: <200708171942.l7HJgDbd026277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbXHQTnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 15:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru


The patch titled
     rt ptracer can monopolize CPU (was: Cpu-Hotplug and Real-Time)
has been added to the -mm tree.  Its filename is
     rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rt ptracer can monopolize CPU (was: Cpu-Hotplug and Real-Time)
From: Gautham R Shenoy <ego@in.ibm.com>

yield() in wait_task_inactive(), can cause a high priority thread to be
scheduled back in, and there by loop forever while it is waiting for some
lower priority thread which is unfortunately still on the runqueue.

Use schedule_timeout_uninterruptible(1) instead.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Credit: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time kernel/sched.c
--- a/kernel/sched.c~rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time
+++ a/kernel/sched.c
@@ -1109,7 +1109,7 @@ repeat:
 	 * yield - it could be a while.
 	 */
 	if (unlikely(on_rq)) {
-		yield();
+		schedule_timeout_uninterruptible(1);
 		goto repeat;
 	}
 
_

Patches currently in -mm which might be from ego@in.ibm.com are

rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
