From: akpm@linux-foundation.org
Subject: + kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch added to -mm tree
Date: Fri, 28 Oct 2011 16:11:52 -0700
Message-ID: <201110282311.p9SNBqVX025391@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:43458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1J1XMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 19:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, vgoyal@redhat.com


The patch titled
     Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic
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
Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic

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

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/panic.c~kdump-fix-crash_kexec-smp_send_stop-race-in-panic kernel/panic.c
--- a/kernel/panic.c~kdump-fix-crash_kexec-smp_send_stop-race-in-panic
+++ a/kernel/panic.c
@@ -59,6 +59,7 @@ EXPORT_SYMBOL(panic_blink);
  */
 NORET_TYPE void panic(const char * fmt, ...)
 {
+	static DEFINE_SPINLOCK(panic_lock);
 	static char buf[1024];
 	va_list args;
 	long i, i_next = 0;
@@ -82,6 +83,13 @@ NORET_TYPE void panic(const char * fmt, 
 #endif
 
 	/*
+	 * Only one CPU is allowed to execute the panic code from here. For
+	 * multiple parallel invocations of panic all other CPUs will wait on
+	 * the panic_lock. They are stopped afterwards by smp_send_stop().
+	 */
+	spin_lock(&panic_lock);
+
+	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
 	 * Do we want to call this before we try to display a message?
_
Subject: Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

linux-next.patch
lib-stringc-fix-strim-semantics-for-strings-that-have-only-blanks.patch
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch
kdump-add-udev-events-for-memory-online-offline.patch

