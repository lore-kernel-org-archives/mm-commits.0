From: akpm@linux-foundation.org
Subject: + i386-mce-check-capability.patch added to -mm tree
Date: Sun, 08 Apr 2007 02:24:08 -0700
Message-ID: <200704080924.l389O8Yu019977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbXDHJYY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 8 Apr 2007 05:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joachim.deguara@amd.com, ak@suse.de


The patch titled
     i386 mce: check capability
has been added to the -mm tree.  Its filename is
     i386-mce-check-capability.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 mce: check capability
From: "Joachim Deguara" <joachim.deguara@amd.com>

Currently the i386 architecture checks the family for mce capability and this
removes that and uses the CPUID information.  Tested on a K8 revE and a
family10h processor.

This eliminates checking of a set AMD procesor family if mce is 
allowed and relies on the information being in CPUID.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/k7.c  |    3 +++
 arch/i386/kernel/cpu/mcheck/mce.c |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/mcheck/k7.c~i386-mce-check-capability arch/i386/kernel/cpu/mcheck/k7.c
--- a/arch/i386/kernel/cpu/mcheck/k7.c~i386-mce-check-capability
+++ a/arch/i386/kernel/cpu/mcheck/k7.c
@@ -75,6 +75,9 @@ void amd_mcheck_init(struct cpuinfo_x86 
 	machine_check_vector = k7_machine_check;
 	wmb();
 
+	if (!cpu_has(c, X86_FEATURE_MCE))
+		return;
+
 	printk (KERN_INFO "Intel machine check architecture supported.\n");
 	rdmsr (MSR_IA32_MCG_CAP, l, h);
 	if (l & (1<<8))	/* Control register present ? */
diff -puN arch/i386/kernel/cpu/mcheck/mce.c~i386-mce-check-capability arch/i386/kernel/cpu/mcheck/mce.c
--- a/arch/i386/kernel/cpu/mcheck/mce.c~i386-mce-check-capability
+++ a/arch/i386/kernel/cpu/mcheck/mce.c
@@ -38,8 +38,7 @@ void mcheck_init(struct cpuinfo_x86 *c)
 
 	switch (c->x86_vendor) {
 		case X86_VENDOR_AMD:
-			if (c->x86==6 || c->x86==15)
-				amd_mcheck_init(c);
+			amd_mcheck_init(c);
 			break;
 
 		case X86_VENDOR_INTEL:
_

Patches currently in -mm which might be from joachim.deguara@amd.com are

git-alsa.patch
i386-mce-check-capability.patch
