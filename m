From: akpm@linux-foundation.org
Subject: + fix-irq-flags-in-saa7134.patch added to -mm tree
Date: Thu, 01 May 2008 15:58:19 -0700
Message-ID: <200805012258.m41MwJ9e029842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760978AbYEAW6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 18:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mchehab@infradead.org, srostedt@redhat.com


The patch titled
     fix irq flags in saa7134
has been added to the -mm tree.  Its filename is
     fix-irq-flags-in-saa7134.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
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
9p-use-correct-type-for-processor-flags.patch
fix-irq-flags-in-mac80211-code.patch
fix-irq-flags-in-saa7134.patch
fix-irq-flags-in-rtc-ds1511.patch
fix-irq-flags-for-iuu_phoenixc.patch
git-sched.patch

