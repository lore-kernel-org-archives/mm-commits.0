From: akpm@linux-foundation.org
Subject: + x86-use-hw_err-in-mce-handler.patch added to -mm tree
Date: Thu, 10 Jun 2010 16:46:33 -0700
Message-ID: <201006102346.o5ANkYqN030131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab0FJXrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 19:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, hpa@zytor.com, mingo@elte.hu, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de


The patch titled
     x86: use HW_ERR in MCE handler
has been added to the -mm tree.  Its filename is
     x86-use-hw_err-in-mce-handler.patch

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
Subject: x86: use HW_ERR in MCE handler
From: Huang Ying <ying.huang@intel.com>

Use the HW_ERR printk prefix in MCE handler.  To make it more explicit
that this is a hardware error instead of a software error.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/mce.c |   32 +++++++++--------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce.c~x86-use-hw_err-in-mce-handler arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~x86-use-hw_err-in-mce-handler
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -107,8 +107,8 @@ EXPORT_SYMBOL_GPL(x86_mce_decoder_chain)
 static int default_decode_mce(struct notifier_block *nb, unsigned long val,
 			       void *data)
 {
-	pr_emerg("No human readable MCE decoding support on this CPU type.\n");
-	pr_emerg("Run the message through 'mcelog --ascii' to decode.\n");
+	pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
+	pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");
 
 	return NOTIFY_STOP;
 }
@@ -211,11 +211,11 @@ void mce_log(struct mce *mce)
 
 static void print_mce(struct mce *m)
 {
-	pr_emerg("CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
+	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
 
 	if (m->ip) {
-		pr_emerg("RIP%s %02x:<%016Lx> ",
+		pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> ",
 			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
 				m->cs, m->ip);
 
@@ -224,14 +224,14 @@ static void print_mce(struct mce *m)
 		pr_cont("\n");
 	}
 
-	pr_emerg("TSC %llx ", m->tsc);
+	pr_emerg(HW_ERR "TSC %llx ", m->tsc);
 	if (m->addr)
 		pr_cont("ADDR %llx ", m->addr);
 	if (m->misc)
 		pr_cont("MISC %llx ", m->misc);
 
 	pr_cont("\n");
-	pr_emerg("PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
+	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
 
 	/*
@@ -241,16 +241,6 @@ static void print_mce(struct mce *m)
 	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
 }
 
-static void print_mce_head(void)
-{
-	pr_emerg("\nHARDWARE ERROR\n");
-}
-
-static void print_mce_tail(void)
-{
-	pr_emerg("This is not a software problem!\n");
-}
-
 #define PANIC_TIMEOUT 5 /* 5 seconds */
 
 static atomic_t mce_paniced;
@@ -291,7 +281,6 @@ static void mce_panic(char *msg, struct 
 		if (atomic_inc_return(&mce_fake_paniced) > 1)
 			return;
 	}
-	print_mce_head();
 	/* First print corrected ones that are still unlogged */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		struct mce *m = &mcelog.entry[i];
@@ -322,16 +311,15 @@ static void mce_panic(char *msg, struct 
 			apei_err = apei_write_mce(final);
 	}
 	if (cpu_missing)
-		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
-	print_mce_tail();
+		pr_emerg(HW_ERR "Some CPUs didn't answer in synchronization\n");
 	if (exp)
-		printk(KERN_EMERG "Machine check: %s\n", exp);
+		pr_emerg(HW_ERR "Machine check: %s\n", exp);
 	if (!fake_panic) {
 		if (panic_timeout == 0)
 			panic_timeout = mce_panic_timeout;
 		panic(msg);
 	} else
-		printk(KERN_EMERG "Fake kernel panic: %s\n", msg);
+		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
 }
 
 /* Support code for software error injection */
@@ -1221,7 +1209,7 @@ int mce_notify_irq(void)
 			schedule_work(&mce_trigger_work);
 
 		if (__ratelimit(&ratelimit))
-			printk(KERN_INFO "Machine check events logged\n");
+			pr_info(HW_ERR "Machine check events logged\n");
 
 		return 1;
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch

