From: akpm@linux-foundation.org
Subject: + mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:39:30 -0700
Message-ID: <200704132139.l3DLdUUM010118@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030608AbXDMVji (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bk@suse.de, ak@suse.de, davej@codemonkey.org.uk


The patch titled
     mtrr: adds mtrr_save_fixed_ranges() for use in two later  patches
has been added to the -mm tree.  Its filename is
     mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtrr: adds mtrr_save_fixed_ranges() for use in two later  patches
From: Bernhard Kaindl <bk@suse.de>

In this current implementation which is used in other patches,
mtrr_save_fixed_ranges() accepts a dummy void pointer because in the current
implementation of one of these patches, this function may be called from
smp_call_function_single() which requires that this function takes a void
pointer argument.

This function calls get_fixed_ranges(), passing mtrr_state.fixed_ranges which
is the element of the static struct which stores our current backup of the
fixed-range MTRR values which all CPUs shall be using.

Because mtrr_save_fixed_ranges calls get_fixed_ranges after kernel
initialisation time, __init needs to be removed from the declaration of
get_fixed_ranges().

If CONFIG_MTRR is not set, we define mtrr_save_fixed_ranges as an empty
statement because there is nothing to do.

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |   16 +++++++++++++++-
 include/asm-i386/mtrr.h             |    2 ++
 include/asm-x86_64/proto.h          |    2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -37,7 +37,11 @@ get_mtrr_var_range(unsigned int index, s
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }
 
-static void __cpuinit
+/**
+ * Retrieves the current fixed-range MTRRs from the current CPU
+ * \param frs address where to write the current MTRR contents
+ */
+static void
 get_fixed_ranges(mtrr_type * frs)
 {
 	unsigned int *p = (unsigned int *) frs;
@@ -51,6 +55,16 @@ get_fixed_ranges(mtrr_type * frs)
 		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
 }
 
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
 static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
diff -puN include/asm-i386/mtrr.h~mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches include/asm-i386/mtrr.h
--- a/include/asm-i386/mtrr.h~mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches
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
diff -puN include/asm-x86_64/proto.h~mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches
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

mtrr-adds-mtrr_save_fixed_ranges-for-use-in-two-later-patches.patch
mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
mtrr-save-and-restore-the-fixed-range-mtrrs-of-the-bsp-when-suspending.patch
mtrr-enable-support-for-fixed-range-iorrs-to-keep-rdmem-wrmem-in-sync.patch
