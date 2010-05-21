From: akpm@linux-foundation.org
Subject: + sdio-add-new-function-for-raw-read-after-write-operation-update.patch added to -mm tree
Date: Fri, 21 May 2010 13:36:30 -0700
Message-ID: <201005212036.o4LKaUjE032720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626Ab0EUUg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 16:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notasas@gmail.com, dimitrysh@google.com, kalle.valo@iki.fi, linux-mmc@vger.kernel.org


The patch titled
     sdio-add-new-function-for-raw-read-after-write-operation update
has been added to the -mm tree.  Its filename is
     sdio-add-new-function-for-raw-read-after-write-operation-update.patch

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
Subject: sdio-add-new-function-for-raw-read-after-write-operation update
From: Grazvydas Ignotas <notasas@gmail.com>

Here is updated version that addresses your comments (removes BUG()
and improves argument name).

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_io.c    |    9 ++++-----
 include/linux/mmc/sdio_func.h |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/core/sdio_io.c~sdio-add-new-function-for-raw-read-after-write-operation-update drivers/mmc/core/sdio_io.c
--- a/drivers/mmc/core/sdio_io.c~sdio-add-new-function-for-raw-read-after-write-operation-update
+++ a/drivers/mmc/core/sdio_io.c
@@ -408,7 +408,7 @@ EXPORT_SYMBOL_GPL(sdio_writeb);
 /**
  *	sdio_writeb_readb - write and read a byte from SDIO function
  *	@func: SDIO function to access
- *	@b: byte to write
+ *	@write_byte: byte to write
  *	@addr: address to write to
  *	@err_ret: optional status value from transfer
  *
@@ -418,15 +418,14 @@ EXPORT_SYMBOL_GPL(sdio_writeb);
  *	If there is a problem with the operation, 0xff is returned and
  *	@err_ret will contain the error code.
  */
-u8 sdio_writeb_readb(struct sdio_func *func, u8 b,
+u8 sdio_writeb_readb(struct sdio_func *func, u8 write_byte,
 	unsigned int addr, int *err_ret)
 {
 	int ret;
 	u8 val;
 
-	BUG_ON(!func);
-
-	ret = mmc_io_rw_direct(func->card, 1, func->num, addr, b, &val);
+	ret = mmc_io_rw_direct(func->card, 1, func->num, addr,
+			write_byte, &val);
 	if (err_ret)
 		*err_ret = ret;
 	if (ret)
diff -puN include/linux/mmc/sdio_func.h~sdio-add-new-function-for-raw-read-after-write-operation-update include/linux/mmc/sdio_func.h
--- a/include/linux/mmc/sdio_func.h~sdio-add-new-function-for-raw-read-after-write-operation-update
+++ a/include/linux/mmc/sdio_func.h
@@ -145,7 +145,7 @@ extern void sdio_writew(struct sdio_func
 extern void sdio_writel(struct sdio_func *func, u32 b,
 	unsigned int addr, int *err_ret);
 
-extern u8 sdio_writeb_readb(struct sdio_func *func, u8 b,
+extern u8 sdio_writeb_readb(struct sdio_func *func, u8 write_byte,
 	unsigned int addr, int *err_ret);
 
 extern int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
_

Patches currently in -mm which might be from notasas@gmail.com are

origin.patch
linux-next.patch
sdio-add-new-function-for-raw-read-after-write-operation.patch
sdio-add-new-function-for-raw-read-after-write-operation-update.patch
fbdev-move-fbio_waitforvsync-to-linux-fbh.patch
fbdev-move-fbio_waitforvsync-to-linux-fbh-update.patch

