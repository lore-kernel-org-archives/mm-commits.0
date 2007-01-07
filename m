From: akpm@osdl.org
Subject: + sched-tasks-cannot-run-on-cpus-onlined-after-boot.patch added to -mm tree
Date: Sun, 07 Jan 2007 01:04:23 -0800
Message-ID: <200701070904.l0794Nr5014204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43490 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbXAGJFO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 04:05:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ntl@pobox.com, mingo@elte.hu, nickpiggin@yahoo.com.au, stable@kernel.org


The patch titled
     sched: tasks cannot run on cpus onlined after boot
has been added to the -mm tree.  Its filename is
     sched-tasks-cannot-run-on-cpus-onlined-after-boot.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: tasks cannot run on cpus onlined after boot
From: Nathan Lynch <ntl@pobox.com>

Commit 5c1e176781f43bc902a51e5832f789756bff911b ("sched: force /sbin/init
off isolated cpus") sets init's cpus_allowed to a subset of cpu_online_map
at boot time, which means that tasks won't be scheduled on cpus that are
added to the system later.

Make init's cpus_allowed a subset of cpu_possible_map instead.  This should
still preserve the behavior that Nick's change intended.

Thanks to Giuliano Pochini for reporting this and testing the fix:

http://ozlabs.org/pipermail/linuxppc-dev/2006-December/029397.html

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-tasks-cannot-run-on-cpus-onlined-after-boot kernel/sched.c
--- a/kernel/sched.c~sched-tasks-cannot-run-on-cpus-onlined-after-boot
+++ a/kernel/sched.c
@@ -6865,7 +6865,7 @@ void __init sched_init_smp(void)
 
 	lock_cpu_hotplug();
 	arch_init_sched_domains(&cpu_online_map);
-	cpus_andnot(non_isolated_cpus, cpu_online_map, cpu_isolated_map);
+	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
 	unlock_cpu_hotplug();
_

Patches currently in -mm which might be from ntl@pobox.com are

sched-tasks-cannot-run-on-cpus-onlined-after-boot.patch
