From: akpm@linux-foundation.org
Subject: + cpumask-make-nr_cpumask_bits-unsigned.patch added to -mm tree
Date: Thu, 09 Mar 2017 14:57:38 -0800
Message-ID: <58c1dde2.rRpVnzaqePIEaXIv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752799AbdCIW5j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 17:57:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, heiko.carstens@de.ibm.com, rusty@rustcorp.com.au, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: make "nr_cpumask_bits" unsigned
has been added to the -mm tree.  Its filename is
     cpumask-make-nr_cpumask_bits-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-make-nr_cpumask_bits-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-make-nr_cpumask_bits-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: cpumask: make "nr_cpumask_bits" unsigned

Bit searching functions accept "unsigned long" indices but
"nr_cpumask_bits" is "int" which is signed, so inevitable sign extensions
occur on x86_64.  Those MOVSX are #1 MOVSX bloat by number of uses across
whole kernel.

Change "nr_cpumask_bits" to unsigned, this number can't be negative after
all.  It allows to do implicit zero-extension on x86_64 without MOVSX.

Change signed comparisons into unsigned comparisons where necessary.

Other uses looks fine because it is either argument passed to a function
or comparison is already unsigned.

Net win on allyesconfig type of kernel: ~2.8 KB (!)

	add/remove: 0/0 grow/shrink: 8/725 up/down: 93/-2926 (-2833)
	function                                     old     new   delta
	xen_exit_mmap                                691     735     +44
	qstat_read                                   426     440     +14
	__cpufreq_cooling_register                  1678    1687      +9
	trace_rb_cpu_prepare                         447     455      +8
	vermagic                                      54      60      +6
	nfp_driver_version                            54      60      +6
	rcu_torture_stats_print                     1147    1151      +4
	find_next_push_cpu                           267     269      +2
	xen_irq_resume                               961     960      -1
				...
	init_vp_index                                946     906     -40
	od_set_powersave_bias                        328     281     -47
	power_cpu_exit                               193     139     -54
	arch_show_interrupts                        3538    3484     -54
	select_idle_sibling                         1558    1471     -87
	Total: Before=158358910, After=158356077, chg -0.00%

Same arguments apply to "nr_cpu_ids" but I haven't yet found enough
courage to delve into this issue (and proper fix may require new type
"cpu_t" which is whole separate story).

Link: http://lkml.kernel.org/r/20170309205322.GA1728@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/perf_event_mipsxx.c |    2 +-
 arch/s390/kernel/perf_cpum_sf.c      |    2 +-
 include/linux/cpumask.h              |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/mips/kernel/perf_event_mipsxx.c~cpumask-make-nr_cpumask_bits-unsigned arch/mips/kernel/perf_event_mipsxx.c
--- a/arch/mips/kernel/perf_event_mipsxx.c~cpumask-make-nr_cpumask_bits-unsigned
+++ a/arch/mips/kernel/perf_event_mipsxx.c
@@ -618,7 +618,7 @@ static int mipspmu_event_init(struct per
 		return -ENOENT;
 	}
 
-	if (event->cpu >= nr_cpumask_bits ||
+	if ((unsigned int)event->cpu >= nr_cpumask_bits ||
 	    (event->cpu >= 0 && !cpu_online(event->cpu)))
 		return -ENODEV;
 
diff -puN arch/s390/kernel/perf_cpum_sf.c~cpumask-make-nr_cpumask_bits-unsigned arch/s390/kernel/perf_cpum_sf.c
--- a/arch/s390/kernel/perf_cpum_sf.c~cpumask-make-nr_cpumask_bits-unsigned
+++ a/arch/s390/kernel/perf_cpum_sf.c
@@ -823,7 +823,7 @@ static int cpumsf_pmu_event_init(struct
 	}
 
 	/* Check online status of the CPU to which the event is pinned */
-	if (event->cpu >= nr_cpumask_bits ||
+	if ((unsigned int)event->cpu >= nr_cpumask_bits ||
 	    (event->cpu >= 0 && !cpu_online(event->cpu)))
 		return -ENODEV;
 
diff -puN include/linux/cpumask.h~cpumask-make-nr_cpumask_bits-unsigned include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-make-nr_cpumask_bits-unsigned
+++ a/include/linux/cpumask.h
@@ -40,9 +40,9 @@ extern int nr_cpu_ids;
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
  * not all bits may be allocated. */
-#define nr_cpumask_bits	nr_cpu_ids
+#define nr_cpumask_bits	((unsigned int)nr_cpu_ids)
 #else
-#define nr_cpumask_bits	NR_CPUS
+#define nr_cpumask_bits	((unsigned int)NR_CPUS)
 #endif
 
 /*
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cpumask-make-nr_cpumask_bits-unsigned.patch

