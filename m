From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:03 -0800
Message-ID: <200703020457.l224v3VQ000496@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422907AbXCBE5L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:57:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: rename struct paravirt_patch to paravirt_patch_site for clarity
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: rename struct paravirt_patch to paravirt_patch_site for clarity
From: Jeremy Fitzhardinge <jeremy@goop.org>

Rename struct paravirt_patch to paravirt_patch_site, so that it clearly refers
to a callsite, and not the patch which may be applied to that callsite.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    6 ++----
 arch/i386/kernel/vmi.c         |    4 ----
 include/asm-i386/alternative.h |    6 +++---
 include/asm-i386/paravirt.h    |    5 ++++-
 4 files changed, 9 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/alternative.c~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/arch/i386/kernel/alternative.c
@@ -350,9 +350,9 @@ void alternatives_smp_switch(int smp)
 #endif
 
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+void apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end)
 {
-	struct paravirt_patch *p;
+	struct paravirt_patch_site *p;
 
 	for (p = start; p < end; p++) {
 		unsigned int used;
@@ -379,8 +379,6 @@ void apply_paravirt(struct paravirt_patc
 	/* Sync to be conservative, in case we patched following instructions */
 	sync_core();
 }
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
 void __init alternative_instructions(void)
diff -puN arch/i386/kernel/vmi.c~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/arch/i386/kernel/vmi.c
@@ -71,10 +71,6 @@ static struct {
 	void (*halt)(void);
 } vmi_ops;
 
-/* XXX move this to alternative.h */
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
-
 /*
  * VMI patching routines.
  */
diff -puN include/asm-i386/alternative.h~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/include/asm-i386/alternative.h
@@ -118,12 +118,12 @@ static inline void alternatives_smp_swit
 #define LOCK_PREFIX ""
 #endif
 
-struct paravirt_patch;
+struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
+void apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end);
 #else
 static inline void
-apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end)
 {}
 #define __start_parainstructions NULL
 #define __stop_parainstructions NULL
diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity
+++ a/include/asm-i386/paravirt.h
@@ -493,13 +493,16 @@ void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
-struct paravirt_patch {
+struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */
 	u8 instrtype;		/* type of this instruction */
 	u8 len;			/* length of original instruction */
 	u16 clobbers;		/* what registers you may clobber */
 };
 
+extern struct paravirt_patch_site __start_parainstructions[],
+	__stop_parainstructions[];
+
 #define paravirt_alt(insn_string, typenum, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\
 	".pushsection .parainstructions,\"a\"\n"	\
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
