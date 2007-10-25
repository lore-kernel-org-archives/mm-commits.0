From: akpm@linux-foundation.org
Subject: + fix-build-bug.patch added to -mm tree
Date: Thu, 25 Oct 2007 13:26:16 -0700
Message-ID: <200710252026.l9PKQGKU021817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134AbXJYU0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 16:26:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, bzolnier@gmail.com, macro@linux-mips.org, sam@ravnborg.org


The patch titled
     ide: fix build bug
has been added to the -mm tree.  Its filename is
     fix-build-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide: fix build bug
From: Ralf Baechle <ralf@linux-mips.org>

  CC      drivers/ide/pci/generic.o
drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
+section type conflict

This sort of build error is becoming a regular issue.  Either all or non
of the elements that go into a particular section of a compilation unit
need to be const.  Or an error may result such as in this case if
CONFIG_HOTPLUG is unset.

Maybe worth a check in checkpatch.pl - but certainly gcc's interolerance
is also being less than helpful here.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ide/pci/generic.c~fix-build-bug drivers/ide/pci/generic.c
--- a/drivers/ide/pci/generic.c~fix-build-bug
+++ a/drivers/ide/pci/generic.c
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(all_generic_ide, "IDE g
 		.udma_mask	= ATA_UDMA6, \
 	}
 
-static const struct ide_port_info generic_chipsets[] __devinitdata = {
+static struct ide_port_info generic_chipsets[] __devinitdata = {
 	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
 
 	{	/* 1 */
_

Patches currently in -mm which might be from ralf@linux-mips.org are

fix-build-bug.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-inclusions-of-linux-autoconfh.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
