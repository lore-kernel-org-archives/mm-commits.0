From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-xen-xen-smp-guest-support.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:08 -0700
Message-ID: <200707192008.l6JK88vv020428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759376AbXGSUQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wli@holomorphy.com, ak@suse.de, bill.irwin@oracle.com, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     fix x86_64-mm-xen-xen-smp-guest-support
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-xen-xen-smp-guest-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix x86_64-mm-xen-xen-smp-guest-support
From: William Lee Irwin III <wli@holomorphy.com>

This patch silences the following warning:
WARNING: arch/i386/kernel/built-in.o(.text+0xdba6): Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
Marking set_cpu_sibling_map() as __cpuinit resolves the section conflict
with the __cpuinitdata cpu_llc_id[] variable.

Signed-off-by: William Irwin <bill.irwin@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/smpboot.c~fix-x86_64-mm-xen-xen-smp-guest-support arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~fix-x86_64-mm-xen-xen-smp-guest-support
+++ a/arch/i386/kernel/smpboot.c
@@ -308,7 +308,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-void set_cpu_sibling_map(int cpu)
+void __cpuinit set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = cpu_data;
_

Patches currently in -mm which might be from wli@holomorphy.com are

origin.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
containersv10-basic-container-framework-fix-2.patch
