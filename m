From: akpm@linux-foundation.org
Subject: - drivers-pci-pci-sysfsc-add-missing-pci_dev_put.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:34:02 -0800
Message-ID: <200711272034.lARKY2QL029087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329AbXK0UhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/pci/pci-sysfs.c: Add missing pci_dev_put
has been removed from the -mm tree.  Its filename was
     drivers-pci-pci-sysfsc-add-missing-pci_dev_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/pci/pci-sysfs.c: Add missing pci_dev_put
From: Julia Lawall <julia@diku.dk>

There should be a pci_dev_put when breaking out of a loop that iterates
over calls to pci_get_device and similar functions.

This was fixed using the following semantic patch.

// <smpl>
@@
identifier d;
type T;
expression e;
iterator for_each_pci_dev;
@@

T *d;
...
for_each_pci_dev(d)
   {... when != pci_dev_put(d)
        when != e = d
(
    return d;
|
+  pci_dev_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pci/pci-sysfs.c~drivers-pci-pci-sysfsc-add-missing-pci_dev_put drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~drivers-pci-pci-sysfsc-add-missing-pci_dev_put
+++ a/drivers/pci/pci-sysfs.c
@@ -702,8 +702,10 @@ static int __init pci_sysfs_init(void)
 	sysfs_initialized = 1;
 	for_each_pci_dev(pdev) {
 		retval = pci_create_sysfs_dev_files(pdev);
-		if (retval)
+		if (retval) {
+			pci_dev_put(pdev);
 			return retval;
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from julia@diku.dk are

drivers-pnp-resourcec-add-missing-pci_dev_put.patch
git-alsa.patch
sound-core-memallocc-add-missing-pci_dev_put.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
git-input.patch
git-sparc64.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
