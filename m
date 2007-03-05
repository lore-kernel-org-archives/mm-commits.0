From: akpm@linux-foundation.org
Subject: + usb-storage-do-not-rebuild-when-kernel-version-changes.patch added to -mm tree
Date: Sun, 04 Mar 2007 22:53:52 -0800
Message-ID: <200703050653.l256rqgp012003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXCEGx5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 01:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, greg@kroah.com


The patch titled
     usb-storage: do not rebuild when kernel version changes
has been added to the -mm tree.  Its filename is
     usb-storage-do-not-rebuild-when-kernel-version-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-storage: do not rebuild when kernel version changes
From: Sam Ravnborg <sam@ravnborg.org>

Replacing use of UTS_RELEASE with utsname()->release avoids that the
usb-storage driver is recompiled each time the kernel version changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/storage/usb.c~usb-storage-do-not-rebuild-when-kernel-version-changes drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c~usb-storage-do-not-rebuild-when-kernel-version-changes
+++ a/drivers/usb/storage/usb.c
@@ -55,7 +55,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
-#include <linux/utsrelease.h>
+#include <linux/utsname.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -547,7 +547,7 @@ static int get_device_info(struct us_dat
 				idesc->bInterfaceSubClass,
 				idesc->bInterfaceProtocol,
 				msgs[msg],
-				UTS_RELEASE);
+				utsname()->release);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
usb-storage-do-not-rebuild-when-kernel-version-changes.patch
kbuild-override-build-timestamp.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
pcie-fix-section-mismatch-warning.patch
aer-fix-section-mismatch-warning.patch
pci-do-not-mark-exported-functions-as-__devinit.patch
x86_64-fix-section-mismatch-warnings.patch
fix-section-mismatch-warning-in-lib-swiotlbc.patch
extend-print_symbol-capability.patch
