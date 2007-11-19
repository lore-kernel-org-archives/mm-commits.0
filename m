From: akpm@linux-foundation.org
Subject: - x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:20 -0800
Message-ID: <200711192316.lAJNGKrC001763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbXKSXRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:17:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_64: do not clear cpu_index set by store_cpu_info
has been removed from the -mm tree.  Its filename was
     x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: do not clear cpu_index set by store_cpu_info
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

early_indentify_cpu() is called after store_cpu_info().  So don't clear the
assigned cpu_index.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Thomas Gleixner <tglx@linutronix.de>                                        Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_64.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/setup_64.c~x86_64-do-not-clear-cpu_index-set-by-store_cpu_info arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86_64-do-not-clear-cpu_index-set-by-store_cpu_info
+++ a/arch/x86/kernel/setup_64.c
@@ -940,7 +940,6 @@ void __cpuinit early_identify_cpu(struct
 
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
-	c->cpu_index = 0;
 #endif
 
 	/* AMD-defined flags: level 0x80000001 */
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
kernel-printkc-concerns-about-the-console-handover.patch
