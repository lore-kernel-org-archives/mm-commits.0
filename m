From: akpm@linux-foundation.org
Subject: + cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:38:20 -0700
Message-ID: <200707310138.l6V1cKfv008792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbXGaBjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, ak@suse.de, benh@kernel.crashing.org, bryan.wu@analog.com, davej@redhat.com, davem@davemloft.net, lethal@linux-sh.org, paulus@samba.org, rmk@arm.linux.org.uk, tony.luck@intel.com, venkatesh.pallipadi@intel.com


The patch titled
     cpufreq: move policy's governor initialisation out of low-level drivers into cpufreq core
has been added to the -mm tree.  Its filename is
     cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpufreq: move policy's governor initialisation out of low-level drivers into cpufreq core
From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-imx/cpufreq.c                       |    1 -
 arch/arm/mach-sa1100/cpu-sa1110.c                 |    1 -
 arch/arm/plat-omap/cpu-omap.c                     |    1 -
 arch/blackfin/mach-bf533/cpu.c                    |    2 --
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c       |    1 -
 arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c    |    1 -
 arch/i386/kernel/cpu/cpufreq/e_powersaver.c       |    1 -
 arch/i386/kernel/cpu/cpufreq/elanfreq.c           |    1 -
 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c         |    1 -
 arch/i386/kernel/cpu/cpufreq/longhaul.c           |    1 -
 arch/i386/kernel/cpu/cpufreq/p4-clockmod.c        |    1 -
 arch/i386/kernel/cpu/cpufreq/powernow-k6.c        |    1 -
 arch/i386/kernel/cpu/cpufreq/powernow-k7.c        |    2 --
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c        |    1 -
 arch/i386/kernel/cpu/cpufreq/sc520_freq.c         |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-ich.c      |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-smi.c      |    1 -
 arch/ia64/kernel/cpufreq/acpi-cpufreq.c           |    2 --
 arch/powerpc/platforms/cell/cbe_cpufreq.c         |    2 --
 arch/powerpc/platforms/pasemi/cpufreq.c           |    2 --
 arch/powerpc/platforms/powermac/cpufreq_32.c      |    1 -
 arch/powerpc/platforms/powermac/cpufreq_64.c      |    1 -
 arch/sh/kernel/cpufreq.c                          |    1 -
 arch/sparc64/kernel/us2e_cpufreq.c                |    1 -
 drivers/cpufreq/cpufreq.c                         |    2 ++
 26 files changed, 2 insertions(+), 30 deletions(-)

diff -puN arch/arm/mach-imx/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/arm/mach-imx/cpufreq.c
--- a/arch/arm/mach-imx/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/arm/mach-imx/cpufreq.c
@@ -269,7 +269,6 @@ static int __init imx_cpufreq_driver_ini
 		return -EINVAL;
 
 	policy->cur = policy->min = policy->max = imx_get_speed(0);
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.min_freq = 8000;
 	policy->cpuinfo.max_freq = 200000;
 	 /* Manual states, that PLL stabilizes in two CLK32 periods */
