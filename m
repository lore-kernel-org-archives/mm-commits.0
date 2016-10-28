From: akpm@linux-foundation.org
Subject: [merged]
 kernel-smp-make-the-smp-boot-message-common-on-all-arches.patch removed
 from -mm tree
Date: Fri, 28 Oct 2016 11:31:10 -0700
Message-ID: <5813996e.+M7yIpq/M0TtQQLF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034034AbcJ1SbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, ak@linux.intel.com, boris.ostrovsky@oracle.com, bp@suse.de, hpa@zytor.com, jgross@suse.com, jolsa@redhat.com, len.brown@intel.com, mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, richard@nod.at, tglx@linutronix.de, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/smp.c: make the SMP boot message common on all arches
has been removed from the -mm tree.  Its filename was
     kernel-smp-make-the-smp-boot-message-common-on-all-arches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: kernel/smp.c: make the SMP boot message common on all arches

Currently after bringing up secondary CPUs all arches print "Brought up %d
CPUs".  On x86 they also print the number of nodes that were brought
online.

It would be nice to also print the number of nodes on other arches. 
Although we could override smp_announce() on the other ~10 NUMA aware
arches, it seems simpler to just always print the number of nodes.  On
non-NUMA arches there is just always 1 node.

Having done that, smp_announce() is no longer weak, and seems small enough
to just pull directly into smp_init().

Also update the printing of "%d CPUs" to be smart when an SMP kernel is
booted on a single CPU system, or when only one CPU is available, eg:

   smp: Brought up 2 nodes, 1 CPU

Link: http://lkml.kernel.org/r/1477460275-8266-2-git-send-email-mpe@ellerman.id.au
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Len Brown <len.brown@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot.c |    8 --------
 kernel/smp.c              |   13 +++++++------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/smpboot.c~kernel-smp-make-the-smp-boot-message-common-on-all-arches arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~kernel-smp-make-the-smp-boot-message-common-on-all-arches
+++ a/arch/x86/kernel/smpboot.c
@@ -821,14 +821,6 @@ wakeup_secondary_cpu_via_init(int phys_a
 	return (send_status | accept_status);
 }
 
-void smp_announce(void)
-{
-	int num_nodes = num_online_nodes();
-
-	printk(KERN_INFO "x86: Booted up %d node%s, %d CPUs\n",
-	       num_nodes, (num_nodes > 1 ? "s" : ""), num_online_cpus());
-}
-
 /* reduce the number of lines printed when booting a large cpu count system */
 static void announce_cpu(int cpu, int apicid)
 {
diff -puN kernel/smp.c~kernel-smp-make-the-smp-boot-message-common-on-all-arches kernel/smp.c
--- a/kernel/smp.c~kernel-smp-make-the-smp-boot-message-common-on-all-arches
+++ a/kernel/smp.c
@@ -546,14 +546,10 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
-void __weak smp_announce(void)
-{
-	printk(KERN_INFO "Brought up %d CPUs\n", num_online_cpus());
-}
-
 /* Called by boot processor to activate the rest. */
 void __init smp_init(void)
 {
+	int num_nodes, num_cpus;
 	unsigned int cpu;
 
 	idle_threads_init();
@@ -567,8 +563,13 @@ void __init smp_init(void)
 			cpu_up(cpu);
 	}
 
+	num_nodes = num_online_nodes();
+	num_cpus  = num_online_cpus();
+	pr_info("Brought up %d node%s, %d CPU%s\n",
+		num_nodes, (num_nodes > 1 ? "s" : ""),
+		num_cpus,  (num_cpus  > 1 ? "s" : ""));
+
 	/* Any cleanup work */
-	smp_announce();
 	smp_cpus_done(setup_max_cpus);
 }
 
_

Patches currently in -mm which might be from mpe@ellerman.id.au are


