From: akpm@linux-foundation.org
Subject: + cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:40:53 -0800
Message-ID: <200711262340.lAQNeroL029104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbXKZXlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:41:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, andreas.herrmann3@amd.com, davej@redhat.com, mark.langsdorf@amd.com, yinghai.lu@Sun.COM


The patch titled
     CPUFREQ: powernow-k8 print pstate instead of fid/did for family 10h
has been added to the -mm tree.  Its filename is
     cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
kernel-printkc-concerns-about-the-console-handover.patch
