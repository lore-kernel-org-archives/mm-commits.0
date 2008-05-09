From: akpm@linux-foundation.org
Subject: - fix-irq-flags-in-saa7134.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:20 -0700
Message-ID: <200805092146.m49LkKRZ027100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755327AbYEIVrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mchehab@infradead.org, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix irq flags in saa7134
has been removed from the -mm tree.  Its filename was
     fix-irq-flags-in-saa7134.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix irq flags in saa7134
From: Steven Rostedt <rostedt@goodmis.org>

Some files in the drivers/media/video/saa7134 directory uses "int" for flags. 
This can cause hard to find bugs on some architectures.  This patch converts
the flags to use "long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel where
checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/saa7134/saa7134-video.c~fix-irq-flags-in-saa7134 drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c~fix-irq-flags-in-saa7134
+++ a/drivers/media/video/saa7134/saa7134-video.c
@@ -1634,7 +1634,7 @@ static int saa7134_s_fmt_overlay(struct 
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 	int err;
-	unsigned int flags;
+	unsigned long flags;
 
 	if (saa7134_no_overlay > 0) {
 		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
git-v9fs.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch

