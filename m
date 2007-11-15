From: akpm@linux-foundation.org
Subject: - uml-fix-spurious-irq-testing.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:58 -0800
Message-ID: <200711152110.lAFLAwId015711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761329AbXKOVRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix spurious IRQ testing
has been removed from the -mm tree.  Its filename was
     uml-fix-spurious-irq-testing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
