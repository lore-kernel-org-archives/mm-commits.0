From: akpm@linux-foundation.org
Subject: [merged] goku_udc-potential-null-dereference.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:09:14 -0400
Message-ID: <201003181809.o2II9tL7007604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab0CRSKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     goku_udc: potential null dereference
has been removed from the -mm tree.  Its filename was
     goku_udc-potential-null-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: goku_udc: potential null dereference
From: Dan Carpenter <error27@gmail.com>

"dev" is always null here.  In the end it's only used to get the
pci_name() of "pdev" which is redundant information and so I removed it.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/goku_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/gadget/goku_udc.c~goku_udc-potential-null-dereference drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~goku_udc-potential-null-dereference
+++ a/drivers/usb/gadget/goku_udc.c
@@ -1768,7 +1768,7 @@ static int goku_probe(struct pci_dev *pd
 	 * usb_gadget_driver_{register,unregister}() must change.
 	 */
 	if (the_controller) {
-		WARNING(dev, "ignoring %s\n", pci_name(pdev));
+		pr_warning("ignoring %s\n", pci_name(pdev));
 		return -EBUSY;
 	}
 	if (!pdev->irq) {
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
memcontrol-fix-potential-null-deref.patch
linux-next.patch
dpt_i20-several-use-after-free-issues.patch
i915-fix-small-leak-on-error-path.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch

