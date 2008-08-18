From: akpm@linux-foundation.org
Subject: - x86-pda_init-fix-memory-leak-with-cpu_hotplug.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:55 -0700
Message-ID: <200808181940.m7IJetIO008498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763489AbYHRTup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.herrmann3@amd.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: pda_init: fix memory leak with CPU_HOTPLUG
has been removed from the -mm tree.  Its filename was
     x86-pda_init-fix-memory-leak-with-cpu_hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: pda_init: fix memory leak with CPU_HOTPLUG
From: Andreas Herrmann <andreas.herrmann3@amd.com>

pda->irqstackptr is allocated whenever a CPU is set online.  But it is
never freed (or did I miss something?).  This results in a memory leak of
16 KByte for each CPU offline/online cycle.

Fix is to allocate pda->irqstackptr only once.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common_64.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/cpu/common_64.c~x86-pda_init-fix-memory-leak-with-cpu_hotplug arch/x86/kernel/cpu/common_64.c
--- a/arch/x86/kernel/cpu/common_64.c~x86-pda_init-fix-memory-leak-with-cpu_hotplug
+++ a/arch/x86/kernel/cpu/common_64.c
@@ -493,17 +493,20 @@ void pda_init(int cpu)
 		/* others are initialized in smpboot.c */
 		pda->pcurrent = &init_task;
 		pda->irqstackptr = boot_cpu_stack;
+		pda->irqstackptr += IRQSTACKSIZE - 64;
 	} else {
-		pda->irqstackptr = (char *)
-			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
-		if (!pda->irqstackptr)
-			panic("cannot allocate irqstack for cpu %d", cpu);
+		if (!pda->irqstackptr) {
+			pda->irqstackptr = (char *)
+				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
+			if (!pda->irqstackptr)
+				panic("cannot allocate irqstack for cpu %d",
+				      cpu);
+			pda->irqstackptr += IRQSTACKSIZE - 64;
+		}
 
 		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
 			pda->nodenumber = cpu_to_node(cpu);
 	}
