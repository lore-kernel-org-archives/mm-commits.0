From: akpm@linux-foundation.org
Subject: - paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:12 -0700
Message-ID: <200704132330.l3DNUC6K012717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030893AbXDMXaU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: rename struct paravirt_patch to paravirt_patch_site for clarity
has been removed from the -mm tree.  Its filename was
     paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: rename struct paravirt_patch to paravirt_patch_site for clarity
From: Jeremy Fitzhardinge <jeremy@goop.org>

Rename struct paravirt_patch to paravirt_patch_site, so that it clearly refers
to a callsite, and not the patch which may be applied to that callsite.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    7 ++++---
 arch/i386/kernel/vmi.c         |    2 +-
 include/asm-i386/alternative.h |    8 +++++---
 include/asm-i386/paravirt.h    |    5 ++++-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/alternative.c~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/arch/i386/kernel/alternative.c
@@ -350,9 +350,10 @@ void alternatives_smp_switch(int smp)
 #endif
 
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+void apply_paravirt(struct paravirt_patch_site *start,
+		    struct paravirt_patch_site *end)
 {
-	struct paravirt_patch *p;
+	struct paravirt_patch_site *p;
 
 	for (p = start; p < end; p++) {
 		unsigned int used;
@@ -367,7 +368,7 @@ void apply_paravirt(struct paravirt_patc
 	/* Sync to be conservative, in case we patched following instructions */
 	sync_core();
 }
-extern struct paravirt_patch __start_parainstructions[],
+extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
diff -puN arch/i386/kernel/vmi.c~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/arch/i386/kernel/vmi.c
@@ -72,7 +72,7 @@ static struct {
 } vmi_ops;
 
 /* XXX move this to alternative.h */
-extern struct paravirt_patch __start_parainstructions[],
+extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 
 /*
diff -puN include/asm-i386/alternative.h~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/include/asm-i386/alternative.h
@@ -118,12 +118,14 @@ static inline void alternatives_smp_swit
 #define LOCK_PREFIX ""
 #endif
 
-struct paravirt_patch;
+struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
+void apply_paravirt(struct paravirt_patch_site *start,
+		    struct paravirt_patch_site *end);
 #else
 static inline void
-apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+apply_paravirt(struct paravirt_patch_site *start,
+	       struct paravirt_patch_site *end)
 {}
 #define __start_parainstructions NULL
 #define __stop_parainstructions NULL
diff -puN include/asm-i386/paravirt.h~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/include/asm-i386/paravirt.h
@@ -502,13 +502,16 @@ void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
-struct paravirt_patch {
+struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */
 	u8 instrtype;		/* type of this instruction */
 	u8 len;			/* length of original instruction */
 	u16 clobbers;		/* what registers you may clobber */
 };
 
+extern struct paravirt_patch_site __parainstructions[],
+	__parainstructions_end[];
+
 #define paravirt_alt(insn_string, typenum, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\
 	".pushsection .parainstructions,\"a\"\n"	\
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
