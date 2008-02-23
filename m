From: akpm@linux-foundation.org
Subject: + ssb-pci-core-driver-use-new-sprom-data-structure.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:24 -0800
Message-ID: <200802230732.m1N7WDgY018064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372AbYBWHyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, mb@bu3sch.de


The patch titled
     ssb: PCI core driver: use new SPROM data structure
has been added to the -mm tree.  Its filename is
     ssb-pci-core-driver-use-new-sprom-data-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ssb: PCI core driver: use new SPROM data structure
From: Aurelien Jarno <aurelien@aurel32.net>

Switch the SSB PCI core driver to the new SPROM data structure now that the
old one has been removed.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Acked-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_pcicore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ssb/driver_pcicore.c~ssb-pci-core-driver-use-new-sprom-data-structure drivers/ssb/driver_pcicore.c
--- a/drivers/ssb/driver_pcicore.c~ssb-pci-core-driver-use-new-sprom-data-structure
+++ a/drivers/ssb/driver_pcicore.c
@@ -362,7 +362,7 @@ static int pcicore_is_in_hostmode(struct
 	    chipid_top != 0x5300)
 		return 0;
 
-	if (bus->sprom.r1.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
+	if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
 		return 0;
 
 	/* The 200-pin BCM4712 package does not bond out PCI. Even when
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
bcm47xx-use-new-ssb-sprom-data-structure.patch
ssb-pci-core-driver-use-new-sprom-data-structure.patch
