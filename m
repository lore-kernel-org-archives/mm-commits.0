From: akpm@linux-foundation.org
Subject: - i2o-proc-reading-oops.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:00 -0700
Message-ID: <200707172304.l6HN40dv011760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936762AbXGQXQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, Markus.Lidel@shadowconnect.com, alan@lxorguk.ukuu.org.uk, dev@openvz.org, mm-commits@vger.kernel.org


The patch titled
     i2o proc reading oops
has been removed from the -mm tree.  Its filename was
     i2o-proc-reading-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+)

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

origin.patch
