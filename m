From: akpm@linux-foundation.org
Subject: + i2o-message-leak-in-i2o_msg_post_wait_mem.patch added to -mm tree
Date: Tue, 15 May 2007 12:49:48 -0700
Message-ID: <200705151949.l4FJnlOL016215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33557 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbXEOTuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru, Markus.Lidel@shadowconnect.com, alan@lxorguk.ukuu.org.uk, dev@openvz.org


The patch titled
     i2o message leak in i2o_msg_post_wait_mem()
has been added to the -mm tree.  Its filename is
     i2o-message-leak-in-i2o_msg_post_wait_mem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2o message leak in i2o_msg_post_wait_mem()
From: Vasily Averin <vvs@sw.ru>

We need to free i2o msg in case of error.

Signed-off-by: Vasily Averin <vvs@sw.ru>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Acked-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/exec-osm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/message/i2o/exec-osm.c~i2o-message-leak-in-i2o_msg_post_wait_mem drivers/message/i2o/exec-osm.c
--- a/drivers/message/i2o/exec-osm.c~i2o-message-leak-in-i2o_msg_post_wait_mem
+++ a/drivers/message/i2o/exec-osm.c
@@ -131,8 +131,10 @@ int i2o_msg_post_wait_mem(struct i2o_con
 	int rc = 0;
 
 	wait = i2o_exec_wait_alloc();
-	if (!wait)
+	if (!wait) {
+		i2o_msg_nop(c, msg);
 		return -ENOMEM;
+	}
 
 	if (tcntxt == 0xffffffff)
 		tcntxt = 0x80000000;
_

Patches currently in -mm which might be from vvs@sw.ru are

i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
