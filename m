From: akpm@linux-foundation.org
Subject: [to-be-updated] kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch removed from -mm tree
Date: Mon, 28 Nov 2011 14:11:59 -0800
Message-ID: <201111282212.pASMBxmk013252@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:59866 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1K1WME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 17:12:04 -0500
Received: by qyk15 with SMTP id 15so356700qyk.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 14:12:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holzheu@linux.vnet.ibm.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic
has been removed from the -mm tree.  Its filename was
     kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch

This patch was dropped because an updated version will be merged

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
Acked-by: Vivek Goyal <vgoyal@redhat.com>
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
 void panic(const char *fmt, ...)
 {
+	static DEFINE_SPINLOCK(panic_lock);
 	static char buf[1024];
 	va_list args;
 	long i, i_next = 0;
@@ -82,6 +83,13 @@ void panic(const char *fmt, ...)
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

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

linux-next.patch
kdump-add-missing-ram-resource-in-crash_shrink_memory.patch
kdump-add-udev-events-for-memory-online-offline.patch

