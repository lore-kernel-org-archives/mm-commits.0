From: akpm@linux-foundation.org
Subject: + bcm47xx-use-new-ssb-sprom-data-structure.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:43 -0800
Message-ID: <200802230730.m1N7UW9L017945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbYBWHbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:31:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net


The patch titled
     BCM47XX: use new SSB SPROM data structure
has been added to the -mm tree.  Its filename is
     bcm47xx-use-new-ssb-sprom-data-structure.patch

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
Subject: BCM47XX: use new SSB SPROM data structure
From: Aurelien Jarno <aurelien@aurel32.net>

Switch the BCM47XX code to the new SPROM data structure now that the old one
has been removed.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/bcm47xx/setup.c   |   12 ++++++------
 arch/mips/bcm47xx/wgt634u.c |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/mips/bcm47xx/setup.c~bcm47xx-use-new-ssb-sprom-data-structure arch/mips/bcm47xx/setup.c
--- a/arch/mips/bcm47xx/setup.c~bcm47xx-use-new-ssb-sprom-data-structure
+++ a/arch/mips/bcm47xx/setup.c
@@ -92,17 +92,17 @@ static int bcm47xx_get_invariants(struct
 	iv->sprom.revision = 3;
 
 	if (cfe_getenv("et0macaddr", buf, sizeof(buf)) >= 0)
-		str2eaddr(buf, iv->sprom.r1.et0mac);
+		str2eaddr(buf, iv->sprom.et0mac);
 	if (cfe_getenv("et1macaddr", buf, sizeof(buf)) >= 0)
-		str2eaddr(buf, iv->sprom.r1.et1mac);
+		str2eaddr(buf, iv->sprom.et1mac);
 	if (cfe_getenv("et0phyaddr", buf, sizeof(buf)) >= 0)
-		iv->sprom.r1.et0phyaddr = simple_strtoul(buf, NULL, 10);
+		iv->sprom.et0phyaddr = simple_strtoul(buf, NULL, 10);
 	if (cfe_getenv("et1phyaddr", buf, sizeof(buf)) >= 0)
-		iv->sprom.r1.et1phyaddr = simple_strtoul(buf, NULL, 10);
+		iv->sprom.et1phyaddr = simple_strtoul(buf, NULL, 10);
 	if (cfe_getenv("et0mdcport", buf, sizeof(buf)) >= 0)
-		iv->sprom.r1.et0mdcport = simple_strtoul(buf, NULL, 10);
+		iv->sprom.et0mdcport = simple_strtoul(buf, NULL, 10);
 	if (cfe_getenv("et1mdcport", buf, sizeof(buf)) >= 0)
-		iv->sprom.r1.et1mdcport = simple_strtoul(buf, NULL, 10);
+		iv->sprom.et1mdcport = simple_strtoul(buf, NULL, 10);
 
 	return 0;
 }
diff -puN arch/mips/bcm47xx/wgt634u.c~bcm47xx-use-new-ssb-sprom-data-structure arch/mips/bcm47xx/wgt634u.c
--- a/arch/mips/bcm47xx/wgt634u.c~bcm47xx-use-new-ssb-sprom-data-structure
+++ a/arch/mips/bcm47xx/wgt634u.c
@@ -50,7 +50,7 @@ static int __init wgt634u_init(void)
 	 * been allocated ranges 00:09:5b:xx:xx:xx and 00:0f:b5:xx:xx:xx.
 	 */
 
-	u8 *et0mac = ssb_bcm47xx.sprom.r1.et0mac;
+	u8 *et0mac = ssb_bcm47xx.sprom.et0mac;
 
 	if (et0mac[0] == 0x00 &&
 	    ((et0mac[1] == 0x09 && et0mac[2] == 0x5b) ||
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
bcm47xx-use-new-ssb-sprom-data-structure.patch
ssb-pci-core-driver-use-new-sprom-data-structure.patch
