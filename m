From: akpm@linux-foundation.org
Subject: + usb-fix-suspend-to-ram.patch added to -mm tree
Date: Mon, 21 May 2007 14:22:43 -0700
Message-ID: <200705212122.l4LLMh2v020344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbXEUVYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com


The patch titled
     usb: fix suspend-to-RAM
has been added to the -mm tree.  Its filename is
     usb-fix-suspend-to-ram.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: fix suspend-to-RAM
From: Alan Stern <stern@rowland.harvard.edu>

unchangelogged.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/usb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/usb.c~usb-fix-suspend-to-ram drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~usb-fix-suspend-to-ram
+++ a/drivers/usb/core/usb.c
@@ -205,7 +205,7 @@ struct device_type usb_device_type = {
 
 static int ksuspend_usb_init(void)
 {
-	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
+	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
 	if (!ksuspend_usb_wq)
 		return -ENOMEM;
 	return 0;
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

revert-gregkh-usb-usb-make-the-autosuspend-workqueue-thread-freezable.patch
usb-dont-try-to-kzalloc-0-bytes.patch
fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
hisax-fix-error-checking-for-hisax_register.patch
usb-fix-suspend-to-ram.patch
