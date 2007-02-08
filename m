From: akpm@linux-foundation.org
Subject: - add-i386-idle-notifier-take-3-fix.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:50 -0800
Message-ID: <200702082152.l18LqoUg027665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423484AbXBHV7Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:59:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eranian@hpl.hp.com, mm-commits@vger.kernel.org


The patch titled
     add i386 idle notifier (take 3) (fix)
has been removed from the -mm tree.  Its filename was
     add-i386-idle-notifier-take-3-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add i386 idle notifier (take 3) (fix)
From: Stephane Eranian <eranian@hpl.hp.com>

- do not export i386 idle notification registration entry points because
  there is currently no user for this

- make it more explicit that the store to idle_state must be atomic

Signed-off-by: stephane eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/process.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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

git-ia64.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
