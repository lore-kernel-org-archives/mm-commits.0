From: akpm@linux-foundation.org
Subject: + uml-activate_fd-return-enomem-only-when-appropriate.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:26:37 -0800
Message-ID: <200703060426.l264QbvB011757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50210 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947AbXCFE0k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:26:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@addtoit.com


The patch titled
     uml: activate_fd: return ENOMEM only when appropriate
has been added to the -mm tree.  Its filename is
     uml-activate_fd-return-enomem-only-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: activate_fd: return ENOMEM only when appropriate
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid returning ENOMEM in case of a duplicate IRQ - ENOMEM was saved into err
earlier.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/irq.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/kernel/irq.c~uml-activate_fd-return-enomem-only-when-appropriate arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-activate_fd-return-enomem-only-when-appropriate
+++ a/arch/um/kernel/irq.c
@@ -142,6 +142,7 @@ int activate_fd(int irq, int fd, int typ
 				     .events 		= events,
 				     .current_events 	= 0 } );
 
+	err = -EBUSY;
 	spin_lock_irqsave(&irq_lock, flags);
 	for (irq_fd = active_fds; irq_fd != NULL; irq_fd = irq_fd->next) {
 		if ((irq_fd->fd == fd) && (irq_fd->type == type)) {
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
git-gccbug.patch
