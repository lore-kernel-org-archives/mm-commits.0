From: akpm@linux-foundation.org
Subject: + allow-boot-time-disable-of-paravirt_ops-patching.patch added to -mm tree
Date: Thu, 05 Apr 2007 17:47:36 -0700
Message-ID: <200704060047.l360la0k030811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59566 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767464AbXDFArp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 20:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, rusty@rustcorp.com.au


The patch titled
     Allow boot-time disable of paravirt_ops patching
has been added to the -mm tree.  Its filename is
     allow-boot-time-disable-of-paravirt_ops-patching.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow boot-time disable of paravirt_ops patching
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add "noreplace-paravirt" to disable paravirt_ops patching.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 arch/i386/kernel/alternative.c      |   13 +++++++++++++
 2 files changed, 16 insertions(+)

diff -puN Documentation/kernel-parameters.txt~allow-boot-time-disable-of-paravirt_ops-patching Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~allow-boot-time-disable-of-paravirt_ops-patching
+++ a/Documentation/kernel-parameters.txt
@@ -64,6 +64,7 @@ parameter is applicable:
 	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
+	PV_OPS	A paravirtualized kernel
 	PARIDE	The ParIDE subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
 	PCI	PCI bus support is enabled.
@@ -1135,6 +1136,8 @@ and is between 256 and 4096 characters. 
 
 	nomce		[IA-32] Machine Check Exception
 
+	noreplace-paravirt	[IA-32,PV_OPS] Don't patch paravirt_ops
+
 	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
 			with UP alternatives
 
diff -puN arch/i386/kernel/alternative.c~allow-boot-time-disable-of-paravirt_ops-patching arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~allow-boot-time-disable-of-paravirt_ops-patching
+++ a/arch/i386/kernel/alternative.c
@@ -30,6 +30,16 @@ static int __init setup_noreplace_smp(ch
 }
 __setup("noreplace-smp", setup_noreplace_smp);
 
+#ifdef CONFIG_PARAVIRT
+static int noreplace_paravirt = 0;
+
+static int __init setup_noreplace_paravirt(char *str)
+{
+	noreplace_paravirt = 1;
+	return 1;
+}
+__setup("noreplace-paravirt", setup_noreplace_paravirt);
+#endif
 
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
@@ -329,6 +339,9 @@ void apply_paravirt(struct paravirt_patc
 {
 	struct paravirt_patch *p;
 
+	if (noreplace_paravirt)
+		return;
+
 	for (p = start; p < end; p++) {
 		unsigned int used;
 
_

Patches currently in -mm which might be from jeremy@goop.org are

re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
