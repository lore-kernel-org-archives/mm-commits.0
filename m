From: akpm@linux-foundation.org
Subject: + v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch added to -mm tree
Date: Mon, 08 Feb 2010 12:53:32 -0800
Message-ID: <201002082053.o18KrWVh002216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508Ab0BHUyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 15:54:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang0@gmail.com, brijohn@gmail.com, mchehab@infradead.org, moinejf@free.fr


The patch titled
     v4l/dvb: gspca - sn9c20x: correct onstack wait_queue_head declaration
has been added to the -mm tree.  Its filename is
     v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch

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

linux-next.patch
v4l-dvb-gspca-sn9c20x-correct-onstack-wait_queue_head-declaration.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
staging-rt2860-correct-onstack-wait_queue_head-declaration.patch

