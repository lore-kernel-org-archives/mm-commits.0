From: akpm@linux-foundation.org
Subject: - bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:13:52 -0700
Message-ID: <200710010713.l917DqGd004479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910AbXJAHOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brett.warden@gmail.com, alan@redhat.com, mchehab@infradead.org, ray-lk@madrabbit.org, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     bw-qcam: use data_reverse instead of manually poking the control register
has been removed from the -mm tree.  Its filename was
     bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bw-qcam: use data_reverse instead of manually poking the control register
From: "Brett Warden" <brett.warden@gmail.com>

Fixes use of parport_write_control() to match the newer interface that
requires explicit parport_data_reverse() and parport_data_forward() calls. 
This eliminates the following error message and restores the original
intended behavior:

parport0 (bw-qcam): use data_reverse for this!

Also increases threshold in qc_detect() from 300 to 400, as my camera often
results in a count of approx 330.  Added a kernel error message to indicate
detection failure.

Thanks Ray and Randy for your comments, and for pointing out that I
needed to reset the port to forward mode!

Signed-off-by: Brett T. Warden <brett.warden@gmail.com>
Cc: "Ray Lee" <ray-lk@madrabbit.org>
Acked-by: Alan Cox <alan@redhat.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bw-qcam.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/bw-qcam.c~bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c~bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register
+++ a/drivers/media/video/bw-qcam.c
@@ -104,6 +104,17 @@ static inline void write_lpdata(struct q
 
 static inline void write_lpcontrol(struct qcam_device *q, int d)
 {
+	if(0x20 & d) {
+		/* Set bidirectional mode to reverse (data in) */
+		parport_data_reverse(q->pport);
+	} else {
+		/* Set bidirectional mode to forward (data out) */
+		parport_data_forward(q->pport);
+	}
+
+	/* Now issue the regular port command, but strip out the
+	 * direction flag */
+	d &= ~0x20;
 	parport_write_control(q->pport, d);
 }
 
@@ -344,10 +355,13 @@ static int qc_detect(struct qcam_device 
 	/* Be (even more) liberal in what you accept...  */
 
 /*	if (count > 30 && count < 200) */
-	if (count > 20 && count < 300)
+	if (count > 20 && count < 400)
+	{
 		return 1;	/* found */
-	else
+	} else {
+		printk(KERN_ERR "No Quickcam found on port %s\n", q->pport->name);
 		return 0;	/* not found */
+	}
 }
 
 
_

Patches currently in -mm which might be from brett.warden@gmail.com are

git-dvb.patch
bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register-fix.patch
