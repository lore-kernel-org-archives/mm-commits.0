From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:47:20 -0700
Message-ID: <201009072347.o87NlLMt013906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756540Ab0IGXsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, davej@codemonkey.org.uk, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/kernel/cpu/cpufreq: fix unsigned return type
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch

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
Subject: arch/x86/kernel/cpu/cpufreq: fix unsigned return type
From: Julia Lawall <julia@diku.dk>

In each case, the function has an unsigned return type, but returns a
negative constant to indicate an error condition.  Each function is only
called once.  For nforce2_detect_chipset, the result is only compared to
0, and for longrun_determine_freqs, the result is stored in a variable of
type (signed) int.  Thus, for both functions, unsigned can be dropped from
the return type.

A sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
identifier f;
constant C;
@@

 unsigned f(...)
 { <+...
*  return -C;
 ...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c |    2 +-
 arch/x86/kernel/cpu/cpufreq/longrun.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c~arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c~arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type
+++ a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -393,7 +393,7 @@ static struct cpufreq_driver nforce2_dri
  * Detects nForce2 A2 and C1 stepping
  *
  */
-static unsigned int nforce2_detect_chipset(void)
+static int nforce2_detect_chipset(void)
 {
 	nforce2_dev = pci_get_subsys(PCI_VENDOR_ID_NVIDIA,
 					PCI_DEVICE_ID_NVIDIA_NFORCE2,
diff -puN arch/x86/kernel/cpu/cpufreq/longrun.c~arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type arch/x86/kernel/cpu/cpufreq/longrun.c
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c~arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type
+++ a/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -165,7 +165,7 @@ static unsigned int longrun_get(unsigned
  * TMTA rules:
  * performance_pctg = (target_freq - low_freq)/(high_freq - low_freq)
  */
-static unsigned int __cpuinit longrun_determine_freqs(unsigned int *low_freq,
+static int __cpuinit longrun_determine_freqs(unsigned int *low_freq,
 						      unsigned int *high_freq)
 {
 	u32 msr_lo, msr_hi;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-mmc-host-imxmmcc-adjust-confusing-if-indentation.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-video-matrox-matroxfb_mavenc-fix-unsigned-return-type.patch
arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch
net-9p-trans_fdc-fix-unsigned-return-type.patch
drivers-i2c-busses-i2c-pasemic-fix-unsigned-return-type.patch
drivers-atm-firestreamc-fix-unsigned-return-type.patch
drivers-net-wireless-iwlwifi-iwl-agnc-fix-return-value-from-an-unsigned-function.patch

