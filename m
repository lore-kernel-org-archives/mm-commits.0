From: akpm@linux-foundation.org
Subject: - saa7134-corec-fix-warning.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:53 -0700
Message-ID: <200808261844.m7QIirVi021349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337AbYHZSp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:45:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     saa7134-core.c: fix warning
has been removed from the -mm tree.  Its filename was
     saa7134-corec-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: saa7134-core.c: fix warning
From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/media/video/saa7134/saa7134-core.c:366: warning:
'saa7134_buffer_requeue' defined but not used

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-core.c |   52 +++++++++----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134-core.c~saa7134-corec-fix-warning drivers/media/video/saa7134/saa7134-core.c
--- a/drivers/media/video/saa7134/saa7134-core.c~saa7134-corec-fix-warning
+++ a/drivers/media/video/saa7134/saa7134-core.c
@@ -359,32 +359,6 @@ void saa7134_buffer_timeout(unsigned lon
 	spin_unlock_irqrestore(&dev->slock,flags);
 }
 
-/* resends a current buffer in queue after resume */
-
-static int saa7134_buffer_requeue(struct saa7134_dev *dev,
-				  struct saa7134_dmaqueue *q)
-{
-	struct saa7134_buf *buf, *next;
-
-	assert_spin_locked(&dev->slock);
-
-	buf  = q->curr;
-	next = buf;
-	dprintk("buffer_requeue\n");
-
-	if (!buf)
-		return 0;
-
-	dprintk("buffer_requeue : resending active buffers \n");
-
-	if (!list_empty(&q->queue))
-		next = list_entry(q->queue.next, struct saa7134_buf,
-					  vb.queue);
-	buf->activate(dev, buf, next);
-
-	return 0;
-}
-
 /* ------------------------------------------------------------------ */
 
 int saa7134_set_dmabits(struct saa7134_dev *dev)
@@ -1139,6 +1113,32 @@ static void __devexit saa7134_finidev(st
 }
 
 #ifdef CONFIG_PM
+
+/* resends a current buffer in queue after resume */
+static int saa7134_buffer_requeue(struct saa7134_dev *dev,
+				  struct saa7134_dmaqueue *q)
+{
+	struct saa7134_buf *buf, *next;
+
+	assert_spin_locked(&dev->slock);
+
+	buf  = q->curr;
+	next = buf;
+	dprintk("buffer_requeue\n");
+
+	if (!buf)
+		return 0;
+
+	dprintk("buffer_requeue : resending active buffers \n");
+
+	if (!list_empty(&q->queue))
+		next = list_entry(q->queue.next, struct saa7134_buf,
+					  vb.queue);
+	buf->activate(dev, buf, next);
+
+	return 0;
+}
+
 static int saa7134_suspend(struct pci_dev *pci_dev , pm_message_t state)
 {
 
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch

