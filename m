From: akpm@linux-foundation.org
Subject: + fix-x86_64-mm-xen-xen-smp-guest-support.patch added to -mm tree
Date: Wed, 23 May 2007 11:40:24 -0700
Message-ID: <200705231840.l4NIeNqT029370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869AbXEWSlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:41:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wli@holomorphy.com, ak@suse.de, bill.irwin@oracle.com, jeremy@goop.org


The patch titled
     fix x86_64-mm-xen-xen-smp-guest-support
has been added to the -mm tree.  Its filename is
     fix-x86_64-mm-xen-xen-smp-guest-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

fix-x86_64-mm-xen-xen-smp-guest-support.patch
quicklist-support-for-x86_64.patch
x86_64-support-poll-on-dev-mcelog-fix.patch
i386-bigsmp-section-mismatch-fixes.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
