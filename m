From: akpm@linux-foundation.org
Subject: - x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:22 -0800
Message-ID: <200711192316.lAJNGMX2001766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbXKSXRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:17:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86: typo about sequence of cpu_index and cpu_online in show_cpuinfo()
has been removed from the -mm tree.  Its filename was
     x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: typo about sequence of cpu_index and cpu_online in show_cpuinfo()
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Use the real cpu_index instead of 0.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Thomas Gleixner <tglx@linutronix.de>                                        Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/proc.c~x86-typo-about-sequence-of-cpu_index-and-cpu_online-in arch/x86/kernel/cpu/proc.c
--- a/arch/x86/kernel/cpu/proc.c~x86-typo-about-sequence-of-cpu_index-and-cpu_online-in
+++ a/arch/x86/kernel/cpu/proc.c
@@ -89,9 +89,9 @@ static int show_cpuinfo(struct seq_file 
 	int fpu_exception;
 
 #ifdef CONFIG_SMP
+	n = c->cpu_index;
 	if (!cpu_online(n))
 		return 0;
-	n = c->cpu_index;
 #endif
 	seq_printf(m, "processor\t: %d\n"
 		"vendor_id\t: %s\n"
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
kernel-printkc-concerns-about-the-console-handover.patch
