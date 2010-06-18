From: akpm@linux-foundation.org
Subject: + fbdev-section-fixes-in-viafb-driver.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:46:31 -0700
Message-ID: <201006182346.o5INkV3o030141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab0FRXqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net


The patch titled
     fbdev: section fixes in viafb driver
has been added to the -mm tree.  Its filename is
     fbdev-section-fixes-in-viafb-driver.patch

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
Subject: fbdev: section fixes in viafb driver
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Move two functions from .devexit to .text, which are called on the probe
error path.  Also a function which is called by probe is moved from .text
to .devinit.

WARNING: vmlinux.o(.devinit.text+0x2ca5): Section mismatch in reference
from the function via_pci_probe() to the function
.devexit.text:via_teardown_subdevs()
The function __devinit via_pci_probe() references
a function __devexit via_teardown_subdevs().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
via_teardown_subdevs() so it may be used outside an exit section.

WARNING: vmlinux.o(.devinit.text+0x2cb1): Section mismatch in reference
from the function via_pci_probe() to the function
.devexit.text:via_pci_teardown_mmio()
The function __devinit via_pci_probe() references
a function __devexit via_pci_teardown_mmio().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
via_pci_teardown_mmio() so it may be used outside an exit section.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/via-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/via/via-core.c~fbdev-section-fixes-in-viafb-driver drivers/video/via/via-core.c
--- a/drivers/video/via/via-core.c~fbdev-section-fixes-in-viafb-driver
+++ a/drivers/video/via/via-core.c
@@ -64,7 +64,7 @@ static inline int viafb_mmio_read(int re
  */
 static u32 viafb_enabled_ints;
 
-static void viafb_int_init(void)
+static void __devinit viafb_int_init(void)
 {
 	viafb_enabled_ints = 0;
 
@@ -496,7 +496,7 @@ out_unmap:
 	return ret;
 }
 
-static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
+static void via_pci_teardown_mmio(struct viafb_dev *vdev)
 {
 	iounmap(vdev->fbmem);
 	iounmap(vdev->engine_mmio);
@@ -560,7 +560,7 @@ static int __devinit via_setup_subdevs(s
 	return 0;
 }
 
-static void __devexit via_teardown_subdevs(void)
+static void via_teardown_subdevs(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

fbdev-section-fixes-in-viafb-driver.patch

