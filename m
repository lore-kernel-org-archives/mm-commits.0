From: akpm@linux-foundation.org
Subject: + cpufreq-use-an-enum-for-speedstep-processor-identification.patch added to -mm tree
Date: Mon, 02 Nov 2009 23:38:15 -0800
Message-ID: <200911030738.nA37cFZx008396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755553AbZKCHi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 02:38:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, davej@codemonkey.org.uk, linux@dominikbrodowski.net


The patch titled
     cpufreq: use an enum for speedstep processor identification
has been added to the -mm tree.  Its filename is
     cpufreq-use-an-enum-for-speedstep-processor-identification.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: use an enum for speedstep processor identification
From: Rusty Russell <rusty@rustcorp.com.au>

The "unsigned int processor" everywhere confused Rusty, leading to
breakage when he passed in smp_processor_id().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |    2 -
 arch/x86/kernel/cpu/cpufreq/speedstep-lib.c |    6 ++--
 arch/x86/kernel/cpu/cpufreq/speedstep-lib.h |   24 +++++++++---------
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c |    2 -
 4 files changed, 17 insertions(+), 17 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~cpufreq-use-an-enum-for-speedstep-processor-identification arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~cpufreq-use-an-enum-for-speedstep-processor-identification
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -39,7 +39,7 @@ static struct pci_dev *speedstep_chipset
 
 /* speedstep_processor
  */
-static unsigned int speedstep_processor;
+static enum speedstep_processor speedstep_processor;
 
 static u32 pmbase;
 
diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-lib.c~cpufreq-use-an-enum-for-speedstep-processor-identification arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c~cpufreq-use-an-enum-for-speedstep-processor-identification
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.c
@@ -34,7 +34,7 @@ static int relaxed_check;
  *                   GET PROCESSOR CORE SPEED IN KHZ                 *
  *********************************************************************/
 
-static unsigned int pentium3_get_frequency(unsigned int processor)
+static unsigned int pentium3_get_frequency(enum speedstep_processor processor)
 {
 	/* See table 14 of p3_ds.pdf and table 22 of 29834003.pdf */
 	struct {
@@ -227,7 +227,7 @@ static unsigned int pentium4_get_frequen
 
 
 /* Warning: may get called from smp_call_function_single. */
-unsigned int speedstep_get_frequency(unsigned int processor)
+unsigned int speedstep_get_frequency(enum speedstep_processor processor)
 {
 	switch (processor) {
 	case SPEEDSTEP_CPU_PCORE:
@@ -380,7 +380,7 @@ EXPORT_SYMBOL_GPL(speedstep_detect_proce
  *                     DETECT SPEEDSTEP SPEEDS                       *
  *********************************************************************/
 
-unsigned int speedstep_get_freqs(unsigned int processor,
+unsigned int speedstep_get_freqs(enum speedstep_processor processor,
 				  unsigned int *low_speed,
 				  unsigned int *high_speed,
 				  unsigned int *transition_latency,
diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-lib.h~cpufreq-use-an-enum-for-speedstep-processor-identification arch/x86/kernel/cpu/cpufreq/speedstep-lib.h
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.h~cpufreq-use-an-enum-for-speedstep-processor-identification
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-lib.h
@@ -11,18 +11,18 @@
 
 
 /* processors */
-
-#define SPEEDSTEP_CPU_PIII_C_EARLY	0x00000001  /* Coppermine core */
-#define SPEEDSTEP_CPU_PIII_C		0x00000002  /* Coppermine core */
-#define SPEEDSTEP_CPU_PIII_T		0x00000003  /* Tualatin core */
-#define SPEEDSTEP_CPU_P4M		0x00000004  /* P4-M  */
-
+enum speedstep_processor {
+	SPEEDSTEP_CPU_PIII_C_EARLY = 0x00000001,  /* Coppermine core */
+	SPEEDSTEP_CPU_PIII_C	   = 0x00000002,  /* Coppermine core */
+	SPEEDSTEP_CPU_PIII_T	   = 0x00000003,  /* Tualatin core */
+	SPEEDSTEP_CPU_P4M	   = 0x00000004,  /* P4-M  */
 /* the following processors are not speedstep-capable and are not auto-detected
  * in speedstep_detect_processor(). However, their speed can be detected using
  * the speedstep_get_frequency() call. */
-#define SPEEDSTEP_CPU_PM		0xFFFFFF03  /* Pentium M  */
-#define SPEEDSTEP_CPU_P4D		0xFFFFFF04  /* desktop P4  */
-#define SPEEDSTEP_CPU_PCORE		0xFFFFFF05  /* Core */
+	SPEEDSTEP_CPU_PM	   = 0xFFFFFF03,  /* Pentium M  */
+	SPEEDSTEP_CPU_P4D	   = 0xFFFFFF04,  /* desktop P4  */
+	SPEEDSTEP_CPU_PCORE	   = 0xFFFFFF05,  /* Core */
+};
 
 /* speedstep states -- only two of them */
 
@@ -31,10 +31,10 @@
 
 
 /* detect a speedstep-capable processor */
-extern unsigned int speedstep_detect_processor (void);
+extern enum speedstep_processor speedstep_detect_processor (void);
 
 /* detect the current speed (in khz) of the processor */
-extern unsigned int speedstep_get_frequency(unsigned int processor);
+extern unsigned int speedstep_get_frequency(enum speedstep_processor processor);
 
 
 /* detect the low and high speeds of the processor. The callback
@@ -42,7 +42,7 @@ extern unsigned int speedstep_get_freque
  * SPEEDSTEP_LOW; the second argument is zero so that no
  * cpufreq_notify_transition calls are initiated.
  */
-extern unsigned int speedstep_get_freqs(unsigned int processor,
+extern unsigned int speedstep_get_freqs(enum speedstep_processor processor,
 	unsigned int *low_speed,
 	unsigned int *high_speed,
 	unsigned int *transition_latency,
diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-smi.c~cpufreq-use-an-enum-for-speedstep-processor-identification arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c~cpufreq-use-an-enum-for-speedstep-processor-identification
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -35,7 +35,7 @@ static int smi_cmd;
 static unsigned int smi_sig;
 
 /* info about the processor */
-static unsigned int speedstep_processor;
+static enum speedstep_processor speedstep_processor;
 
 /*
  * There are only two frequency states for each processor. Values
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
linux-next.patch
speedstep-ich-fix-error-caused-by-394122ab144dae4b276d74644a2f11c44a60ac5c.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cpufreq-use-an-enum-for-speedstep-processor-identification.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
reiser4.patch

