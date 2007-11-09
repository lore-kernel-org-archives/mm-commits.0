From: akpm@linux-foundation.org
Subject: + chipsfb-uses-depends-on-pci.patch added to -mm tree
Date: Fri, 09 Nov 2007 14:09:50 -0800
Message-ID: <200711092209.lA9M9ocb001783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840AbXKIWKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 17:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, kamalesh@linux.vnet.ibm.com


The patch titled
     chipsfb: uses/depends on PCI
has been added to the -mm tree.  Its filename is
     chipsfb-uses-depends-on-pci.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: chipsfb: uses/depends on PCI
From: Randy Dunlap <randy.dunlap@oracle.com>

chipsfb uses PCI interfaces and should depend on PCI.

  CC      drivers/video/chipsfb.o
drivers/video/chipsfb.c: In function 'chipsfb_pci_init':
drivers/video/chipsfb.c:378: error: implicit declaration of function 'pci_request_region'
drivers/video/chipsfb.c:435: error: implicit declaration of function 'pci_release_region'
make[2]: *** [drivers/video/chipsfb.o] Error 1
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2

!CONFIG_PCI causes the build to fail.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~chipsfb-uses-depends-on-pci drivers/video/Kconfig
--- a/drivers/video/Kconfig~chipsfb-uses-depends-on-pci
+++ a/drivers/video/Kconfig
@@ -503,7 +503,7 @@ config FB_VALKYRIE
 
 config FB_CT65550
 	bool "Chips 65550 display support"
-	depends on (FB = y) && PPC32
+	depends on (FB = y) && PPC32 && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

chipsfb-uses-depends-on-pci.patch
git-dvb.patch
git-kbuild.patch
git-netdev-all.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
