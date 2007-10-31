From: akpm@linux-foundation.org
Subject: + uml-fix-spurious-irq-testing.patch added to -mm tree
Date: Wed, 31 Oct 2007 13:36:32 -0700
Message-ID: <200710312036.l9VKaWfA026969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbXJaUgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:36:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix spurious IRQ testing
has been added to the -mm tree.  Its filename is
     uml-fix-spurious-irq-testing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix spurious IRQ testing
From: Jeff Dike <jdike@addtoit.com>

The spurious IRQ testing in request_irq is mishandled in um_request_irq, which
sets the incoming file descriptors non-blocking only after request_irq
succeeds.  This results in the spurious irq calling read on a blocking
descriptor, and a hang.

Fixed by reversing the O_NONBLOCK setting and the request_irq call.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/irq.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/um/kernel/irq.c~uml-fix-spurious-irq-testing arch/um/kernel/irq.c
--- a/arch/um/kernel/irq.c~uml-fix-spurious-irq-testing
+++ a/arch/um/kernel/irq.c
@@ -347,14 +347,15 @@ int um_request_irq(unsigned int irq, int
 {
 	int err;
 
-	err = request_irq(irq, handler, irqflags, devname, dev_id);
-	if (err)
-		return err;
-
-	if (fd != -1)
+	if (fd != -1) {
 		err = activate_fd(irq, fd, type, dev_id);
-	return err;
+		if (err)
+			return err;
+	}
+
+	return request_irq(irq, handler, irqflags, devname, dev_id);
 }
+
 EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
