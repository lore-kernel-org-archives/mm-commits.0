From: akpm@linux-foundation.org
Subject: + x86-uv-make-kdump-avoid-stack-dumps.patch added to -mm tree
Date: Thu, 12 Aug 2010 12:10:36 -0700
Message-ID: <201008121910.o7CJAc6j007655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427Ab0HLTLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 15:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cpw@sgi.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86/uv:  make kdump avoid stack dumps
has been added to the -mm tree.  Its filename is
     x86-uv-make-kdump-avoid-stack-dumps.patch

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
Subject: x86/uv:  make kdump avoid stack dumps
From: Cliff Wickman <cpw@sgi.com>

UV NMI callback's should not write stack dumps when a kdump is to be written.

When invoking the crash kernel to write a dump, kdump_nmi_shootdown_cpus()
uses NMI's to get all the cpu's to save their register context and halt.

But the NMI interrupt handler runs a callback list.  This patch sets a
flag to prevent any of those callbacks from interfering with the halt of
the cpu.

For UV, which currently has the only callback to which this is relevant,
the uv_handle_nmi() callback should not do dumping of stacks.

The 'in_crash_kexec' flag is defined as an extern in kdebug.h firstly
because x2apic_uv_x.c includes it.  Secondly because some future callback
might need the flag to know that it should not enter the debugger.  (Such
a scenario was in fact present in the 2.6.32 kernel, SuSE distribution,
where a call to kdb needed to be avoided.)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kdebug.h      |    6 ++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ++++
 arch/x86/kernel/crash.c            |    3 +++
 3 files changed, 13 insertions(+)

diff -puN arch/x86/include/asm/kdebug.h~x86-uv-make-kdump-avoid-stack-dumps arch/x86/include/asm/kdebug.h
--- a/arch/x86/include/asm/kdebug.h~x86-uv-make-kdump-avoid-stack-dumps
+++ a/arch/x86/include/asm/kdebug.h
@@ -33,5 +33,11 @@ extern void __show_regs(struct pt_regs *
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
+#ifdef CONFIG_KEXEC
+extern int in_crash_kexec;
+#else
+/* no crash dump is ever in progress if no crash kernel can be kexec'd */
+#define in_crash_kexec 0
+#endif
 
 #endif /* _ASM_X86_KDEBUG_H */
diff -puN arch/x86/kernel/apic/x2apic_uv_x.c~x86-uv-make-kdump-avoid-stack-dumps arch/x86/kernel/apic/x2apic_uv_x.c
--- a/arch/x86/kernel/apic/x2apic_uv_x.c~x86-uv-make-kdump-avoid-stack-dumps
+++ a/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -604,6 +604,10 @@ int uv_handle_nmi(struct notifier_block 
 {
 	if (reason != DIE_NMI_IPI)
 		return NOTIFY_OK;
+
+	if (in_crash_kexec)
+		/* do nothing if entering the crash kernel */
+		return NOTIFY_OK;
 	/*
 	 * Use a lock so only one cpu prints at a time
 	 * to prevent intermixed output.
diff -puN arch/x86/kernel/crash.c~x86-uv-make-kdump-avoid-stack-dumps arch/x86/kernel/crash.c
--- a/arch/x86/kernel/crash.c~x86-uv-make-kdump-avoid-stack-dumps
+++ a/arch/x86/kernel/crash.c
@@ -28,6 +28,8 @@
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
+int in_crash_kexec;
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct die_args *args)
@@ -61,6 +63,7 @@ static void kdump_nmi_callback(int cpu, 
 
 static void kdump_nmi_shootdown_cpus(void)
 {
+	in_crash_kexec = 1;
 	nmi_shootdown_cpus(kdump_nmi_callback);
 
 	disable_local_APIC();
_

Patches currently in -mm which might be from cpw@sgi.com are

linux-next.patch
x86-uv-make-kdump-avoid-stack-dumps.patch

