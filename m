From: akpm@linux-foundation.org
Subject: [merged] drivers-gpio-bt8xxgpioc-add-missing-__init-__exit-markers.patch removed from -mm tree
Date: Tue, 25 Aug 2009 11:45:27 -0700
Message-ID: <200908251845.n7PIjRbT013710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbZHYSqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Aug 2009 14:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterhuewe@gmx.de, david-b@pacbell.net, jkosina@suse.cz, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     drivers/gpio/bt8xxgpio.c: add missing __init/__exit markers
has been removed from the -mm tree.  Its filename was
     drivers-gpio-bt8xxgpioc-add-missing-__init-__exit-markers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

