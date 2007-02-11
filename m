From: akpm@linux-foundation.org
Subject: - uml-irq-handler-tidying.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:31 -0800
Message-ID: <200702112249.l1BMnVOV015760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59876 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709AbXBKWtd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: IRQ handler tidying
has been removed from the -mm tree.  Its filename was
     uml-irq-handler-tidying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: IRQ handler tidying
From: Jeff Dike <jdike@addtoit.com>

Tidying the irq code -
	make a variable static
	activate_fd can call kmalloc directly since it's now kernel code
	added a no-locking comment
	fixed a style violation

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/irq.c   |    7 +++----
 arch/um/os-Linux/irq.c |    6 +++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/um/kernel/irq.c~uml-irq-handler-tidying arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-irq-handler-tidying
+++ a/arch/um/kernel/irq.c
@@ -79,7 +79,7 @@ skip:
 	return 0;
 }
 
-struct irq_fd *active_fds = NULL;
+static struct irq_fd *active_fds = NULL;
 static struct irq_fd **last_irq_ptr = &active_fds;
 
 extern void free_irqs(void);
@@ -124,8 +124,8 @@ int activate_fd(int irq, int fd, int typ
 	if (err < 0)
 		goto out;
 
-	new_fd = um_kmalloc(sizeof(*new_fd));
 	err = -ENOMEM;
+	new_fd = kmalloc(sizeof(struct irq_fd), GFP_KERNEL);
 	if (new_fd == NULL)
 		goto out;
 
@@ -176,9 +176,8 @@ int activate_fd(int irq, int fd, int typ
 		 */
 		spin_unlock_irqrestore(&irq_lock, flags);
 		kfree(tmp_pfd);
-		tmp_pfd = NULL;
 
-		tmp_pfd = um_kmalloc(n);
+		tmp_pfd = kmalloc(n, GFP_KERNEL);
 		if (tmp_pfd == NULL)
 			goto out_kfree;
 
diff -puN arch/um/os-Linux/irq.c~uml-irq-handler-tidying arch/um/os-Linux/irq.c
--- a/arch/um/os-Linux/irq.c~uml-irq-handler-tidying
+++ a/arch/um/os-Linux/irq.c
@@ -20,6 +20,10 @@
 #include "os.h"
 #include "um_malloc.h"
 
+/*
+ * Locked by irq_lock in arch/um/kernel/irq.c.  Changed by os_create_pollfd
+ * and os_free_irq_by_cb, which are called under irq_lock.
+ */
 static struct pollfd *pollfds = NULL;
 static int pollfds_num = 0;
 static int pollfds_size = 0;
@@ -58,7 +62,7 @@ int os_create_pollfd(int fd, int events,
 	if (pollfds_num == pollfds_size) {
 		if (size_tmpfds <= pollfds_size * sizeof(pollfds[0])) {
 			/* return min size needed for new pollfds area */
-			return((pollfds_size + 1) * sizeof(pollfds[0]));
+			return (pollfds_size + 1) * sizeof(pollfds[0]);
 		}
 
 		if (pollfds != NULL) {
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
