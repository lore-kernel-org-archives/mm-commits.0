From: akpm@linux-foundation.org
Subject: [obsolete] v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch removed from -mm tree
Date: Fri, 19 Mar 2010 12:48:22 -0400
Message-ID: <201003191949.o2JJn6U5008985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab0CSTtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 15:49:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.zhang0@gmail.com, brijohn@gmail.com, mchehab@infradead.org, moinejf@free.fr, mm-commits@vger.kernel.org


The patch titled
     v4l/dvb: gspca - sn9c20x: correct onstack wait_queue_head declaration
has been removed from the -mm tree.  Its filename was
     v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l/dvb: gspca - sn9c20x: correct onstack wait_queue_head declaration
From: Yong Zhang <yong.zhang0@gmail.com>

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Brian Johnson <brijohn@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/sn9c20x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/sn9c20x.c~v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration drivers/media/video/gspca/sn9c20x.c
--- a/drivers/media/video/gspca/sn9c20x.c~v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration
+++ a/drivers/media/video/gspca/sn9c20x.c
@@ -1426,7 +1426,7 @@ static int input_kthread(void *data)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *)data;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	DECLARE_WAIT_QUEUE_HEAD(wait);
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait);
 	set_freezable();
 	for (;;) {
 		if (kthread_should_stop())
_

Patches currently in -mm which might be from yong.zhang0@gmail.com are

v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch

