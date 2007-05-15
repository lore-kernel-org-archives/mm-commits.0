From: akpm@linux-foundation.org
Subject: + wrong-memory-access-in-i2o_block_device_lock.patch added to -mm tree
Date: Tue, 15 May 2007 12:49:46 -0700
Message-ID: <200705151949.l4FJnkXG016206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754123AbXEOTuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru, Markus.Lidel@shadowconnect.com, alan@lxorguk.ukuu.org.uk, dev@openvz.org


The patch titled
     wrong memory access in i2o_block_device_lock()
has been added to the -mm tree.  Its filename is
     wrong-memory-access-in-i2o_block_device_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wrong memory access in i2o_block_device_lock()
From: Vasily Averin <vvs@sw.ru>

This patch fixes access to memory that has not been allocated:
i2o_msg_get_wait() can returns errors different from I2O_QUEUE_EMPTY.  But the
result is checked only against this code.  If it is not I2O_QUEUE_EMPTY then
we dereference the error code as the pointer later.

Signed-off-by: Vasily Averin <vvs@sw.ru>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Acked-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_block.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/i2o/i2o_block.c~wrong-memory-access-in-i2o_block_device_lock drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~wrong-memory-access-in-i2o_block_device_lock
+++ a/drivers/message/i2o/i2o_block.c
@@ -215,7 +215,7 @@ static int i2o_block_device_lock(struct 
 	struct i2o_message *msg;
 
 	msg = i2o_msg_get_wait(dev->iop, I2O_TIMEOUT_MESSAGE_GET);
-	if (IS_ERR(msg) == I2O_QUEUE_EMPTY)
+	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
 	msg->u.head[0] = cpu_to_le32(FIVE_WORD_MSG_SIZE | SGL_OFFSET_0);
_

Patches currently in -mm which might be from vvs@sw.ru are

i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
