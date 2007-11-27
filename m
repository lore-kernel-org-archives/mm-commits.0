From: akpm@linux-foundation.org
Subject: + x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:22:55 -0800
Message-ID: <200711270722.lAR7MtLw000488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbXK0HX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM, zach@vmware.com


The patch titled
     x86_64: do not set boot cpu in cpu_online_map at x86_64_start_kernel()
has been added to the -mm tree.  Its filename is
     x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: do not set boot cpu in cpu_online_map at x86_64_start_kernel()
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

In init/main.c boot_cpu_init() does that later

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/head64.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/x86/kernel/head64.c~x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c~x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel
+++ a/arch/x86/kernel/head64.c
@@ -69,8 +69,6 @@ void __init x86_64_start_kernel(char * r
 
 	pda_init(0);
 	copy_bootdata(__va(real_mode_data));
-#ifdef CONFIG_SMP
-	cpu_set(0, cpu_online_map);
-#endif
+
 	start_kernel();
 }
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
cpufreq-powernow-k8-print-pstate-instead-of-fid-did-for-family-10h.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch
kernel-printkc-concerns-about-the-console-handover.patch
