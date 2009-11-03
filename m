From: akpm@linux-foundation.org
Subject: + drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:07:30 -0800
Message-ID: <200911030607.nA367UO5022724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbZKCGHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:07:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, gregkh@suse.de, hsweeten@visionengravers.com, stern@rowland.harvard.edu


The patch titled
     drivers/usb/core/hcd.c: quiet NULL pointer sparse noise
has been added to the -mm tree.  Its filename is
     drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch

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
Subject: drivers/usb/core/hcd.c: quiet NULL pointer sparse noise
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Quiet the following sparse noise:

  warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/hcd.c~drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise
+++ a/drivers/usb/core/hcd.c
@@ -1601,7 +1601,7 @@ int usb_hcd_check_bandwidth(struct usb_d
 {
 	int num_intfs, i, j;
 	struct usb_interface_cache *intf_cache;
-	struct usb_host_interface *alt = 0;
+	struct usb_host_interface *alt = NULL;
 	int ret = 0;
 	struct usb_hcd *hcd;
 	struct usb_host_endpoint *ep;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
clockeventsc-fix-symbol-was-not-declared-noise.patch
drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

