From: akpm@linux-foundation.org
Subject: - fix-wrong-proc-cpuinfo-on-x64.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:44 -0800
Message-ID: <200711192316.lAJNGi8G001793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbXKSX1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nanhai.zou@intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix wrong /proc/cpuinfo
has been removed from the -mm tree.  Its filename was
     fix-wrong-proc-cpuinfo-on-x64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: fix wrong /proc/cpuinfo
From: Zou Nan hai <nanhai.zou@intel.com>

in 2.6.24-rc1 kernel,
The /proc/cpuinfo display is wrong.

Another issue is that it will display bogus cpus with wrong information
if the kernel is compiled with a big CONFIG_NR_CPU.

That is because before a cpu in cpu_present_map is up, c->cpu_index of
that cpu is 0.
thus the cpu_online(c->cpu_index) check in show_cpuinfo is invalid.

This patch will let cpuinfo_op use cpu_online_map instead of
cpu_present_map to iterate cpus.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_64.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/setup_64.c~fix-wrong-proc-cpuinfo-on-x64 arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~fix-wrong-proc-cpuinfo-on-x64
+++ a/arch/x86/kernel/setup_64.c
@@ -1131,8 +1131,6 @@ static int show_cpuinfo(struct seq_file 
 
 
 #ifdef CONFIG_SMP
-	if (!cpu_online(c->cpu_index))
-		return 0;
 	cpu = c->cpu_index;
 #endif
 
@@ -1224,15 +1222,15 @@ static int show_cpuinfo(struct seq_file 
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
 
_

Patches currently in -mm which might be from nanhai.zou@intel.com are

origin.patch
