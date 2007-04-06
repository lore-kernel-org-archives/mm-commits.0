From: akpm@linux-foundation.org
Subject: + paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch added to -mm tree
Date: Fri, 06 Apr 2007 16:26:33 -0700
Message-ID: <200704062326.l36NQXYF022517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbXDFX0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 19:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     paravirt_ops: rename struct paravirt_patch to paravirt_patch_site for clarity
has been added to the -mm tree.  Its filename is
     paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -73,7 +73,7 @@ static struct {
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

paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
