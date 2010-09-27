From: akpm@linux-foundation.org
Subject: + drivers-misc-phantomc-add-missing-warning-messages-in-phantom_probe.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:16:02 -0700
Message-ID: <201009271916.o8RJG24l011192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933311Ab0I0TQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rahul.ruikar@gmail.com, greg@kroah.com, jirislaby@gmail.com


The patch titled
     drivers/misc/phantom.c: add missing warning messages in phantom_probe()
has been added to the -mm tree.  Its filename is
     drivers-misc-phantomc-add-missing-warning-messages-in-phantom_probe.patch

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
Subject: drivers/misc/phantom.c: add missing warning messages in phantom_probe()
From: Rahul Ruikar <rahul.ruikar@gmail.com>

phantom_probe() can fail in many places.  Add missing warning messages in
pci_enable_device() and pci_request_regions().

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/misc/phantom.c~drivers-misc-phantomc-add-missing-warning-messages-in-phantom_probe drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~drivers-misc-phantomc-add-missing-warning-messages-in-phantom_probe
+++ a/drivers/misc/phantom.c
@@ -343,8 +343,10 @@ static int __devinit phantom_probe(struc
 	int retval;
 
 	retval = pci_enable_device(pdev);
-	if (retval)
+	if (retval) {
+		dev_err(&pdev->dev, "pci_enable_device failed!\n");
 		goto err;
+	}
 
 	minor = phantom_get_free();
 	if (minor == PHANTOM_MAX_MINORS) {
@@ -356,8 +358,10 @@ static int __devinit phantom_probe(struc
 	phantom_devices[minor] = 1;
 
 	retval = pci_request_regions(pdev, "phantom");
-	if (retval)
+	if (retval) {
+		dev_err(&pdev->dev, "pci_request_regions failed!\n");
 		goto err_null;
+	}
 
 	retval = -ENOMEM;
 	pht = kzalloc(sizeof(*pht), GFP_KERNEL);
_

Patches currently in -mm which might be from rahul.ruikar@gmail.com are

drivers-misc-phantomc-add-missing-warning-messages-in-phantom_probe.patch

