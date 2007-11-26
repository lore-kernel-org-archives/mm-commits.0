From: akpm@linux-foundation.org
Subject: + drivers-video-remove-unnecessary-pci_dev_put.patch added to -mm tree
Date: Sun, 25 Nov 2007 23:53:38 -0800
Message-ID: <200711260753.lAQ7rce9023153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbXKZHxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 02:53:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, adaplas@pol.net, thomas@winischhofer.net


The patch titled
     drivers/video: remove unnecessary pci_dev_put
has been added to the -mm tree.  Its filename is
     drivers-video-remove-unnecessary-pci_dev_put.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video: remove unnecessary pci_dev_put
From: Julia Lawall <julia@diku.dk>

pci_get_class implicitly does a pci_dev_put on its second argument, so
pci_dev_put is only needed if there is a break out of the loop.

The semantic match detecting this problem is as follows:

// <smpl>
@@
expression dev;
expression E;
@@

* pci_dev_put(dev)
  ... when != dev = E
(
* pci_get_device(...,dev)
|
* pci_get_device_reverse(...,dev)
|
* pci_get_subsys(...,dev)
|
* pci_get_class(...,dev)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/sis/sis_main.c~drivers-video-remove-unnecessary-pci_dev_put drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~drivers-video-remove-unnecessary-pci_dev_put
+++ a/drivers/video/sis/sis_main.c
@@ -4621,9 +4621,9 @@ sisfb_find_host_bridge(struct sis_video_
 
 	while((pdev = pci_get_class(PCI_CLASS_BRIDGE_HOST, pdev))) {
 		temp = pdev->vendor;
-		pci_dev_put(pdev);
 		if(temp == pcivendor) {
 			ret = 1;
+			pci_dev_put(pdev);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
git-sparc64.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
