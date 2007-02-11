From: akpm@linux-foundation.org
Subject: - order-of-lockdep-off-on-in-vprintk-should-be-changed.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:05 -0800
Message-ID: <200702112255.l1BMt5BX016293@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60573 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853AbXBKWzR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: compudj@krystal.dyndns.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     order of lockdep off/on in vprintk() should be changed
has been removed from the -mm tree.  Its filename was
     order-of-lockdep-off-on-in-vprintk-should-be-changed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: order of lockdep off/on in vprintk() should be changed
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

The order of locking between lockdep_off/on() and local_irq_save/restore() in
vprintk() should be changed.

* In kernel/printk.c :

vprintk() does :

preempt_disable()
local_irq_save()
lockdep_off()
spin_lock(&logbuf_lock)
spin_unlock(&logbuf_lock)
if(!down_trylock(&console_sem))
   up(&console_sem)
lockdep_on()
local_irq_restore()
preempt_enable()

The goals here is to make sure we do not call printk() recursively from
kernel/lockdep.c:__lock_acquire() (called from spin_* and down/up) nor from
kernel/lockdep.c:trace_hardirqs_on/off() (called from local_irq_restore/save).
It can then potentially call printk() through mark_held_locks/mark_lock.

It correctly protects against the spin_lock call and the up/down call, but it
does not protect against local_irq_restore. It could cause infinite recursive
printk/trace_hardirqs_on() calls when printk() is called from the
mark_lock() error handing path.

We should change the locking so it becomes correct :

preempt_disable()
lockdep_off()
local_irq_save()
spin_lock(&logbuf_lock)
spin_unlock(&logbuf_lock)
if(!down_trylock(&console_sem))
   up(&console_sem)
local_irq_restore()
lockdep_on()
preempt_enable()

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk.c~order-of-lockdep-off-on-in-vprintk-should-be-changed kernel/printk.c
--- a/kernel/printk.c~order-of-lockdep-off-on-in-vprintk-should-be-changed
+++ a/kernel/printk.c
@@ -529,7 +529,7 @@ asmlinkage int vprintk(const char *fmt, 
 		zap_locks();
 
 	/* This stops the holder of console_sem just where we want him */
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	lockdep_off();
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
@@ -618,7 +618,7 @@ asmlinkage int vprintk(const char *fmt, 
 			up(&console_sem);
 		}
 		lockdep_on();
-		local_irq_restore(flags);
+		raw_local_irq_restore(flags);
 	} else {
 		/*
 		 * Someone else owns the drivers.  We drop the spinlock, which
@@ -628,7 +628,7 @@ asmlinkage int vprintk(const char *fmt, 
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
 		lockdep_on();
-		local_irq_restore(flags);
+		raw_local_irq_restore(flags);
 	}
 
 	preempt_enable();
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are

origin.patch
