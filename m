From: akpm@linux-foundation.org
Subject: - cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:18 -0800
Message-ID: <200711272033.lARKXI3c028970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755901AbXK0UeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:34:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, andreas.herrmann3@amd.com, davej@redhat.com, mark.langsdorf@amd.com, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     CPUFREQ: powernow-k8 print pstate instead of fid/did for family 10h
has been removed from the -mm tree.  Its filename was
     cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CPUFREQ: powernow-k8 print pstate instead of fid/did for family 10h
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 8354 processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x0 did 0x0 (2200 MHz)
powernow-k8:    1 : fid 0x0 did 0x0 (2000 MHz)
powernow-k8:    2 : fid 0x0 did 0x0 (1700 MHz)
powernow-k8:    3 : fid 0x0 did 0x0 (1400 MHz)
powernow-k8:    4 : fid 0x0 did 0x0 (1100 MHz)

actually index for CPU_HW_PSTATE is pstate instead of fid/vid
So print it out as pstate.

powernow-k8: Found 1 Quad-Core AMD Opteron(tm) Processor 8354 processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (2200 MHz)
powernow-k8:    1 : pstate 1 (2000 MHz)
powernow-k8:    2 : pstate 2 (1700 MHz)
powernow-k8:    3 : pstate 3 (1400 MHz)
powernow-k8:    4 : pstate 4 (1100 MHz)

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -579,10 +579,9 @@ static void print_basics(struct powernow
 	for (j = 0; j < data->numps; j++) {
 		if (data->powernow_table[j].frequency != CPUFREQ_ENTRY_INVALID) {
 			if (cpu_family == CPU_HW_PSTATE) {
-				printk(KERN_INFO PFX "   %d : fid 0x%x did 0x%x (%d MHz)\n",
+				printk(KERN_INFO PFX "   %d : pstate %d (%d MHz)\n",
 					j,
-					(data->powernow_table[j].index & 0xff00) >> 8,
-					(data->powernow_table[j].index & 0xff0000) >> 16,
+					data->powernow_table[j].index,
 					data->powernow_table[j].frequency/1000);
 			} else {
 				printk(KERN_INFO PFX "   %d : fid 0x%x (%d MHz), vid 0x%x\n",
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch
kernel-printkc-concerns-about-the-console-handover.patch
