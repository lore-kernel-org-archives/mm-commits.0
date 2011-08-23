From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-kconfig-fix-build-error-when-pci-is-not-selected.patch removed from -mm tree
Date: Tue, 23 Aug 2011 12:18:24 -0700
Message-ID: <201108231915.p7NJFOdT000973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab1HWTPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 15:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tdent48227@gmail.com, gregkh@suse.de, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/Kconfig: fix build error when PCI is not selected
has been removed from the -mm tree.  Its filename was
     drivers-misc-kconfig-fix-build-error-when-pci-is-not-selected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/Kconfig: fix build error when PCI is not selected
From: Tracey Dent <tdent48227@gmail.com>

When you try to build INTEL_MID_PTI without having PCI enabled.  It fails
like this-

 CC [M]  drivers/misc/pti.o
 drivers/misc/pti.c: In function `pti_pci_remove':
 drivers/misc/pti.c:410: error: implicit declaration of function `pci_release_region'
 drivers/misc/pti.c: In function `pti_pci_probe':
 drivers/misc/pti.c:859: error: implicit declaration of function `pci_request_region'

So make INTEL_MID_PTI depend on PCI to fix build error.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~drivers-misc-kconfig-fix-build-error-when-pci-is-not-selected drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~drivers-misc-kconfig-fix-build-error-when-pci-is-not-selected
+++ a/drivers/misc/Kconfig
@@ -146,6 +146,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+	depends on PCI
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch

