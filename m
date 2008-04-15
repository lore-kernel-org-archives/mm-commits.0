From: akpm@linux-foundation.org
Subject: - bttv-fix-memory-leak-in-radio_release.patch removed from -mm tree
Date: Tue, 15 Apr 2008 15:54:48 -0700
Message-ID: <200804152254.m3FMsnxB020105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbYDOWyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 18:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robfitz@273k.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     bttv: fix memory leak in radio_release
has been removed from the -mm tree.  Its filename was
     bttv-fix-memory-leak-in-radio_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bttv: fix memory leak in radio_release
From: Robert Fitzsimons <robfitz@273k.net>

Fix the leak of the bttv_fh structure allocated in radio_open which
was introduced by commit 5cd3955cb8adfc1edf481e9e1cb2289db50ccacb.

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bt8xx/bttv-driver.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/media/video/bt8xx/bttv-driver.c~bttv-fix-memory-leak-in-radio_release drivers/media/video/bt8xx/bttv-driver.c
--- a/drivers/media/video/bt8xx/bttv-driver.c~bttv-fix-memory-leak-in-radio_release
+++ a/drivers/media/video/bt8xx/bttv-driver.c
@@ -3466,6 +3466,9 @@ static int radio_release(struct inode *i
 	file->private_data = NULL;
 	kfree(fh);
 
+	file->private_data = NULL;
+	kfree(fh);
+
 	btv->radio_user--;
 
 	bttv_call_i2c_clients(btv, RDS_CMD_CLOSE, &cmd);
_

Patches currently in -mm which might be from robfitz@273k.net are

git-dvb.patch
bttv-fix-memory-leak-in-radio_release.patch

