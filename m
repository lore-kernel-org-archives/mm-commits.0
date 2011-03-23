From: akpm@linux-foundation.org
Subject: [merged] move-x86-specific-oops=panic-to-generic-code.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:52 -0700
Message-ID: <201103232042.p2NKgShK028764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933407Ab1CWUnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     move x86 specific oops=panic to generic code
has been removed from the -mm tree.  Its filename was
     move-x86-specific-oops=panic-to-generic-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1825,6 +1825,11 @@ bytes respectively. Such letter suffixes
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
@@ -322,16 +322,6 @@ void die(const char *str, struct pt_regs
 	oops_end(flags, regs, sig);
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

origin.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

