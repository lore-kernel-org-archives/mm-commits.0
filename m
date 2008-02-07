From: akpm@linux-foundation.org
Subject: - drivers-video-remove-unnecessary-pci_dev_put.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:28:09 -0800
Message-ID: <200802070027.m170Ro7v007087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765977AbYBGApZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, adaplas@pol.net, thomas@winischhofer.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video: remove unnecessary pci_dev_put
has been removed from the -mm tree.  Its filename was
     drivers-video-remove-unnecessary-pci_dev_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
arch-powerpc-platforms-pseries-add-missing-of_node_put.patch
arch-powerpc-sysdev-add-missing-of_node_put.patch
arch-powerpc-platforms-82xx-add-missing-of_node_put.patch
git-input.patch
git-mtd.patch
