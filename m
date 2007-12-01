From: akpm@linux-foundation.org
Subject: - x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:40 -0800
Message-ID: <200712010023.lB10Nex1032005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757799AbXLAA2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:28:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: do not set boot cpu in cpu_online_map at x86_64_start_kernel()
has been removed from the -mm tree.  Its filename was
     x86_64-do-not-set-boot-cpu-in-cpu_online_map-at-x86_64_start_kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
kernel-printkc-concerns-about-the-console-handover.patch
