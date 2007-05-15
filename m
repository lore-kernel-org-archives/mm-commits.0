From: akpm@linux-foundation.org
Subject: + i2o-proc-reading-oops.patch added to -mm tree
Date: Tue, 15 May 2007 12:49:50 -0700
Message-ID: <200705151949.l4FJnoKB016219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbXEOTuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru, Markus.Lidel@shadowconnect.com, alan@lxorguk.ukuu.org.uk, dev@openvz.org


The patch titled
     i2o proc reading oops
has been added to the -mm tree.  Its filename is
     i2o-proc-reading-oops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2o proc reading oops
From: Vasily Averin <vvs@sw.ru>

Fix oops on reading from some i2o proc files (i2o_seq_show_driver_store() and
other) because their handlers uses "exec" field in struct i2o_controller

Signed-off-by: Vasily Averin <vvs@sw.ru>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Acked-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/exec-osm.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/message/i2o/exec-osm.c~i2o-proc-reading-oops drivers/message/i2o/exec-osm.c
--- a/drivers/message/i2o/exec-osm.c~i2o-proc-reading-oops
+++ a/drivers/message/i2o/exec-osm.c
@@ -339,6 +339,8 @@ static int i2o_exec_probe(struct device 
 	rc = device_create_file(dev, &dev_attr_product_id);
 	if (rc) goto err_vid;
 
+	i2o_dev->iop->exec = i2o_dev;
+
 	return 0;
 
 err_vid:
_

Patches currently in -mm which might be from vvs@sw.ru are

i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
