From: akpm@linux-foundation.org
Subject: - saa7134-fix-thread-shutdown-handling.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:42 -0700
Message-ID: <200706292040.l5TKegqq022447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbXF2Uut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, mchehab@infradead.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     saa7134: fix thread shutdown handling
has been removed from the -mm tree.  Its filename was
     saa7134-fix-thread-shutdown-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
revert-saa7134-fix-thread-shutdown-handling.patch
