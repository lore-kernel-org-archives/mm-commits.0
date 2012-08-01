From: akpm@linux-foundation.org
Subject: [merged] mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:37 -0700
Message-ID: <20120801201338.231AA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:41207 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab2HAUNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:40 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so343815lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fix potential killing of thread that is disabled from oom killing
has been removed from the -mm tree.  Its filename was
     mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: fix potential killing of thread that is disabled from oom killing

/proc/sys/vm/oom_kill_allocating_task will immediately kill current when
the oom killer is called to avoid a potentially expensive tasklist scan
for large systems.

Currently, however, it is not checking current's oom_score_adj value which
may be OOM_SCORE_ADJ_MIN, meaning that it has been disabled from oom
killing.

This patch avoids killing current in such a condition and simply falls
back to the tasklist scan since memory still needs to be freed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fix-potential-killing-of-thread-that-is-disabled-from-oom-killing
+++ a/mm/oom_kill.c
@@ -719,9 +719,9 @@ void out_of_memory(struct zonelist *zone
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
 	read_lock(&tasklist_lock);
-	if (sysctl_oom_kill_allocating_task &&
+	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
-	    current->mm) {
+	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
 		oom_kill_process(current, gfp_mask, order, 0, totalpages, NULL,
 				 nodemask,
 				 "Out of memory (oom_kill_allocating_task)");
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
slab-do-not-call-compound_head-in-page_get_cache.patch

