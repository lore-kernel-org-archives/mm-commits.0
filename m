From: akpm@linux-foundation.org
Subject: + au1000_eth-fix-warnings.patch added to -mm tree
Date: Mon, 25 Jun 2007 16:02:33 -0700
Message-ID: <200706252302.l5PN2XEo013266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbXFYXDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 19:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, jeff@garzik.org


The patch titled
     au1000_eth: Fix warnings
has been added to the -mm tree.  Its filename is
     au1000_eth-fix-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: au1000_eth: Fix warnings
From: Ralf Baechle <ralf@linux-mips.org>

Fixed by including <linux/dma-mapping.h>:

  CC      drivers/net/au1000_eth.o
drivers/net/au1000_eth.c: In function 'au1000_probe':
drivers/net/au1000_eth.c:661: warning: implicit declaration of function 'dma_alloc_noncoherent'
drivers/net/au1000_eth.c:802: warning: implicit declaration of function 'dma_free_noncoherent'

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/au1000_eth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/au1000_eth.c~au1000_eth-fix-warnings drivers/net/au1000_eth.c
--- a/drivers/net/au1000_eth.c~au1000_eth-fix-warnings
+++ a/drivers/net/au1000_eth.c
@@ -34,7 +34,7 @@
  *
  *
  */
-
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
_

Patches currently in -mm which might be from ralf@linux-mips.org are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-mips.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
au1000_eth-fix-warnings.patch
update-zilog-timeout.patch
zs-move-to-the-serial-subsystem.patch
zs-move-to-the-serial-subsystem-update.patch
zsc-drain-the-transmission-line.patch
