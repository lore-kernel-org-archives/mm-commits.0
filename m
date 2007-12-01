From: akpm@linux-foundation.org
Subject: - mm-prevent-dereferencing-non-allocated-per_cpu-variables.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:28 -0800
Message-ID: <200712010024.lB10OSXJ032075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757841AbXLAA2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, ak@suse.de, clameter@sgi.com, mingo@elte.hu, pageexec@freemail.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     prevent dereferencing non-allocated per_cpu variables
has been removed from the -mm tree.  Its filename was
     mm-prevent-dereferencing-non-allocated-per_cpu-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: prevent dereferencing non-allocated per_cpu variables
From: Mike Travis <travis@sgi.com>

Change loops controlled by 'for (i = 0; i < NR_CPUS; i++)' to use
'for_each_possible_cpu(i)' when there's a _remote possibility_ of
dereferencing a non-allocated per_cpu variable involved.

All files except mm/vmstat.c are x86 arch.

Thanks to pageexec@freemail.hu for pointing this out.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: <pageexec@freemail.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smp_32.c     |    4 ++--
 arch/x86/kernel/smpboot_32.c |    4 ++--
 arch/x86/xen/smp.c           |    4 ++--
 vmstat.c                     |    0 
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/smp_32.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables arch/x86/kernel/smp_32.c
--- a/arch/x86/kernel/smp_32.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables
+++ a/arch/x86/kernel/smp_32.c
@@ -223,7 +223,7 @@ void send_IPI_mask_sequence(cpumask_t ma
 	 */ 
 
 	local_irq_save(flags);
-	for (query_cpu = 0; query_cpu < NR_CPUS; ++query_cpu) {
+	for_each_possible_cpu(query_cpu) {
 		if (cpu_isset(query_cpu, mask)) {
 			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
 					      vector);
@@ -675,7 +675,7 @@ static int convert_apicid_to_cpu(int api
 {
 	int i;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (per_cpu(x86_cpu_to_apicid, i) == apic_id)
 			return i;
 	}
diff -puN arch/x86/kernel/smpboot_32.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables arch/x86/kernel/smpboot_32.c
--- a/arch/x86/kernel/smpboot_32.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables
+++ a/arch/x86/kernel/smpboot_32.c
@@ -1090,7 +1090,7 @@ static void __init smp_boot_cpus(unsigne
 	 * Allow the user to impress friends.
 	 */
 	Dprintk("Before bogomips.\n");
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for_each_possible_cpu(cpu)
 		if (cpu_isset(cpu, cpu_callout_map))
 			bogosum += cpu_data(cpu).loops_per_jiffy;
 	printk(KERN_INFO
@@ -1121,7 +1121,7 @@ static void __init smp_boot_cpus(unsigne
 	 * construct cpu_sibling_map, so that we can tell sibling CPUs
 	 * efficiently.
 	 */
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		cpus_clear(per_cpu(cpu_sibling_map, cpu));
 		cpus_clear(per_cpu(cpu_core_map, cpu));
 	}
diff -puN arch/x86/xen/smp.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables
+++ a/arch/x86/xen/smp.c
@@ -146,7 +146,7 @@ void __init xen_smp_prepare_boot_cpu(voi
 	   old memory can be recycled */
 	make_lowmem_page_readwrite(&per_cpu__gdt_page);
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		cpus_clear(per_cpu(cpu_sibling_map, cpu));
 		/*
 		 * cpu_core_map lives in a per cpu area that is cleared
@@ -163,7 +163,7 @@ void __init xen_smp_prepare_cpus(unsigne
 {
 	unsigned cpu;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+	for_each_possible_cpu(cpu) {
 		cpus_clear(per_cpu(cpu_sibling_map, cpu));
 		/*
 		 * cpu_core_ map will be zeroed when the per
diff -puN mm/vmstat.c~mm-prevent-dereferencing-non-allocated-per_cpu-variables mm/vmstat.c
_

Patches currently in -mm which might be from travis@sgi.com are

git-x86.patch
vmstat-remove-prefetch.patch
