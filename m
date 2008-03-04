From: akpm@linux-foundation.org
Subject: - x86_64-fold-pda-into-per-cpu-area-v3-fix.patch removed from -mm tree
Date: Mon, 03 Mar 2008 16:53:54 -0800
Message-ID: <200803040103.m2413HIb016166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbYCDBSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 20:18:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, dada1@cosmosbay.com, jschopp@austin.ibm.com, mingo@elte.hu, rdunlap@xenotime.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: x86_64_cleanup_pda() should use nr_cpu_ids instead of NR_CPUS
has been removed from the -mm tree.  Its filename was
     x86_64-fold-pda-into-per-cpu-area-v3-fix.patch

This patch was dropped because it had testing failures

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
