From: akpm@linux-foundation.org
Subject: + x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:53:12 -0700
Message-ID: <200710242253.l9OMrCE3016704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755806AbXJXWxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM


The patch titled
     x86_64: do not clear cpu_index set by store_cpu_info
has been added to the -mm tree.  Its filename is
     x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch
kernel-printkc-concerns-about-the-console-handover.patch
