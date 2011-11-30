From: akpm@linux-foundation.org
Subject: + kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:55:02 -0800
Message-ID: <201111302255.pAUMt2eK002361@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53816 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1K3WzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:55:13 -0500
Received: by eeuu44 with SMTP id u44so19270eeu.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:55:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, cmetcalf@tilera.com


The patch titled
     Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic()
has been added to the -mm tree.  Its filename is
     kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch

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
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic()

When two CPUs call panic at the same time there is a possible race
condition that can stop kdump.  The first CPU calls crash_kexec() and the
second CPU calls smp_send_stop() in panic() before crash_kexec() finished
on the first CPU.  So the second CPU stops the first CPU and therefore
kdump fails:

1st CPU:
panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump

2nd CPU:
panic()->crash_kexec()->kexec_mutex already held by 1st CPU
       ->smp_send_stop()-> stop 1st CPU (stop kdump)

This patch fixes the problem by introducing a spinlock in panic that
allows only one CPU to process crash_kexec() and the subsequent panic
code.

All other CPUs call the weak function panic_smp_self_stop() that stops the
CPU itself.  This function can be overloaded by architecture code.  For
example "tile" can use their lower-power "nap" instruction for that.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN kernel/panic.c~kdump-fix-crash_kexec-smp_send_stop-race-in-panic kernel/panic.c
--- a/kernel/panic.c~kdump-fix-crash_kexec-smp_send_stop-race-in-panic
+++ a/kernel/panic.c
@@ -49,6 +49,15 @@ static long no_blink(int state)
 long (*panic_blink)(int state);
 EXPORT_SYMBOL(panic_blink);
 
+/*
+ * Stop ourself in panic -- architecture code may override this
+ */
+void __weak panic_smp_self_stop(void)
+{
+	while (1)
+		cpu_relax();
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -59,6 +68,7 @@ EXPORT_SYMBOL(panic_blink);
  */
 void panic(const char *fmt, ...)
 {
+	static DEFINE_SPINLOCK(panic_lock);
 	static char buf[1024];
 	va_list args;
 	long i, i_next = 0;
@@ -68,8 +78,14 @@ void panic(const char *fmt, ...)
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
+	 *
+	 * Only one CPU is allowed to execute the panic code from here. For
+	 * multiple parallel invocations of panic, all other CPUs either
+	 * stop themself or will wait until they are stopped by the 1st CPU
+	 * with smp_send_stop().
 	 */
-	preempt_disable();
+	if (!spin_trylock(&panic_lock))
+		panic_smp_self_stop();
 
 	console_verbose();
 	bust_spinlocks(1);
_
Subject: Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic()

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

linux-next.patch
kdump-add-missing-ram-resource-in-crash_shrink_memory.patch
kdump-add-udev-events-for-memory-online-offline.patch
kdump-crashk_res-init-check-for-sys-kernel-kexec_crash_size.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch

