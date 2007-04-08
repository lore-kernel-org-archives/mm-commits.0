From: akpm@linux-foundation.org
Subject: - mtrr-implement-mtrr_save_fixed_ranges.patch removed from -mm tree
Date: Sun, 08 Apr 2007 13:53:32 -0700
Message-ID: <200704082053.l38Kra3G030109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXDHUxq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 8 Apr 2007 16:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bk@suse.de, ak@suse.de, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     mtrr: implement mtrr_save_fixed_ranges()
has been removed from the -mm tree.  Its filename was
     mtrr-implement-mtrr_save_fixed_ranges.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: mtrr: implement mtrr_save_fixed_ranges()
From: Bernhard Kaindl <bk@suse.de>

This patch implements mtrr_save_fixed_ranges() which can be called from
anywhere anytime to retrieve the fixed-range MTRRs from the current CPU and
saves these MTRR values to the MTRR state struct.

This function calls get_fixed_ranges(), passing mtrr_state.fixed_ranges which
is the element of the static struct which stores our current backup of the
fixed-range MTRR values which all CPUs shall be using.

Because mtrr_save_fixed_ranges calls get_fixed_ranges() after kernel
initialisation time, __init needs to be removed from the declaration of
get_fixed_ranges().

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |   20 +++++++++++++++++---
 include/asm-i386/mtrr.h             |    2 ++
 include/asm-x86_64/proto.h          |    2 ++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~mtrr-implement-mtrr_save_fixed_ranges arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~mtrr-implement-mtrr_save_fixed_ranges
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -29,8 +29,11 @@ static struct mtrr_state mtrr_state = {}
 static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
-/*  Get the MSR pair relating to a var range  */
-static void __cpuinit
+/**
+ * Retrieves the current fixed-range MTRRs from the current CPU
+ * \param frs address where to write the current MTRR contents
+ */
+static void
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 {
 	rdmsr(MTRRphysBase_MSR(index), vr->base_lo, vr->base_hi);
@@ -51,7 +54,18 @@ get_fixed_ranges(mtrr_type * frs)
 		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
 }
 
-static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
+/**
+ * Updates our copy of the state of the fixed-range MTRR values
+ * with the current fixed-range MTRR contents from the current CPU
+ * \param info dummy needed for use by smp_call_function_single()
+ */
+void mtrr_save_fixed_ranges(void *info)
+{
+	get_fixed_ranges(mtrr_state.fixed_ranges);
+}
+
+static void __cpuinit print_fixed(unsigned base, unsigned step,
+				const mtrr_type*types)
 {
 	unsigned i;
 
diff -puN include/asm-i386/mtrr.h~mtrr-implement-mtrr_save_fixed_ranges include/asm-i386/mtrr.h
--- a/include/asm-i386/mtrr.h~mtrr-implement-mtrr_save_fixed_ranges
+++ a/include/asm-i386/mtrr.h
@@ -69,6 +69,7 @@ struct mtrr_gentry
 
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
+extern void mtrr_save_fixed_ranges(void *);
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
@@ -79,6 +80,7 @@ extern void mtrr_centaur_report_mcr(int 
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 #  else
+#define mtrr_save_fixed_ranges(arg) do {} while (0)
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
 {
diff -puN include/asm-x86_64/proto.h~mtrr-implement-mtrr_save_fixed_ranges include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~mtrr-implement-mtrr_save_fixed_ranges
+++ a/include/asm-x86_64/proto.h
@@ -17,9 +17,11 @@ extern void mcheck_init(struct cpuinfo_x
 #ifdef CONFIG_MTRR
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
+extern void mtrr_save_fixed_ranges(void *);
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
+#define mtrr_save_fixed_ranges(arg) do {} while (0)
 #endif
 extern void init_memory_mapping(unsigned long start, unsigned long end);
 
_

Patches currently in -mm which might be from bk@suse.de are

mtrr-implement-mtrr_save_fixed_ranges.patch
mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap-fix.patch
mtrr-bsp-save-and-restore-fixed-range-mtrrs-during-suspend.patch
mtrr-enable-fixed-range-iorrs-to-sync-rdmem-and-wrmem.patch
