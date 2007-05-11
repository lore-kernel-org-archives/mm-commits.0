From: akpm@linux-foundation.org
Subject: + i386-x86-64-fix-section-mismatch.patch added to -mm tree
Date: Fri, 11 May 2007 10:53:18 -0700
Message-ID: <200705111753.l4BHrI45022487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662AbXEKRxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 13:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ak@suse.de


The patch titled
     i386/x86-64: fix section mismatch
has been added to the -mm tree.  Its filename is
     i386-x86-64-fix-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
i386-x86-64-fix-section-mismatch.patch
