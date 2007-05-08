From: akpm@linux-foundation.org
Subject: - uml-irq-locking-commentary.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:53 -0700
Message-ID: <200705080006.l4806rRA009233@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967371AbXEHAHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: irq locking commentary
has been removed from the -mm tree.  Its filename was
     uml-irq-locking-commentary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: irq locking commentary
From: Jeff Dike <jdike@addtoit.com>

Locking commentary.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/irq.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN arch/um/kernel/irq.c~uml-irq-locking-commentary arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-irq-locking-commentary
+++ a/arch/um/kernel/irq.c
@@ -78,6 +78,14 @@ skip:
 	return 0;
 }
 
+/*
+ * This list is accessed under irq_lock, except in sigio_handler,
+ * where it is safe from being modified.  IRQ handlers won't change it -
+ * if an IRQ source has vanished, it will be freed by free_irqs just
+ * before returning from sigio_handler.  That will process a separate
+ * list of irqs to free, with its own locking, coming back here to
+ * remove list elements, taking the irq_lock to do so.
+ */
 static struct irq_fd *active_fds = NULL;
 static struct irq_fd **last_irq_ptr = &active_fds;
 
@@ -243,6 +251,7 @@ void free_irq_by_fd(int fd)
 	free_irq_by_cb(same_fd, &fd);
 }
 
+/* Must be called with irq_lock held */
 static struct irq_fd *find_irq_by_fd(int fd, int irqnum, int *index_out)
 {
 	struct irq_fd *irq;
@@ -308,6 +317,12 @@ void deactivate_fd(int fd, int irqnum)
 	ignore_sigio_fd(fd);
 }
 
+/*
+ * Called just before shutdown in order to provide a clean exec
+ * environment in case the system is rebooting.  No locking because
+ * that would cause a pointless shutdown hang if something hadn't
+ * released the lock.
+ */
 int deactivate_all_fds(void)
 {
 	struct irq_fd *irq;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
