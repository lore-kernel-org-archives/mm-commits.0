From: akpm@linux-foundation.org
Subject: - x86-show-cpuinfo-only-for-online-cpus.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:56 -0800
Message-ID: <200711192316.lAJNGuV7001812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbXKSX1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:27:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.herrmann3@amd.com, gcosta@redhat.com, mingo@elte.hu, tglx@linutronix.de, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86: show cpuinfo only for online CPUs
has been removed from the -mm tree.  Its filename was
     x86-show-cpuinfo-only-for-online-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: show cpuinfo only for online CPUs
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>

Fix regressions introduced with 92cb7612aee39642d109b8d935ad265e602c0563.

It can happen that cpuinfo is displayed for CPUs that are not online or
even worse for CPUs not present at all. As an example, following was
shown for a "second" CPU of a single core K8 variant:

    processor       : 0
    vendor_id       : unknown
    cpu family      : 0
    model           : 0
    model name      : unknown
    stepping        : 0
    cache size      : 0 KB
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 0
    wp              : yes
    flags           :
    bogomips        : 0.00
    clflush size    : 0
    cache_alignment : 0
    address sizes   : 0 bits physical, 0 bits virtual
    power management:

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/proc.c |    8 +++-----
 x86/kernel/setup_64.c      |    0 
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/cpu/proc.c~x86-show-cpuinfo-only-for-online-cpus arch/x86/kernel/cpu/proc.c
--- a/arch/x86/kernel/cpu/proc.c~x86-show-cpuinfo-only-for-online-cpus
+++ a/arch/x86/kernel/cpu/proc.c
@@ -90,8 +90,6 @@ static int show_cpuinfo(struct seq_file 
 
 #ifdef CONFIG_SMP
 	n = c->cpu_index;
-	if (!cpu_online(n))
-		return 0;
 #endif
 	seq_printf(m, "processor\t: %d\n"
 		"vendor_id\t: %s\n"
@@ -177,14 +175,14 @@ static int show_cpuinfo(struct seq_file 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_possible_map);
-	if ((*pos) < NR_CPUS && cpu_possible(*pos))
+		*pos = first_cpu(cpu_online_map);
+	if ((*pos) < NR_CPUS && cpu_online(*pos))
 		return &cpu_data(*pos);
 	return NULL;
 }
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_possible_map);
+	*pos = next_cpu(*pos, cpu_online_map);
 	return c_start(m, pos);
 }
 static void c_stop(struct seq_file *m, void *v)
diff -puN arch/x86/kernel/setup_64.c~x86-show-cpuinfo-only-for-online-cpus arch/x86/kernel/setup_64.c
_

Patches currently in -mm which might be from andreas.herrmann3@amd.com are

origin.patch
