From: akpm@linux-foundation.org
Subject: + x86-fix-show-cpuinfo-cpu-number-always-zero.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:44:07 -0800
Message-ID: <200712182344.lBINi7Rv028053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbXLRXor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, clameter@sgi.com, mingo@elte.hu, steiner@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de


The patch titled
     x86: fix show cpuinfo cpu number always zero
has been added to the -mm tree.  Its filename is
     x86-fix-show-cpuinfo-cpu-number-always-zero.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: fix show cpuinfo cpu number always zero
From: Mike Travis <travis@sgi.com>

Correct the problem that early_identify_cpu() sets cpu_index to '0' (needed
when called by setup_arch) after smp_store_cpu_info() had set it to the
correct value.

The error shows up in 'cat /proc/cpuinfo' will all cpus = 0.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Suresh B Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/smpboot_64.c~x86-fix-show-cpuinfo-cpu-number-always-zero arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~x86-fix-show-cpuinfo-cpu-number-always-zero
+++ a/arch/x86/kernel/smpboot_64.c
@@ -139,8 +139,8 @@ static void __cpuinit smp_store_cpu_info
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 
_

Patches currently in -mm which might be from travis@sgi.com are

git-x86.patch
x86-fix-show-cpuinfo-cpu-number-always-zero.patch
vmstat-remove-prefetch.patch
