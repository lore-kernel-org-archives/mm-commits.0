From: akpm@linux-foundation.org
Subject: - x86-fix-show-cpuinfo-cpu-number-always-zero.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:39 -0800
Message-ID: <200712202338.lBKNcds6018991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756649AbXLTXse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, ak@suse.de, clameter@sgi.com, mingo@elte.hu, steiner@sgi.com, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix show cpuinfo cpu number always zero
has been removed from the -mm tree.  Its filename was
     x86-fix-show-cpuinfo-cpu-number-always-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-x86.patch
vmstat-remove-prefetch.patch
