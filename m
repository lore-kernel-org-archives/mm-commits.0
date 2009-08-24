From: akpm@linux-foundation.org
Subject: + drivers-gpio-bt8xxgpioc-add-missing-__init-__exit-markers.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:09:50 -0700
Message-ID: <200908242109.n7OL9oa8002397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbZHXVKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, david-b@pacbell.net, jkosina@suse.cz, mb@bu3sch.de


The patch titled
     drivers/gpio/bt8xxgpio.c: add missing __init/__exit markers
has been added to the -mm tree.  Its filename is
     drivers-gpio-bt8xxgpioc-add-missing-__init-__exit-markers.patch

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
Subject: drivers/gpio/bt8xxgpio.c: add missing __init/__exit markers
From: Peter Huewe <peterhuewe@gmx.de>

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/bt8xxgpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/bt8xxgpio.c~drivers-gpio-bt8xxgpioc-add-missing-__init-__exit-markers drivers/gpio/bt8xxgpio.c
--- a/drivers/gpio/bt8xxgpio.c~drivers-gpio-bt8xxgpioc-add-missing-__init-__exit-markers
+++ a/drivers/gpio/bt8xxgpio.c
@@ -330,13 +330,13 @@ static struct pci_driver bt8xxgpio_pci_d
 	.resume		= bt8xxgpio_resume,
 };
 
-static int bt8xxgpio_init(void)
+static int __init bt8xxgpio_init(void)
 {
 	return pci_register_driver(&bt8xxgpio_pci_driver);
 }
 module_init(bt8xxgpio_init)
 
-static void bt8xxgpio_exit(void)
+static void __exit bt8xxgpio_exit(void)
 {
 	pci_unregister_driver(&bt8xxgpio_pci_driver);
 }
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
drivers-gpio-bt8xxgpioc-add-missing-__init-__exit-markers.patch
char-impi-adding-__init-macro-fix-of-__exit-macro-location-in-ipmi_poweroffc.patch

