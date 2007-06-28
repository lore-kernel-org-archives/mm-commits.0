From: akpm@linux-foundation.org
Subject: + s390-rename-cpu_idle-to-s390_cpu_idle.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:11:49 -0700
Message-ID: <200706282211.l5SMBnE6002635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757727AbXF1WML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com


The patch titled
     s390: rename CPU_IDLE to S390_CPU_IDLE
has been added to the -mm tree.  Its filename is
     s390-rename-cpu_idle-to-s390_cpu_idle.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s390: rename CPU_IDLE to S390_CPU_IDLE
From: Heiko Carstens <heiko.carstens@de.ibm.com>

sched-cfs-v2.6.22-git-v18.patch introduces CPU_IDLE in sched.h.
This conflict with the already existing define in
include/asm-s390/processor.h
Just rename the s390 defines, since they will go away as soon as
we support CONFIG_NO_HZ instead of our own CONFIG_NO_IDLE_HZ.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/process.c   |    6 +++---
 arch/s390/kernel/time.c      |    4 ++--
 arch/s390/kernel/vtime.c     |    4 ++--
 include/asm-s390/processor.h |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/s390/kernel/process.c~s390-rename-cpu_idle-to-s390_cpu_idle arch/s390/kernel/process.c
--- a/arch/s390/kernel/process.c~s390-rename-cpu_idle-to-s390_cpu_idle
+++ a/arch/s390/kernel/process.c
@@ -93,8 +93,8 @@ void do_monitor_call(struct pt_regs *reg
 	/* disable monitor call class 0 */
 	__ctl_clear_bit(8, 15);
 
-	atomic_notifier_call_chain(&idle_chain, CPU_NOT_IDLE,
-			    (void *)(long) smp_processor_id());
+	atomic_notifier_call_chain(&idle_chain, S390_CPU_NOT_IDLE,
+				   (void *)(long) smp_processor_id());
 }
 
 extern void s390_handle_mcck(void);
@@ -115,7 +115,7 @@ static void default_idle(void)
 	}
 
 	rc = atomic_notifier_call_chain(&idle_chain,
-			CPU_IDLE, (void *)(long) cpu);
+					S390_CPU_IDLE, (void *)(long) cpu);
 	if (rc != NOTIFY_OK && rc != NOTIFY_DONE)
 		BUG();
 	if (rc != NOTIFY_OK) {
diff -puN arch/s390/kernel/time.c~s390-rename-cpu_idle-to-s390_cpu_idle arch/s390/kernel/time.c
--- a/arch/s390/kernel/time.c~s390-rename-cpu_idle-to-s390_cpu_idle
+++ a/arch/s390/kernel/time.c
@@ -226,10 +226,10 @@ static int nohz_idle_notify(struct notif
 			    unsigned long action, void *hcpu)
 {
 	switch (action) {
-	case CPU_IDLE:
+	case S390_CPU_IDLE:
 		stop_hz_timer();
 		break;
-	case CPU_NOT_IDLE:
+	case S390_CPU_NOT_IDLE:
 		start_hz_timer();
 		break;
 	}
diff -puN arch/s390/kernel/vtime.c~s390-rename-cpu_idle-to-s390_cpu_idle arch/s390/kernel/vtime.c
--- a/arch/s390/kernel/vtime.c~s390-rename-cpu_idle-to-s390_cpu_idle
+++ a/arch/s390/kernel/vtime.c
@@ -545,10 +545,10 @@ static int vtimer_idle_notify(struct not
 			      unsigned long action, void *hcpu)
 {
 	switch (action) {
-	case CPU_IDLE:
+	case S390_CPU_IDLE:
 		stop_cpu_timer();
 		break;
-	case CPU_NOT_IDLE:
+	case S390_CPU_NOT_IDLE:
 		start_cpu_timer();
 		break;
 	}
diff -puN include/asm-s390/processor.h~s390-rename-cpu_idle-to-s390_cpu_idle include/asm-s390/processor.h
--- a/include/asm-s390/processor.h~s390-rename-cpu_idle-to-s390_cpu_idle
+++ a/include/asm-s390/processor.h
@@ -357,8 +357,8 @@ extern void (*s390_base_ext_handler_fn)(
 /*
  * CPU idle notifier chain.
  */
-#define CPU_IDLE	0
-#define CPU_NOT_IDLE	1
+#define S390_CPU_IDLE		0
+#define S390_CPU_NOT_IDLE	1
 
 struct notifier_block;
 int register_idle_notifier(struct notifier_block *nb);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-acpi-s390-struct-bin_attribute-changes.patch
git-s390.patch
s390-rename-cpu_idle-to-s390_cpu_idle.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
scsi-dont-build-scsi_dma_mapunmap-for-has_dma-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
check_signature-needs-readb.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
fallocate-on-s390.patch
