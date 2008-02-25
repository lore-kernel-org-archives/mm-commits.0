From: akpm@linux-foundation.org
Subject: + x86_64-fold-pda-into-per-cpu-area-v3-fix.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:59:56 -0800
Message-ID: <200802251900.m1PJ0mmB014543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756109AbYBYTDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 14:03:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, dada1@cosmosbay.com, jschopp@austin.ibm.com, mingo@elte.hu, rdunlap@xenotime.net, tglx@linutronix.de


The patch titled
     x86_64: x86_64_cleanup_pda() should use nr_cpu_ids instead of NR_CPUS
has been added to the -mm tree.  Its filename is
     x86_64-fold-pda-into-per-cpu-area-v3-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: x86_64_cleanup_pda() should use nr_cpu_ids instead of NR_CPUS
From: Mike Travis <travis@sgi.com>

We allocate an array of nr_cpu_ids pointers, so we should respect its bonds.

Delay change of _cpu_pda after array initialization.

Also take into account that alloc_bootmem_low() :
- calls panic() if not enough memory
- already clears allocated memory

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/head64.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/x86/kernel/head64.c~x86_64-fold-pda-into-per-cpu-area-v3-fix arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c~x86_64-fold-pda-into-per-cpu-area-v3-fix
+++ a/arch/x86/kernel/head64.c
@@ -167,18 +167,16 @@ void __init x86_64_start_kernel(char * r
 void __init x86_64_cleanup_pda(void)
 {
 	int i;
+	struct x8664_pda **new_cpu_pda;
 
-	_cpu_pda = alloc_bootmem_low(nr_cpu_ids * sizeof(void *));
+	new_cpu_pda = alloc_bootmem_low(nr_cpu_ids * sizeof(void *));
 
-	if (!_cpu_pda)
-		panic("Cannot allocate cpu pda table\n");
 
+	for (i = 0; i < nr_cpu_ids; i++)
+		if (_cpu_pda_init[i] != &boot_cpu_pda[i])
+			new_cpu_pda[i] = _cpu_pda_init[i];
+	mb();
+	_cpu_pda = new_cpu_pda;
 	/* cpu_pda() now points to allocated cpu_pda_table */
-
-	for (i = 0; i < NR_CPUS; i++)
-		if (_cpu_pda_init[i] == &boot_cpu_pda[i])
-			cpu_pda(i) = NULL;
-		else
-			cpu_pda(i) = _cpu_pda_init[i];
 }
 #endif
_

Patches currently in -mm which might be from travis@sgi.com are

cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3-fix.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
