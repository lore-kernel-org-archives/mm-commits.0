From: akpm@osdl.org
Subject: + order-of-lockdep-off-on-in-vprintk-should-be-changed.patch added to -mm tree
Date: Thu, 25 Jan 2007 00:15:01 -0800
Message-ID: <200701250815.l0P8F1D9009977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965697AbXAYIPV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 03:15:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: compudj@krystal.dyndns.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu


The patch titled
     order of lockdep off/on in vprintk() should be changed
has been added to the -mm tree.  Its filename is
     order-of-lockdep-off-on-in-vprintk-should-be-changed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk.c~order-of-lockdep-off-on-in-vprintk-should-be-changed kernel/printk.c
--- a/kernel/printk.c~order-of-lockdep-off-on-in-vprintk-should-be-changed
+++ a/kernel/printk.c
@@ -529,8 +529,8 @@ asmlinkage int vprintk(const char *fmt, 
 		zap_locks();
 
 	/* This stops the holder of console_sem just where we want him */
-	local_irq_save(flags);
 	lockdep_off();
+	local_irq_save(flags);
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
 
@@ -617,8 +617,8 @@ asmlinkage int vprintk(const char *fmt, 
 			console_locked = 0;
 			up(&console_sem);
 		}
-		lockdep_on();
 		local_irq_restore(flags);
+		lockdep_on();
 	} else {
 		/*
 		 * Someone else owns the drivers.  We drop the spinlock, which
@@ -627,8 +627,8 @@ asmlinkage int vprintk(const char *fmt, 
 		 */
 		printk_cpu = UINT_MAX;
 		spin_unlock(&logbuf_lock);
-		lockdep_on();
 		local_irq_restore(flags);
+		lockdep_on();
 	}
 
 	preempt_enable();
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are

order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
