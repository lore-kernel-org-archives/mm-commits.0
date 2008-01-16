From: akpm@linux-foundation.org
Subject: - bw-qcam-adds-module-parameter-aggressive-to-skip-polite-auto-detection-prior-to-direct-initialization.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:39:16 -0800
Message-ID: <200801160139.m0G1dGmD013996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755689AbYAPBtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:49:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brett.warden@gmail.com, alan@lxorguk.ukuu.org.uk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     bw-qcam: add module parameter 'force_init' to skip polite auto-detection prior to direct initialization.
has been removed from the -mm tree.  Its filename was
     bw-qcam-adds-module-parameter-aggressive-to-skip-polite-auto-detection-prior-to-direct-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bw-qcam: add module parameter 'force_init' to skip polite auto-detection prior to direct initialization.
From: "Brett T. Warden" <brett.warden@gmail.com>

Setting force_init=1 bypasses the friendly auto-detection by polling the
status register, and instead attempts to initialize the qcam directly.  Not
friendly to other parallel devices, but much more reliable than the
auto-detection.

Signed-off-by: Brett T. Warden <brett.warden@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bw-qcam.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/bw-qcam.c~bw-qcam-adds-module-parameter-aggressive-to-skip-polite-auto-detection-prior-to-direct-initialization drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c~bw-qcam-adds-module-parameter-aggressive-to-skip-polite-auto-detection-prior-to-direct-initialization
+++ a/drivers/media/video/bw-qcam.c
@@ -82,11 +82,16 @@ OTHER DEALINGS IN THE SOFTWARE.
 static unsigned int maxpoll=250;   /* Maximum busy-loop count for qcam I/O */
 static unsigned int yieldlines=4;  /* Yield after this many during capture */
 static int video_nr = -1;
+static unsigned int force_init;		/* Whether to probe aggressively */
 
 module_param(maxpoll, int, 0);
 module_param(yieldlines, int, 0);
 module_param(video_nr, int, 0);
 
+/* Set force_init=1 to avoid detection by polling status register and
+ * immediately attempt to initialize qcam */
+module_param(force_init, int, 0);
+
 static inline int read_lpstatus(struct qcam_device *q)
 {
 	return parport_read_status(q->pport);
@@ -331,6 +336,9 @@ static int qc_detect(struct qcam_device 
 	int count = 0;
 	int i;
 
+	if (force_init)
+		return 1;
+
 	lastreg = reg = read_lpstatus(q) & 0xf0;
 
 	for (i = 0; i < 500; i++)
@@ -354,12 +362,12 @@ static int qc_detect(struct qcam_device 
 
 	/* Be (even more) liberal in what you accept...  */
 
-/*	if (count > 30 && count < 200) */
 	if (count > 20 && count < 400) {
 		return 1;	/* found */
 	} else {
 		printk(KERN_ERR "No Quickcam found on port %s\n",
 			q->pport->name);
+		printk(KERN_DEBUG "Quickcam detection counter: %u\n", count);
 		return 0;	/* not found */
 	}
 }
_

Patches currently in -mm which might be from brett.warden@gmail.com are

git-dvb.patch
