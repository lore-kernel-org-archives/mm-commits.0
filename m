From: akpm@linux-foundation.org
Subject: + saa7134-fix-thread-shutdown-handling.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:39:10 -0700
Message-ID: <200706260339.l5Q3dAnf017518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbXFZDjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, mchehab@infradead.org, stable@kernel.org


The patch titled
     saa7134: fix thread shutdown handling
has been added to the -mm tree.  Its filename is
     saa7134-fix-thread-shutdown-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: saa7134: fix thread shutdown handling
From: Jeff Mahoney <jeffm@suse.com>

This patch changes the test for the thread pid from >= 0 to > 0.

When the saa8134 driver initialization fails after a certain point, it goes
through the complete shutdown process for the driver.  Part of shutting it
down includes tearing down the thread for tv audio.

The test for tearing down the thread tests for >= 0.  Since the dev
structure is kzalloc'd, the test will always be true if we haven't tried to
start the thread yet.  We end up waiting on pid 0 to complete, which will
never happen, so we lock up.

This bug was observed in Novell Bugzilla 284718, when request_irq() failed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/saa7134/saa7134-tvaudio.c~saa7134-fix-thread-shutdown-handling drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c~saa7134-fix-thread-shutdown-handling
+++ a/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -1005,7 +1005,7 @@ int saa7134_tvaudio_init2(struct saa7134
 int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 {
 	/* shutdown tvaudio thread */
-	if (dev->thread.pid >= 0) {
+	if (dev->thread.pid > 0) {
 		dev->thread.shutdown = 1;
 		wake_up_interruptible(&dev->thread.wq);
 		wait_for_completion(&dev->thread.exit);
_

Patches currently in -mm which might be from jeffm@suse.com are

saa7134-fix-thread-shutdown-handling.patch
