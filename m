From: akpm@linux-foundation.org
Subject: [merged] kernel-exitc-export-abort-to-modules.patch
 removed from -mm tree
Date: Fri, 12 Jan 2018 13:43:52 -0800
Message-ID: <20180112214352.VCBafKpEb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965253AbeALVnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 16:43:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Alexey.Brodkin@synopsys.com, arnd@arndb.de, Jose.Abreu@synopsys.com, mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk, sudipm.mukherjee@gmail.com, Vineet.Gupta1@synopsys.com


The patch titled
     Subject: kernel/exit.c: export abort() to modules
has been removed from the -mm tree.  Its filename was
     kernel-exitc-export-abort-to-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/exit.c: export abort() to modules

gcc -fisolate-erroneous-paths-dereference can generate calls to abort()
from modular code too.

[arnd@arndb.de: drop duplicate exports of abort()]
  Link: http://lkml.kernel.org/r/20180102103311.706364-1-arnd@arndb.de
Reported-by: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/traps.c       |    1 -
 arch/m32r/kernel/traps.c      |    1 -
 arch/unicore32/kernel/traps.c |    1 -
 kernel/exit.c                 |    1 +
 4 files changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/arm/kernel/traps.c~kernel-exitc-export-abort-to-modules arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~kernel-exitc-export-abort-to-modules
+++ a/arch/arm/kernel/traps.c
@@ -793,7 +793,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN arch/m32r/kernel/traps.c~kernel-exitc-export-abort-to-modules arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~kernel-exitc-export-abort-to-modules
+++ a/arch/m32r/kernel/traps.c
@@ -122,7 +122,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN arch/unicore32/kernel/traps.c~kernel-exitc-export-abort-to-modules arch/unicore32/kernel/traps.c
--- a/arch/unicore32/kernel/traps.c~kernel-exitc-export-abort-to-modules
+++ a/arch/unicore32/kernel/traps.c
@@ -298,7 +298,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN kernel/exit.c~kernel-exitc-export-abort-to-modules kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-export-abort-to-modules
+++ a/kernel/exit.c
@@ -1763,3 +1763,4 @@ __weak void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
+EXPORT_SYMBOL(abort);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

