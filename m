From: akpm@linux-foundation.org
Subject: + sdio-add-new-function-for-raw-read-after-write-operation.patch added to -mm tree
Date: Wed, 19 May 2010 12:52:09 -0700
Message-ID: <201005191952.o4JJq9Pb002357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736Ab0ESTw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 15:52:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notasas@gmail.com, dimitrysh@google.com, kalle.valo@iki.fi


The patch titled
     sdio: add new function for RAW (Read after Write) operation
has been added to the -mm tree.  Its filename is
     sdio-add-new-function-for-raw-read-after-write-operation.patch

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
Subject: sdio: add new function for RAW (Read after Write) operation
From: Grazvydas Ignotas <notasas@gmail.com>

SDIO specification allows RAW (Read after Write) operation using
IO_RW_DIRECT command (CMD52) by setting the RAW bit.  This operation is
similar to ordinary read/write commands, except that both write and read
are performed using single command/response pair.  The Linux SDIO layer
already supports this internaly, only external function is missing for
drivers to make use, which is added by this patch.

This type of command is required to implement proper power save mode
support in wl1251 wifi driver.

Android has similar patch for G1 in it's tree for the same reason:

http://android.git.kernel.org/?p=kernel/common.git;a=commitdiff;h=74a47786f6ecbe6c1cf9fb15efe6a968451deb52

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Acked-by: Kalle Valo <kalle.valo@iki.fi>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_io.c    |   31 +++++++++++++++++++++++++++++++
 include/linux/mmc/sdio_func.h |    3 +++
 2 files changed, 34 insertions(+)

diff -puN drivers/mmc/core/sdio_io.c~sdio-add-new-function-for-raw-read-after-write-operation drivers/mmc/core/sdio_io.c
--- a/drivers/mmc/core/sdio_io.c~sdio-add-new-function-for-raw-read-after-write-operation
+++ a/drivers/mmc/core/sdio_io.c
@@ -406,6 +406,37 @@ void sdio_writeb(struct sdio_func *func,
 EXPORT_SYMBOL_GPL(sdio_writeb);
 
 /**
+ *	sdio_writeb_readb - write and read a byte from SDIO function
+ *	@func: SDIO function to access
+ *	@b: byte to write
+ *	@addr: address to write to
+ *	@err_ret: optional status value from transfer
+ *
+ *	Performs a RAW (Read after Write) operation as defined by SDIO spec -
+ *	single byte is written to address space of a given SDIO function and
+ *	response is read back from the same address, both using single request.
+ *	If there is a problem with the operation, 0xff is returned and
+ *	@err_ret will contain the error code.
+ */
+u8 sdio_writeb_readb(struct sdio_func *func, u8 b,
+	unsigned int addr, int *err_ret)
+{
+	int ret;
+	u8 val;
+
+	BUG_ON(!func);
+
+	ret = mmc_io_rw_direct(func->card, 1, func->num, addr, b, &val);
+	if (err_ret)
+		*err_ret = ret;
+	if (ret)
+		val = 0xff;
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(sdio_writeb_readb);
+
+/**
  *	sdio_memcpy_fromio - read a chunk of memory from a SDIO function
  *	@func: SDIO function to access
  *	@dst: buffer to store the data
diff -puN include/linux/mmc/sdio_func.h~sdio-add-new-function-for-raw-read-after-write-operation include/linux/mmc/sdio_func.h
--- a/include/linux/mmc/sdio_func.h~sdio-add-new-function-for-raw-read-after-write-operation
+++ a/include/linux/mmc/sdio_func.h
@@ -145,6 +145,9 @@ extern void sdio_writew(struct sdio_func
 extern void sdio_writel(struct sdio_func *func, u32 b,
 	unsigned int addr, int *err_ret);
 
+extern u8 sdio_writeb_readb(struct sdio_func *func, u8 b,
+	unsigned int addr, int *err_ret);
+
 extern int sdio_memcpy_toio(struct sdio_func *func, unsigned int addr,
 	void *src, int count);
 extern int sdio_writesb(struct sdio_func *func, unsigned int addr,
_

Patches currently in -mm which might be from notasas@gmail.com are

linux-next.patch
sdio-add-new-function-for-raw-read-after-write-operation.patch
fbdev-move-fbio_waitforvsync-to-linux-fbh.patch
fbdev-move-fbio_waitforvsync-to-linux-fbh-update.patch

