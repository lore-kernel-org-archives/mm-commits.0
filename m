From: akpm@linux-foundation.org
Subject: - uml-activate_fd-return-enomem-only-when-appropriate.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:09 -0800
Message-ID: <200703152156.l2FLu9Kp027525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42245 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXCOV4L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: activate_fd: return ENOMEM only when appropriate
has been removed from the -mm tree.  Its filename was
     uml-activate_fd-return-enomem-only-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: activate_fd: return ENOMEM only when appropriate
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid returning ENOMEM in case of a duplicate IRQ - ENOMEM was saved into err
earlier.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
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
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
