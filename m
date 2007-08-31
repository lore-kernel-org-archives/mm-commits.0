From: akpm@linux-foundation.org
Subject: - request_irq-fix-debug_shirq-handling-re-2623-rc2-mm1-rtl8139-inconsistent-lock-state.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:18 -0700
Message-ID: <200708311656.l7VGuIsF017475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760793AbXHaQ4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     request_irq: fix DEBUG_SHIRQ handling
has been removed from the -mm tree.  Its filename was
     request_irq-fix-debug_shirq-handling-re-2623-rc2-mm1-rtl8139-inconsistent-lock-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: request_irq: fix DEBUG_SHIRQ handling
From: Jarek Poplawski <jarkao2@o2.pl>

Mariusz Kozlowski reported lockdep's warning:

> =================================
> [ INFO: inconsistent lock state ]
> 2.6.23-rc2-mm1 #7
> ---------------------------------
> inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> ifconfig/5492 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&tp->lock){+...}, at: [<de8706e0>] rtl8139_interrupt+0x27/0x46b [8139too]
> {in-hardirq-W} state was registered at:
>   [<c0138eeb>] __lock_acquire+0x949/0x11ac
>   [<c01397e7>] lock_acquire+0x99/0xb2
>   [<c0452ff3>] _spin_lock+0x35/0x42
>   [<de8706e0>] rtl8139_interrupt+0x27/0x46b [8139too]
>   [<c0147a5d>] handle_IRQ_event+0x28/0x59
>   [<c01493ca>] handle_level_irq+0xad/0x10b
>   [<c0105a13>] do_IRQ+0x93/0xd0
>   [<c010441e>] common_interrupt+0x2e/0x34
...
> other info that might help us debug this:
> 1 lock held by ifconfig/5492:
>  #0:  (rtnl_mutex){--..}, at: [<c0451778>] mutex_lock+0x1c/0x1f
>
> stack backtrace:
...
>  [<c0452ff3>] _spin_lock+0x35/0x42
>  [<de8706e0>] rtl8139_interrupt+0x27/0x46b [8139too]
>  [<c01480fd>] free_irq+0x11b/0x146
>  [<de871d59>] rtl8139_close+0x8a/0x14a [8139too]
>  [<c03bde63>] dev_close+0x57/0x74
...

This shows that a driver's irq handler was running both in hard interrupt
and process contexts with irqs enabled. The latter was done during
free_irq() call and was possible only with CONFIG_DEBUG_SHIRQ enabled.
This was fixed by another patch.

But similar problem is possible with request_irq(): any locks taken from
irq handler could be vulnerable - especially with soft interrupts. This
patch fixes it by disabling local interrupts during handler's run. (It
seems, disabling softirqs should be enough, but it needs more checking
on possible races or other special cases).

Reported-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/irq/manage.c~request_irq-fix-debug_shirq-handling-re-2623-rc2-mm1-rtl8139-inconsistent-lock-state kernel/irq/manage.c
--- a/kernel/irq/manage.c~request_irq-fix-debug_shirq-handling-re-2623-rc2-mm1-rtl8139-inconsistent-lock-state
+++ a/kernel/irq/manage.c
@@ -547,14 +547,11 @@ int request_irq(unsigned int irq, irq_ha
 		 * We do this before actually registering it, to make sure that
 		 * a 'real' IRQ doesn't run in parallel with our fake
 		 */
-		if (irqflags & IRQF_DISABLED) {
-			unsigned long flags;
+		unsigned long flags;
 
-			local_irq_save(flags);
-			handler(irq, dev_id);
-			local_irq_restore(flags);
-		} else
-			handler(irq, dev_id);
+		local_irq_save(flags);
+		handler(irq, dev_id);
+		local_irq_restore(flags);
 	}
 #endif
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
