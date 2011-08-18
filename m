From: akpm@linux-foundation.org
Subject: + drivers-misc-kconfig-fix-build-error-when-pci-is-not-selected.patch added to -mm tree
Date: Thu, 18 Aug 2011 11:47:34 -0700
Message-ID: <201108181847.p7IIlZAr020798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab1HRSsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 14:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, gregkh@suse.de, rdunlap@xenotime.net


The patch titled
     drivers/misc/Kconfig: fix build error when PCI is not selected
has been added to the -mm tree.  Its filename is
     drivers-misc-kconfig-fix-build-error-when-pci-is-not-selected.patch

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

drivers-misc-kconfig-fix-build-error-when-pci-is-not-selected.patch

