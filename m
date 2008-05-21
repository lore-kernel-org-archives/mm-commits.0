From: akpm@linux-foundation.org
Subject: + kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch added to -mm tree
Date: Wed, 21 May 2008 14:56:04 -0700
Message-ID: <200805212156.m4LLu4Ne002715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937294AbYEUV4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 17:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kernel/irq/manage.c: replace a printk + WARN_ON() to a WARN()
has been added to the -mm tree.  Its filename is
     kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch

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
Subject: kernel/irq/manage.c: replace a printk + WARN_ON() to a WARN()
From: Arjan van de Ven <arjan@linux.intel.com>

Replace a printk+WARN_ON() by a WARN(); this increases the chance of the
string making it into the bugreport (ie: it goes inside the
---[ cut here ]--- section)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/irq/manage.c~kernel-irq-managec-replace-a-printk-warn_on-to-a-warn kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-irq-managec-replace-a-printk-warn_on-to-a-warn
+++ a/kernel/irq/manage.c
@@ -224,9 +224,7 @@ int set_irq_wake(unsigned int irq, unsig
 			set_wake = NULL;
 	} else {
 		if (desc->wake_depth == 0) {
-			printk(KERN_WARNING "Unbalanced IRQ %d "
-					"wake disable\n", irq);
-			WARN_ON(1);
+			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0)
 			desc->status &= ~IRQ_WAKEUP;
 		else
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
rename-warn-to-warning-to-clear-the-namespace.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch

