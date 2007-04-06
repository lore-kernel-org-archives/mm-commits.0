From: akpm@linux-foundation.org
Subject: + allow-boot-time-disable-of-smp-altinstructions.patch added to -mm tree
Date: Thu, 05 Apr 2007 17:47:34 -0700
Message-ID: <200704060047.l360lYkS030808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59560 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767460AbXDFArj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 20:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, jeremy@xensource.com


The patch titled
     Allow boot-time disable of SMP altinstructions
has been added to the -mm tree.  Its filename is
     allow-boot-time-disable-of-smp-altinstructions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow boot-time disable of SMP altinstructions
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add "noreplace-smp" to disable SMP instruction replacement.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++++
 arch/i386/kernel/alternative.c      |   23 +++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~allow-boot-time-disable-of-smp-altinstructions Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~allow-boot-time-disable-of-smp-altinstructions
+++ a/Documentation/kernel-parameters.txt
@@ -1135,6 +1135,9 @@ and is between 256 and 4096 characters. 
 
 	nomce		[IA-32] Machine Check Exception
 
+	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
+			with UP alternatives
+
 	noresidual	[PPC] Don't use residual data on PReP machines.
 
 	noresume	[SWSUSP] Disables resume and restores original swap
@@ -1540,6 +1543,9 @@ and is between 256 and 4096 characters. 
 	smart2=		[HW]
 			Format: <io1>[,<io2>[,...,<io8>]]
 
+	smp-alt-once	[IA-32,SMP] On a hotplug CPU system, only
+			attempt to substitute SMP alternatives once at boot.
+
 	snd-ad1816a=	[HW,ALSA]
 
 	snd-ad1848=	[HW,ALSA]
diff -puN arch/i386/kernel/alternative.c~allow-boot-time-disable-of-smp-altinstructions arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~allow-boot-time-disable-of-smp-altinstructions
+++ a/arch/i386/kernel/alternative.c
@@ -5,6 +5,7 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
+static int noreplace_smp     = 0;
 static int smp_alt_once      = 0;
 static int debug_alternative = 0;
 
@@ -13,15 +14,23 @@ static int __init bootonly(char *str)
 	smp_alt_once = 1;
 	return 1;
 }
+__setup("smp-alt-boot", bootonly);
+
 static int __init debug_alt(char *str)
 {
 	debug_alternative = 1;
 	return 1;
 }
-
-__setup("smp-alt-boot", bootonly);
 __setup("debug-alternative", debug_alt);
 
+static int __init setup_noreplace_smp(char *str)
+{
+	noreplace_smp = 1;
+	return 1;
+}
+__setup("noreplace-smp", setup_noreplace_smp);
+
+
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
@@ -185,6 +194,9 @@ static void alternatives_smp_unlock(u8 *
 {
 	u8 **ptr;
 
+	if (noreplace_smp)
+		return;
+
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
 			continue;
@@ -219,6 +231,9 @@ void alternatives_smp_module_add(struct 
 	struct smp_alt_module *smp;
 	unsigned long flags;
 
+	if (noreplace_smp)
+		return;
+
 	if (smp_alt_once) {
 		if (boot_cpu_has(X86_FEATURE_UP))
 			alternatives_smp_unlock(locks, locks_end,
@@ -253,7 +268,7 @@ void alternatives_smp_module_del(struct 
 	struct smp_alt_module *item;
 	unsigned long flags;
 
-	if (smp_alt_once)
+	if (smp_alt_once || noreplace_smp)
 		return;
 
 	spin_lock_irqsave(&smp_alt, flags);
@@ -284,7 +299,7 @@ void alternatives_smp_switch(int smp)
 	return;
 #endif
 
-	if (smp_alt_once)
+	if (noreplace_smp || smp_alt_once)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
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
