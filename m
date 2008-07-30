From: akpm@linux-foundation.org
Subject: + remove-the-deprecated-cli-sti-functions.patch added to -mm tree
Date: Wed, 30 Jul 2008 02:50:44 -0700
Message-ID: <200807300950.m6U9oi6d019608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbYG3JvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 05:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.asselstine@windriver.com, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, willy@linux.intel.com


The patch titled
     Remove the deprecated cli() sti() functions
has been added to the -mm tree.  Its filename is
     remove-the-deprecated-cli-sti-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove the deprecated cli() sti() functions
From: Mark Asselstine <mark.asselstine@windriver.com>

These functions have been deprecated for some time now but remained until
all legacy callers could be removed.  With a few commits in 2.6.26 this
has happened so now we can remove these deprecated functions.

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX            |    2 
 Documentation/cli-sti-removal.txt |  133 ----------------------------
 include/linux/interrupt.h         |   29 ------
 3 files changed, 164 deletions(-)

diff -puN Documentation/00-INDEX~remove-the-deprecated-cli-sti-functions Documentation/00-INDEX
--- a/Documentation/00-INDEX~remove-the-deprecated-cli-sti-functions
+++ a/Documentation/00-INDEX
@@ -89,8 +89,6 @@ cciss.txt
 	- info, major/minor #'s for Compaq's SMART Array Controllers.
 cdrom/
 	- directory with information on the CD-ROM drivers that Linux has.
-cli-sti-removal.txt
-	- cli()/sti() removal guide.
 computone.txt
 	- info on Computone Intelliport II/Plus Multiport Serial Driver.
 connector/
diff -puN Documentation/cli-sti-removal.txt~remove-the-deprecated-cli-sti-functions /dev/null
--- a/Documentation/cli-sti-removal.txt
+++ /dev/null
@@ -1,133 +0,0 @@
-
-#### cli()/sti() removal guide, started by Ingo Molnar <mingo@redhat.com>
-
-
-as of 2.5.28, five popular macros have been removed on SMP, and
-are being phased out on UP:
-
- cli(), sti(), save_flags(flags), save_flags_cli(flags), restore_flags(flags)
-
-until now it was possible to protect driver code against interrupt
-handlers via a cli(), but from now on other, more lightweight methods
-have to be used for synchronization, such as spinlocks or semaphores.
-
-for example, driver code that used to do something like:
-
-	struct driver_data;
-
-	irq_handler (...)
-	{
-		....
-		driver_data.finish = 1;
-		driver_data.new_work = 0;
-		....
-	}
-
-	...
-
-	ioctl_func (...)
-	{
-		...
-		cli();
-		...
-		driver_data.finish = 0;
-		driver_data.new_work = 2;
-		...
-		sti();
-		...
-	}
-
-was SMP-correct because the cli() function ensured that no
-interrupt handler (amongst them the above irq_handler()) function
-would execute while the cli()-ed section is executing.
-
-but from now on a more direct method of locking has to be used:
-
-	DEFINE_SPINLOCK(driver_lock);
-	struct driver_data;
-
-	irq_handler (...)
-	{
-		unsigned long flags;
-		....
-		spin_lock_irqsave(&driver_lock, flags);
-		....
-		driver_data.finish = 1;
-		driver_data.new_work = 0;
-		....
-		spin_unlock_irqrestore(&driver_lock, flags);
-		....
-	}
-
-	...
-
-	ioctl_func (...)
-	{
-		...
-		spin_lock_irq(&driver_lock);
-		...
-		driver_data.finish = 0;
-		driver_data.new_work = 2;
-		...
-		spin_unlock_irq(&driver_lock);
-		...
-	}
-
-the above code has a number of advantages:
-
-- the locking relation is easier to understand - actual lock usage
-  pinpoints the critical sections. cli() usage is too opaque.
-  Easier to understand means it's easier to debug.
-
-- it's faster, because spinlocks are faster to acquire than the
-  potentially heavily-used IRQ lock. Furthermore, your driver does
-  not have to wait eg. for a big heavy SCSI interrupt to finish,
-  because the driver_lock spinlock is only used by your driver.
-  cli() on the other hand was used by many drivers, and extended
-  the critical section to the whole IRQ handler function - creating
-  serious lock contention.
-
- 
-to make the transition easier, we've still kept the cli(), sti(),
-save_flags(), save_flags_cli() and restore_flags() macros defined
-on UP systems - but their usage will be phased out until 2.6 is
-released.
-
-drivers that want to disable local interrupts (interrupts on the
-current CPU), can use the following five macros:
-
-  local_irq_disable(), local_irq_enable(), local_save_flags(flags),
-  local_irq_save(flags), local_irq_restore(flags)
-
-but beware, their meaning and semantics are much simpler, far from
-that of the old cli(), sti(), save_flags(flags) and restore_flags(flags)
-SMP meaning:
-
-    local_irq_disable()       => turn local IRQs off
-
-    local_irq_enable()        => turn local IRQs on
-
-    local_save_flags(flags)   => save the current IRQ state into flags. The
-                                 state can be on or off. (on some
-                                 architectures there's even more bits in it.)
-
-    local_irq_save(flags)     => save the current IRQ state into flags and
-                                 disable interrupts.
-
-    local_irq_restore(flags)  => restore the IRQ state from flags.
-
-(local_irq_save can save both irqs on and irqs off state, and
-local_irq_restore can restore into both irqs on and irqs off state.)
-
-another related change is that synchronize_irq() now takes a parameter:
-synchronize_irq(irq). This change too has the purpose of making SMP
-synchronization more lightweight - this way you can wait for your own
-interrupt handler to finish, no need to wait for other IRQ sources.
-
-
-why were these changes done? The main reason was the architectural burden
-of maintaining the cli()/sti() interface - it became a real problem. The
-new interrupt system is much more streamlined, easier to understand, debug,
-and it's also a bit faster - the same happened to it that will happen to
-cli()/sti() using drivers once they convert to spinlocks :-)
-
diff -puN include/linux/interrupt.h~remove-the-deprecated-cli-sti-functions include/linux/interrupt.h
--- a/include/linux/interrupt.h~remove-the-deprecated-cli-sti-functions
+++ a/include/linux/interrupt.h
@@ -223,35 +223,6 @@ static inline int disable_irq_wake(unsig
 #define or_softirq_pending(x)  (local_softirq_pending() |= (x))
 #endif
 
-/*
- * Temporary defines for UP kernels, until all code gets fixed.
- */
-#ifndef CONFIG_SMP
-static inline void __deprecated cli(void)
-{
-	local_irq_disable();
-}
-static inline void __deprecated sti(void)
-{
-	local_irq_enable();
-}
-static inline void __deprecated save_flags(unsigned long *x)
-{
-	local_save_flags(*x);
-}
-#define save_flags(x) save_flags(&x)
-static inline void __deprecated restore_flags(unsigned long x)
-{
-	local_irq_restore(x);
-}
-
-static inline void __deprecated save_and_cli(unsigned long *x)
-{
-	local_irq_save(*x);
-}
-#define save_and_cli(x)	save_and_cli(&x)
-#endif /* CONFIG_SMP */
