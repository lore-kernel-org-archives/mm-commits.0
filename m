From: akpm@linux-foundation.org
Subject: + goku_udc-potential-null-dereference.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:12:25 -0800
Message-ID: <201003122212.o2CMCPtM011006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758703Ab0CLWMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:12:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, david-b@pacbell.net, greg@kroah.com


The patch titled
     goku_udc: potential null dereference
has been added to the -mm tree.  Its filename is
     goku_udc-potential-null-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
i915-fix-small-leak-on-error-path.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
goku_udc-potential-null-dereference.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch

