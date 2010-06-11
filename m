From: akpm@linux-foundation.org
Subject: + mm-use-for_each_online_cpu-in-vmstat.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:42:01 -0700
Message-ID: <201006112042.o5BKg16k018489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760505Ab0FKUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: use for_each_online_cpu() in vmstat
has been added to the -mm tree.  Its filename is
     mm-use-for_each_online_cpu-in-vmstat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use for_each_online_cpu() in vmstat
From: Minchan Kim <minchan.kim@gmail.com>

The sum_vm_events passes cpumask for for_each_cpu().  But it's useless
since we have for_each_online_cpu.  Althougth it's tirival overhead, it's
not good about coding consistency.

Let's use for_each_online_cpu instead of for_each_cpu with cpumask
argument.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmstat.c~mm-use-for_each_online_cpu-in-vmstat mm/vmstat.c
--- a/mm/vmstat.c~mm-use-for_each_online_cpu-in-vmstat
+++ a/mm/vmstat.c
@@ -22,14 +22,14 @@
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
-static void sum_vm_events(unsigned long *ret, const struct cpumask *cpumask)
+static void sum_vm_events(unsigned long *ret)
 {
 	int cpu;
 	int i;
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu(cpu, cpumask) {
+	for_each_online_cpu(cpu) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
@@ -45,7 +45,7 @@ static void sum_vm_events(unsigned long 
 void all_vm_events(unsigned long *ret)
 {
 	get_online_cpus();
-	sum_vm_events(ret, cpu_online_mask);
+	sum_vm_events(ret);
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(all_vm_events);
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-vmap-area-cache.patch
mm-vmap-area-cache-fix.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
mm-use-for_each_online_cpu-in-vmstat.patch

