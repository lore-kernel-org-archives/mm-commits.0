From: akpm@linux-foundation.org
Subject: + move-x86-specific-oops=panic-to-generic-code.patch added to -mm tree
Date: Thu, 27 Jan 2011 14:24:09 -0800
Message-ID: <201101272224.p0RMO9N8003319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195Ab1A0WYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 17:24:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     move x86 specific oops=panic to generic code
has been added to the -mm tree.  Its filename is
     move-x86-specific-oops=panic-to-generic-code.patch

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
Subject: move x86 specific oops=panic to generic code
From: Olaf Hering <olaf@aepfle.de>

The oops=panic cmdline option is not x86 specific, move it to generic code.
Update documentation.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt       |    5 +++++
 Documentation/x86/x86_64/boot-options.txt |    5 -----
 arch/x86/kernel/dumpstack.c               |   10 ----------
 kernel/panic.c                            |   10 ++++++++++
 4 files changed, 15 insertions(+), 15 deletions(-)

diff -puN Documentation/kernel-parameters.txt~move-x86-specific-oops=panic-to-generic-code Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~move-x86-specific-oops=panic-to-generic-code
+++ a/Documentation/kernel-parameters.txt
@@ -1805,6 +1805,11 @@ and is between 256 and 4096 characters. 
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
+	oops=panic	Always panic on oopses. Default is to just kill the process,
+			but there is a small probability of deadlocking the machine.
+			This will also cause panics on machine check exceptions.
+			Useful together with panic=30 to trigger a reboot.
+
 	OSS		[HW,OSS]
 			See Documentation/sound/oss/oss-parameters.txt
 
diff -puN Documentation/x86/x86_64/boot-options.txt~move-x86-specific-oops=panic-to-generic-code Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt~move-x86-specific-oops=panic-to-generic-code
+++ a/Documentation/x86/x86_64/boot-options.txt
@@ -293,11 +293,6 @@ IOMMU (input/output memory management un
 
 Debugging
 
-  oops=panic	Always panic on oopses. Default is to just kill the process,
-		but there is a small probability of deadlocking the machine.
-		This will also cause panics on machine check exceptions.
-		Useful together with panic=30 to trigger a reboot.
-
   kstack=N	Print N words from the kernel stack in oops dumps.
 
   pagefaulttrace  Dump all page faults. Only useful for extreme debugging
diff -puN arch/x86/kernel/dumpstack.c~move-x86-specific-oops=panic-to-generic-code arch/x86/kernel/dumpstack.c
--- a/arch/x86/kernel/dumpstack.c~move-x86-specific-oops=panic-to-generic-code
+++ a/arch/x86/kernel/dumpstack.c
@@ -345,16 +345,6 @@ die_nmi(char *str, struct pt_regs *regs,
 	do_exit(SIGBUS);
 }
 
-static int __init oops_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	if (!strcmp(s, "panic"))
-		panic_on_oops = 1;
-	return 0;
-}
-early_param("oops", oops_setup);
-
 static int __init kstack_setup(char *s)
 {
 	if (!s)
diff -puN kernel/panic.c~move-x86-specific-oops=panic-to-generic-code kernel/panic.c
--- a/kernel/panic.c~move-x86-specific-oops=panic-to-generic-code
+++ a/kernel/panic.c
@@ -433,3 +433,13 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
+
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
_

Patches currently in -mm which might be from olaf@aepfle.de are

move-x86-specific-oops=panic-to-generic-code.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch

