From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch removed
 from -mm tree
Date: Mon, 08 Jun 2020 20:12:08 -0700
Message-ID: <20200609031208.jqm0dLtTp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDMK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: x86/kaslr: take CONFIG_RANDOMIZE_MEMORY into account in kaslr_enabled()
has been removed from the -mm tree.  Its filename was
     x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch

This patch was dropped because it was folded into x86-mm-simplify-init_trampoline-and-surrounding-logic.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: x86/kaslr: take CONFIG_RANDOMIZE_MEMORY into account in kaslr_enabled()

Until refactoring of the init_trampoline(), kaslr_enabled() was used only
inside '#ifdef CONFIG_RANDOMIZE_MEMORY' and reported only the state of the
command line override.

The simplification of init_trampoline() made kaslr_enabled() visible for
builds with CONFIG_RANDOMIZE_MEMORY=n and in this case it will return true
if the randomization was not disabled on the command line.

This in turn will call a dummy init_trampoline_kaslr() instead of setting
trampline_pgd_entry directly.

As the result, the kernel reboots while starting the secondary CPUs, e.g.
kernel test bot reported:

...
[    0.244628] Performance Events: unsupported p6 CPU model 60 no PMU driver, software events only.
[    0.244993] rcu: Hierarchical SRCU implementation.
[    0.245617] smp: Bringing up secondary CPUs ...
[    0.247388] x86: Booting SMP configuration:
BUG: kernel reboot-without-warning in boot stage

Adding a check for IS_ENABLED(CONFIG_RANDOMIZE_MEMORY) to kaslr_enabled()
resolves the issue.

Link: http://lkml.kernel.org/r/20200525104045.GB13212@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/setup.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/setup.h~x86-mm-simplify-init_trampoline-and-surrounding-logic-fix
+++ a/arch/x86/include/asm/setup.h
@@ -75,7 +75,8 @@ extern char _text[];
 
 static inline bool kaslr_enabled(void)
 {
-	return !!(boot_params.hdr.loadflags & KASLR_FLAG);
+	return IS_ENABLED(CONFIG_RANDOMIZE_MEMORY) &&
+		!!(boot_params.hdr.loadflags & KASLR_FLAG);
 }
 
 /*
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
