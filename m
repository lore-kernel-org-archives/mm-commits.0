From: akpm@linux-foundation.org
Subject: + x86-convert-mtrr-genericc-to-kernel-doc.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:01:54 -0700
Message-ID: <200803172201.m2HM1sRb000615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbYCQWCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: convert mtrr/generic.c to kernel-doc
has been added to the -mm tree.  Its filename is
     x86-convert-mtrr-genericc-to-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: convert mtrr/generic.c to kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Convert function comment blocks to kernel-doc notation.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mtrr/generic.c |   42 ++++++++++++++-------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff -puN arch/x86/kernel/cpu/mtrr/generic.c~x86-convert-mtrr-genericc-to-kernel-doc arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~x86-convert-mtrr-genericc-to-kernel-doc
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -176,12 +176,13 @@ static inline void k8_enable_fixed_iorrs
 }
 
 /**
- * Checks and updates an fixed-range MTRR if it differs from the value it
- * should have. If K8 extentions are wanted, update the K8 SYSCFG MSR also.
- * see AMD publication no. 24593, chapter 7.8.1, page 233 for more information
- * \param msr MSR address of the MTTR which should be checked and updated
- * \param changed pointer which indicates whether the MTRR needed to be changed
- * \param msrwords pointer to the MSR values which the MSR should have
+ * set_fixed_range - checks & updates a fixed-range MTRR if it differs from the value it should have
+ * @msr: MSR address of the MTTR which should be checked and updated
+ * @changed: pointer which indicates whether the MTRR needed to be changed
+ * @msrwords: pointer to the MSR values which the MSR should have
+ *
+ * If K8 extentions are wanted, update the K8 SYSCFG MSR also.
+ * See AMD publication no. 24593, chapter 7.8.1, page 233 for more information.
  */
 static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 {
@@ -199,12 +200,15 @@ static void set_fixed_range(int msr, boo
 	}
 }
 
+/**
+ * generic_get_free_region - Get a free MTRR.
+ * @base: The starting (base) address of the region.
+ * @size: The size (in bytes) of the region.
+ * @replace_reg: mtrr index to be replaced; set to invalid value if none.
+ *
+ * Returns: The index of the region on success, else negative on error.
+ */
 int generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
-/*  [SUMMARY] Get a free MTRR.
-    <base> The starting (base) address of the region.
-    <size> The size (in bytes) of the region.
-    [RETURNS] The index of the region on success, else -1 on error.
-*/
 {
 	int i, max;
 	mtrr_type ltype;
@@ -249,8 +253,8 @@ static void generic_get_mtrr(unsigned in
 }
 
 /**
- * Checks and updates the fixed-range MTRRs if they differ from the saved set
- * \param frs pointer to fixed-range MTRR values, saved by get_fixed_ranges()
+ * set_fixed_ranges - checks & updates the fixed-range MTRRs if they differ from the saved set
+ * @frs: pointer to fixed-range MTRR values, saved by get_fixed_ranges()
  */
 static int set_fixed_ranges(mtrr_type * frs)
 {
@@ -294,13 +298,13 @@ static bool set_mtrr_var_ranges(unsigned
 
 static u32 deftype_lo, deftype_hi;
 
+/**
+ * set_mtrr_state - Set the MTRR state for this CPU.
+ *
+ * NOTE: The CPU must already be in a safe state for MTRR changes.
+ * RETURNS: 0 if no changes made, else a mask indicating what was changed.
+ */
 static unsigned long set_mtrr_state(void)
-/*  [SUMMARY] Set the MTRR state for this CPU.
-    <state> The MTRR state information to read.
-    <ctxt> Some relevant CPU context.
-    [NOTE] The CPU must already be in a safe state for MTRR changes.
-    [RETURNS] 0 if no changes made, else a mask indication what was changed.
-*/
 {
 	unsigned int i;
 	unsigned long change_mask = 0;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-fix-various-kernel-doc-comments.patch
mm-shmem-and-tiny-shmem-fix-some-kernel-doc.patch
mm-oom_kill-fix-kernel-doc.patch
mm-highmem-kernel-doc-additions.patch
mm-rmap-kernel-doc-fixes.patch
jbd-fix-jbd-kernel-doc-notation.patch
x86-convert-mtrr-genericc-to-kernel-doc.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
profile-likely-unlikely-macros.patch