diff -puN arch/arm/mach-sa1100/cpu-sa1110.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/arm/mach-sa1100/cpu-sa1110.c
--- a/arch/arm/mach-sa1100/cpu-sa1110.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/arm/mach-sa1100/cpu-sa1110.c
@@ -331,7 +331,6 @@ static int __init sa1110_cpu_init(struct
 	if (policy->cpu != 0)
 		return -EINVAL;
 	policy->cur = policy->min = policy->max = sa11x0_getspeed(0);
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.min_freq = 59000;
 	policy->cpuinfo.max_freq = 287000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
diff -puN arch/arm/plat-omap/cpu-omap.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/arm/plat-omap/cpu-omap.c
--- a/arch/arm/plat-omap/cpu-omap.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/arm/plat-omap/cpu-omap.c
@@ -108,7 +108,6 @@ static int __init omap_cpu_init(struct c
 	if (policy->cpu != 0)
 		return -EINVAL;
 	policy->cur = policy->min = policy->max = omap_getspeed(0);
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.min_freq = clk_round_rate(mpu_clk, 0) / 1000;
 	policy->cpuinfo.max_freq = clk_round_rate(mpu_clk, VERY_HI_RATE) / 1000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
diff -puN arch/blackfin/mach-bf533/cpu.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/blackfin/mach-bf533/cpu.c
--- a/arch/blackfin/mach-bf533/cpu.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/blackfin/mach-bf533/cpu.c
@@ -118,8 +118,6 @@ static int __init __bf533_cpu_init(struc
 	if (policy->cpu != 0)
 		return -EINVAL;
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	/*Now ,only support one cpu */
 	policy->cur = bf533_getfreq(0);
diff -puN arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -658,7 +658,6 @@ static int acpi_cpufreq_cpu_init(struct 
 			policy->cpuinfo.transition_latency =
 			    perf->states[i].transition_latency * 1000;
 	}
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 
 	data->max_freq = perf->states[0].core_frequency * 1000;
 	/* table init */
diff -puN arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c
--- a/arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -363,7 +363,6 @@ static int nforce2_cpu_init(struct cpufr
 	policy->cur = nforce2_get(policy->cpu);
 	policy->min = policy->cpuinfo.min_freq;
 	policy->max = policy->cpuinfo.max_freq;
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 
 	return 0;
 }
diff -puN arch/i386/kernel/cpu/cpufreq/e_powersaver.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/e_powersaver.c
--- a/arch/i386/kernel/cpu/cpufreq/e_powersaver.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/e_powersaver.c
@@ -253,7 +253,6 @@ static int eps_cpu_init(struct cpufreq_p
 		f_table[k].frequency = CPUFREQ_TABLE_END;
 	}
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 140000; /* 844mV -> 700mV in ns */
 	policy->cur = fsb * current_multiplier;
 
diff -puN arch/i386/kernel/cpu/cpufreq/elanfreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/elanfreq.c
--- a/arch/i386/kernel/cpu/cpufreq/elanfreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/elanfreq.c
@@ -219,7 +219,6 @@ static int elanfreq_cpu_init(struct cpuf
 	}
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = elanfreq_get_cpu_frequency(0);
 
diff -puN arch/i386/kernel/cpu/cpufreq/gx-suspmod.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
--- a/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
@@ -420,7 +420,6 @@ static int cpufreq_gx_cpu_init(struct cp
 		policy->min = maxfreq / POLICY_MIN_DIV;
 	policy->max = maxfreq;
 	policy->cur = curfreq;
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.min_freq = maxfreq / max_duration;
 	policy->cpuinfo.max_freq = maxfreq;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
diff -puN arch/i386/kernel/cpu/cpufreq/longhaul.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/longhaul.c
--- a/arch/i386/kernel/cpu/cpufreq/longhaul.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/longhaul.c
@@ -873,7 +873,6 @@ static int __init longhaul_cpu_init(stru
 	if ((longhaul_version != TYPE_LONGHAUL_V1) && (scale_voltage != 0))
 		longhaul_setup_voltagescaling();
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 200000;	/* nsec */
 	policy->cur = calc_speed(longhaul_get_cpu_mult());
 
diff -puN arch/i386/kernel/cpu/cpufreq/p4-clockmod.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
--- a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/p4-clockmod.c
@@ -229,7 +229,6 @@ static int cpufreq_p4_cpu_init(struct cp
 	cpufreq_frequency_table_get_attr(p4clockmod_table, policy->cpu);
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 1000000; /* assumed */
 	policy->cur = stock_freq;
 
diff -puN arch/i386/kernel/cpu/cpufreq/powernow-k6.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/powernow-k6.c
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k6.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/powernow-k6.c
@@ -160,7 +160,6 @@ static int powernow_k6_cpu_init(struct c
 	}
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = busfreq * max_multiplier;
 
diff -puN arch/i386/kernel/cpu/cpufreq/powernow-k7.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/powernow-k7.c
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k7.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/powernow-k7.c
@@ -637,8 +637,6 @@ static int __init powernow_cpu_init (str
 	printk (KERN_INFO PFX "Minimum speed %d MHz. Maximum speed %d MHz.\n",
 				minimum_speed/1000, maximum_speed/1000);
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-
 	policy->cpuinfo.transition_latency = cpufreq_scale(2000000UL, fsb, latency);
 
 	policy->cur = powernow_get(0);
diff -puN arch/i386/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -1208,7 +1208,6 @@ static int __cpuinit powernowk8_cpu_init
 	/* run on any CPU again */
 	set_cpus_allowed(current, oldmask);
 
-	pol->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cpus = cpumask_of_cpu(pol->cpu);
 	else
diff -puN arch/i386/kernel/cpu/cpufreq/sc520_freq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/sc520_freq.c
--- a/arch/i386/kernel/cpu/cpufreq/sc520_freq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/sc520_freq.c
@@ -111,7 +111,6 @@ static int sc520_freq_cpu_init(struct cp
 		return -ENODEV;
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
 	policy->cur = sc520_freq_get_cpu_frequency(0);
 
diff -puN arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -393,7 +393,6 @@ static int centrino_cpu_init(struct cpuf
 
 	freq = get_cur_freq(policy->cpu);
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 10000; /* 10uS transition latency */
 	policy->cur = freq;
 
diff -puN arch/i386/kernel/cpu/cpufreq/speedstep-ich.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c
@@ -348,7 +348,6 @@ static int speedstep_cpu_init(struct cpu
 		(speed / 1000));
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cur = speed;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, speedstep_freqs);
diff -puN arch/i386/kernel/cpu/cpufreq/speedstep-smi.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/i386/kernel/cpu/cpufreq/speedstep-smi.c
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c
@@ -290,7 +290,6 @@ static int speedstep_cpu_init(struct cpu
 		(speed / 1000));
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = speed;
 
diff -puN arch/ia64/kernel/cpufreq/acpi-cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/ia64/kernel/cpufreq/acpi-cpufreq.c
--- a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/ia64/kernel/cpufreq/acpi-cpufreq.c
@@ -323,8 +323,6 @@ acpi_cpufreq_cpu_init (
 			    data->acpi_data.states[i].transition_latency * 1000;
 		}
 	}
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-
 	policy->cur = processor_get_freq(data, policy->cpu);
 
 	/* table init */
diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -107,8 +107,6 @@ static int cbe_cpufreq_cpu_init(struct c
 		pr_debug("%d: %d\n", i, cbe_freqs[i].frequency);
 	}
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-
 	/* if DEBUG is enabled set_pmode() measures the latency
 	 * of a transition */
 	policy->cpuinfo.transition_latency = 25000;
diff -puN arch/powerpc/platforms/pasemi/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/powerpc/platforms/pasemi/cpufreq.c
--- a/arch/powerpc/platforms/pasemi/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/powerpc/platforms/pasemi/cpufreq.c
@@ -195,8 +195,6 @@ static int pas_cpufreq_cpu_init(struct c
 		pr_debug("%d: %d\n", i, pas_freqs[i].frequency);
 	}
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-
 	policy->cpuinfo.transition_latency = get_gizmo_latency();
 
 	cur_astate = get_cur_astate(policy->cpu);
diff -puN arch/powerpc/platforms/powermac/cpufreq_32.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/powerpc/platforms/powermac/cpufreq_32.c
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -410,7 +410,6 @@ static int pmac_cpufreq_cpu_init(struct 
 	if (policy->cpu != 0)
 		return -ENODEV;
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency	= CPUFREQ_ETERNAL;
 	policy->cur = cur_freq;
 
diff -puN arch/powerpc/platforms/powermac/cpufreq_64.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/powerpc/platforms/powermac/cpufreq_64.c
--- a/arch/powerpc/platforms/powermac/cpufreq_64.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/powerpc/platforms/powermac/cpufreq_64.c
@@ -357,7 +357,6 @@ static unsigned int g5_cpufreq_get_speed
 
 static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = g5_cpu_freqs[g5_query_freq()].frequency;
 	/* secondary CPUs are tied to the primary one by the
diff -puN arch/sh/kernel/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/sh/kernel/cpufreq.c
--- a/arch/sh/kernel/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/sh/kernel/cpufreq.c
@@ -93,7 +93,6 @@ static int sh_cpufreq_cpu_init(struct cp
 	policy->cpuinfo.max_freq = (clk_round_rate(cpuclk, ~0UL) + 500) / 1000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 
-	policy->governor	= CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cur		= sh_cpufreq_get(policy->cpu);
 	policy->min		= policy->cpuinfo.min_freq;
 	policy->max		= policy->cpuinfo.max_freq;
diff -puN arch/sparc64/kernel/us2e_cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core arch/sparc64/kernel/us2e_cpufreq.c
--- a/arch/sparc64/kernel/us2e_cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/arch/sparc64/kernel/us2e_cpufreq.c
@@ -326,7 +326,6 @@ static int __init us2e_freq_cpu_init(str
 	table[2].index = 5;
 	table[3].frequency = CPUFREQ_TABLE_END;
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
diff -puN drivers/cpufreq/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core
+++ a/drivers/cpufreq/cpufreq.c
@@ -763,6 +763,8 @@ static int cpufreq_add_dev (struct sys_d
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
+	/* Set governor before ->init, so that driver could check it */
+	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
