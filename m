From: akpm@linux-foundation.org
Subject: - i386-x86-64-fix-section-mismatch.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:07 -0700
Message-ID: <200705180706.l4I766Ba010146@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756076AbXERHIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386/x86-64: fix section mismatch
has been removed from the -mm tree.  Its filename was
     i386-x86-64-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386/x86-64: fix section mismatch
From: Bernhard Walle <bwalle@suse.de>

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to
.init.text:mtrr_bp_init from .text between 'id entify_cpu' (at offset 0x6571)
and 'IRQ0x20_interrupt'

It's because identify_cpu() which is __cpuinit calls mtrr_bp_init() which is
__init(). __cpuinit() expands to nothing if CONFIG_HOTPLUG_CPU=y and so the
call is illegal.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
 arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~i386-x86-64-fix-section-mismatch arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~i386-x86-64-fix-section-mismatch
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -78,7 +78,7 @@ static void __cpuinit print_fixed(unsign
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void __init get_mtrr_state(void)
+void get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
diff -puN arch/i386/kernel/cpu/mtrr/main.c~i386-x86-64-fix-section-mismatch arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~i386-x86-64-fix-section-mismatch
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void __init mtrr_bp_init(void)
+void mtrr_bp_init(void)
 {
 	init_ifs();
 
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
