From: akpm@linux-foundation.org
Subject: + fix-integer-overflow-warning-in-i2o_block.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:04:39 -0700
Message-ID: <200707290704.l6T74dbj012871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568AbXG2HFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:05:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroos@linux.ee, mark_salyzyn@adaptec.com


The patch titled
     fix integer overflow warning in i2o_block
has been added to the -mm tree.  Its filename is
     fix-integer-overflow-warning-in-i2o_block.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix integer overflow warning in i2o_block
From: Meelis Roos <mroos@linux.ee>

drivers/message/i2o/i2o_block.c: In function 'i2o_block_transfer':
drivers/message/i2o/i2o_block.c:837: warning: integer overflow in expression

msg->u.head[1] = cpu_to_le32(I2O_CMD_PRIVATE << 24 | HOST_TID << 12 | tid);
and I2O_CMD_PRIVATE is defined as 0xFF.  This gets "0xFF0100 | tid" and fits
into 32-bit unsigned but not into 32-bit signed integer properly.  Target
value is defined as u32 so the claculation does not fit during computation.

Change local variable tid to u32 so the whole expression is of u32 type and
fits well into u32 result.

Signed-off-by: Meelis Roos <mroos@linux.ee>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/i2o/i2o_block.c~fix-integer-overflow-warning-in-i2o_block drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~fix-integer-overflow-warning-in-i2o_block
+++ a/drivers/message/i2o/i2o_block.c
@@ -744,7 +744,7 @@ static int i2o_block_transfer(struct req
 {
 	struct i2o_block_device *dev = req->rq_disk->private_data;
 	struct i2o_controller *c;
-	int tid = dev->i2o_dev->lct_data.tid;
+	u32 tid = dev->i2o_dev->lct_data.tid;
 	struct i2o_message *msg;
 	u32 *mptr;
 	struct i2o_block_request *ireq = req->special;
_

Patches currently in -mm which might be from mroos@linux.ee are

acpi-cure-run-together-printk-lines.patch
fix-integer-overflow-warning-in-i2o_block.patch
