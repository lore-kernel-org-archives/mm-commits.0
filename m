From: akpm@linux-foundation.org
Subject: + net-hp100-fix-section-mismatch-warning.patch added to -mm tree
Date: Thu, 31 May 2007 16:39:46 -0700
Message-ID: <200705312339.l4VNdk2I030862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbXEaXkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 19:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, jeff@garzik.org


The patch titled
     net/hp100: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     net-hp100-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net/hp100: fix section mismatch warning
From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning in hp100:

WARNING: drivers/net/hp100.o(.init.text+0x26a): Section mismatch: reference to .exit.text: (after 'init_module')

The warning says that we use a function marked __exit from a
function marked __init.
This is not good on architectures where we discard __exit section
for drivers that are built-in.

Note: This warning is only seen by my local copy of modpost
      but the change will soon hit upstream.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hp100.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/hp100.c~net-hp100-fix-section-mismatch-warning drivers/net/hp100.c
--- a/drivers/net/hp100.c~net-hp100-fix-section-mismatch-warning
+++ a/drivers/net/hp100.c
@@ -3005,7 +3005,7 @@ static int __init hp100_isa_init(void)
 	return cards > 0 ? 0 : -ENODEV;
 }
 
-static void __exit hp100_isa_cleanup(void)
+static void hp100_isa_cleanup(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
git-newsetup.patch
net-hp100-fix-section-mismatch-warning.patch
kvm-fix-section-mismatch-warning-in-kvm-intelo.patch
acpi-fix-section-mismatch-warning-in-asus-toshiba.patch
