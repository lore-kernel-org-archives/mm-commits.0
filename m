From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-drivers-char.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:32 -0700
Message-ID: <200710180653.l9I6rWsH030454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932402AbXJRHnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, ralf@linux-mips.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in drivers/char/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-drivers-char.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in drivers/char/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	drivers/char/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mbcs.c     |    1 -
 drivers/char/ppdev.c    |    1 -
 drivers/char/synclink.c |    4 ----
 3 files changed, 6 deletions(-)

diff -puN drivers/char/mbcs.c~clean-up-duplicate-includes-in-drivers-char drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~clean-up-duplicate-includes-in-drivers-char
+++ a/drivers/char/mbcs.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mm.h>
-#include <linux/fs.h>
 #include <linux/uio.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff -puN drivers/char/ppdev.c~clean-up-duplicate-includes-in-drivers-char drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~clean-up-duplicate-includes-in-drivers-char
+++ a/drivers/char/ppdev.c
@@ -66,7 +66,6 @@
 #include <linux/poll.h>
 #include <linux/major.h>
 #include <linux/ppdev.h>
-#include <linux/device.h>
 #include <asm/uaccess.h>
 
 #define PP_VERSION "ppdev: user-space parallel port driver"
diff -puN drivers/char/synclink.c~clean-up-duplicate-includes-in-drivers-char drivers/char/synclink.c
--- a/drivers/char/synclink.c~clean-up-duplicate-includes-in-drivers-char
+++ a/drivers/char/synclink.c
@@ -81,13 +81,9 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-
 #include <linux/netdevice.h>
-
 #include <linux/vmalloc.h>
 #include <linux/init.h>
-
-#include <linux/delay.h>
 #include <linux/ioctl.h>
 
 #include <asm/system.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
