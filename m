From: akpm@linux-foundation.org
Subject: + drivers-pci-pci-sysfsc-add-missing-pci_dev_put.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:36:45 -0800
Message-ID: <200711262236.lAQMajaw026596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369AbXKZWgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:36:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, greg@kroah.com


The patch titled
     drivers/pci/pci-sysfs.c: Add missing pci_dev_put
has been added to the -mm tree.  Its filename is
     drivers-pci-pci-sysfsc-add-missing-pci_dev_put.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-alsa.patch
drivers-char-remove-unnecessary-pci_dev_put.patch
arch-ppc-remove-an-unnecessary-pci_dev_put.patch
drivers-pci-pci-sysfsc-add-missing-pci_dev_put.patch
git-sparc64.patch
drivers-video-remove-unnecessary-pci_dev_put.patch
