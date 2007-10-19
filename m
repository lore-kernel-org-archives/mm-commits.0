From: akpm@linux-foundation.org
Subject: - cyclades-avoid-label-defined-but-not-used-warning.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:24 -0700
Message-ID: <200710190344.l9J3iOcj013140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966486AbXJSDzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Cyclades: Avoid label defined but not used warning
has been removed from the -mm tree.  Its filename was
     cyclades-avoid-label-defined-but-not-used-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Cyclades: Avoid label defined but not used warning
From: Jesper Juhl <jesper.juhl@gmail.com>

   CC      drivers/char/cyclades.o
 drivers/char/cyclades.c: In function 'cy_init':
 drivers/char/cyclades.c:5488: warning: label 'err_unr' defined but not used

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/cyclades.c~cyclades-avoid-label-defined-but-not-used-warning drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-avoid-label-defined-but-not-used-warning
+++ a/drivers/char/cyclades.c
@@ -5362,13 +5362,13 @@ static int __init cy_init(void)
 #ifdef CONFIG_PCI
 	/* look for pci boards */
 	retval = pci_register_driver(&cy_pci_driver);
-	if (retval && !nboards)
-		goto err_unr;
+	if (retval && !nboards) {
+		tty_unregister_driver(cy_serial_driver);
+		goto err_frtty;
+	}
 #endif
 
 	return 0;
-err_unr:
-	tty_unregister_driver(cy_serial_driver);
 err_frtty:
 	put_tty_driver(cy_serial_driver);
 err:
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
