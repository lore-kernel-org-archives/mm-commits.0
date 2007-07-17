From: akpm@linux-foundation.org
Subject: - i2o-message-leak-in-i2o_msg_post_wait_mem.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:58 -0700
Message-ID: <200707172303.l6HN3wA1011754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936753AbXGQXQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, Markus.Lidel@shadowconnect.com, alan@lxorguk.ukuu.org.uk, dev@openvz.org, mm-commits@vger.kernel.org


The patch titled
     i2o message leak in i2o_msg_post_wait_mem()
has been removed from the -mm tree.  Its filename was
     i2o-message-leak-in-i2o_msg_post_wait_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 1 deletion(-)

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

origin.patch
