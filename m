From: akpm@linux-foundation.org
Subject: + uml-irq-locking-commentary.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:44:25 -0700
Message-ID: <200704070044.l370iPqB024025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785AbXDGAog (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: irq locking commentary
has been added to the -mm tree.  Its filename is
     uml-irq-locking-commentary.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
