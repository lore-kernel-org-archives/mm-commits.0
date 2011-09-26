From: akpm@google.com
Subject: + alpha-wire-up-sendmmsg-syscall.patch added to -mm tree
Date: Mon, 26 Sep 2011 15:19:54 -0700
Message-ID: <201109262219.p8QMJtoe010432@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:27500 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1IZWUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2011 18:20:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcree@orcon.net.nz, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     Subject: alpha: wire up sendmmsg syscall
has been added to the -mm tree.  Its filename is
     alpha-wire-up-sendmmsg-syscall.patch

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
From: Michael Cree <mcree@orcon.net.nz>
Subject: alpha: wire up sendmmsg syscall

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Reviewed-by: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/alpha/include/asm/unistd.h |    3 ++-
 arch/alpha/kernel/systbls.S     |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/unistd.h~alpha-wire-up-sendmmsg-syscall arch/alpha/include/asm/unistd.h
--- a/arch/alpha/include/asm/unistd.h~alpha-wire-up-sendmmsg-syscall
+++ a/arch/alpha/include/asm/unistd.h
@@ -458,10 +458,11 @@
 #define __NR_syncfs			500
 #define __NR_setns			501
 #define __NR_accept4			502
+#define __NR_sendmmsg			503
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			503
+#define NR_SYSCALLS			504
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN arch/alpha/kernel/systbls.S~alpha-wire-up-sendmmsg-syscall arch/alpha/kernel/systbls.S
--- a/arch/alpha/kernel/systbls.S~alpha-wire-up-sendmmsg-syscall
+++ a/arch/alpha/kernel/systbls.S
@@ -521,6 +521,7 @@ sys_call_table:
 	.quad sys_syncfs			/* 500 */
 	.quad sys_setns
 	.quad sys_accept4
+	.quad sys_sendmmsg
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
_
Subject: Subject: alpha: wire up sendmmsg syscall

Patches currently in -mm which might be from mcree@orcon.net.nz are

origin.patch
alpha-wire-up-accept4-syscall.patch
alpha-wire-up-sendmmsg-syscall.patch

