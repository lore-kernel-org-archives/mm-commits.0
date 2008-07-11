From: akpm@linux-foundation.org
Subject: + use-warn-in-kernel-irq-managec.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:13 -0700
Message-ID: <200807111850.m6BIoseh031277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757210AbYGKSvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Use WARN() in kernel/irq/manage.c
has been added to the -mm tree.  Its filename is
     use-warn-in-kernel-irq-managec.patch

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
Subject: Use WARN() in kernel/irq/manage.c
From: Arjan van de Ven <arjan@linux.intel.com>

Replace a printk+WARN_ON() by a WARN(); this increases the chance of the
string making it into the bugreport (ie: it goes inside the
---[ cut here ]--- section)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/irq/manage.c~use-warn-in-kernel-irq-managec kernel/irq/manage.c
--- a/kernel/irq/manage.c~use-warn-in-kernel-irq-managec
+++ a/kernel/irq/manage.c
@@ -177,8 +177,7 @@ static void __enable_irq(struct irq_desc
 {
 	switch (desc->depth) {
 	case 0:
-		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

