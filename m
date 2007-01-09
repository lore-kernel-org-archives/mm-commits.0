From: akpm@osdl.org
Subject: + add-i386-idle-notifier-take-3-fix.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:14:47 -0800
Message-ID: <200701092114.l09LElXW015442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44923 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbXAIVVN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:21:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eranian@hpl.hp.com


The patch titled
     add i386 idle notifier (take 3) (fix)
has been added to the -mm tree.  Its filename is
     add-i386-idle-notifier-take-3-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add i386 idle notifier (take 3) (fix)
From: Stephane Eranian <eranian@hpl.hp.com>

- do not export i386 idle notification registration entry points because
  there is currently no user for this

- make it more explicit that the store to idle_state must be atomic

Signed-off-by: stephane eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/process.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/process.c~add-i386-idle-notifier-take-3-fix arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~add-i386-idle-notifier-take-3-fix
+++ a/arch/i386/kernel/process.c
@@ -87,19 +87,18 @@ void idle_notifier_register(struct notif
 {
 	atomic_notifier_chain_register(&idle_notifier, n);
 }
-EXPORT_SYMBOL_GPL(idle_notifier_register);
 
 void idle_notifier_unregister(struct notifier_block *n)
 {
 	atomic_notifier_chain_unregister(&idle_notifier, n);
 }
-EXPORT_SYMBOL(idle_notifier_unregister);
 
 static DEFINE_PER_CPU(volatile unsigned long, idle_state);
 
 void enter_idle(void)
 {
-	__get_cpu_var(idle_state) = 1;
+	/* needs to be atomic w.r.t. interrupts, not against other CPUs */
+	__set_bit(0, &__get_cpu_var(idle_state));
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
_

Patches currently in -mm which might be from eranian@hpl.hp.com are

add-i386-idle-notifier-take-3.patch
add-i386-idle-notifier-take-3-fix.patch
