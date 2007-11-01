From: akpm@linux-foundation.org
Subject: + x86_64-show-right-output-for-cpuinfo.patch added to -mm tree
Date: Thu, 01 Nov 2007 10:37:43 -0700
Message-ID: <200711011737.lA1Hbh6B007656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbXKARjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 13:39:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, kiran@scalemp.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: show right output for cpuinfo
has been added to the -mm tree.  Its filename is
     x86_64-show-right-output-for-cpuinfo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: show right output for cpuinfo
From: Glauber de Oliveira Costa <gcosta@redhat.com>

In x86_64 smp systems, a regression was introduced a few days after 2.6.23,
on its way to 2.6.23.  Bisection leads me to commit
92cb7612aee39642d109b8d935ad265e602c0563.

The problem is that the output of 'cat /proc/cpuinfo' shows 0 as the id of
all cpus of a smp system. As far as I know, this only happens on x86_64
systems.

This problem was first noticed by Ravikiran. A simple patch follows

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Ravikiran Thirumalai <kiran@scalemp.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup_64.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/setup_64.c~x86_64-show-right-output-for-cpuinfo arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86_64-show-right-output-for-cpuinfo
+++ a/arch/x86/kernel/setup_64.c
@@ -892,7 +892,6 @@ void __cpuinit early_identify_cpu(struct
 
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
-	c->cpu_index = 0;
 #endif
 }
 
_

Patches currently in -mm which might be from gcosta@redhat.com are

origin.patch
x86_64-show-right-output-for-cpuinfo.patch
git-kvm.patch
