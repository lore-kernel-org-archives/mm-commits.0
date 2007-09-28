From: akpm@linux-foundation.org
Subject: + bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register-fix.patch added to -mm tree
Date: Thu, 27 Sep 2007 23:19:08 -0700
Message-ID: <200709280619.l8S6J8dU014265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbXI1GTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 02:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brett.warden@gmail.com, alan@redhat.com, mchehab@infradead.org, ray-lk@madrabbit.org, rdunlap@xenotime.net


The patch titled
     bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register fix
has been added to the -mm tree.  Its filename is
     bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register fix
From: "Brett Warden" <brett.warden@gmail.com>

coding-style repairs

Cc: Brett T. Warden <brett.warden@gmail.com>
Cc: "Ray Lee" <ray-lk@madrabbit.org>
Cc: Alan Cox <alan@redhat.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bw-qcam.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/bw-qcam.c~bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register-fix drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c~bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register-fix
+++ a/drivers/media/video/bw-qcam.c
@@ -104,7 +104,7 @@ static inline void write_lpdata(struct q
 
 static inline void write_lpcontrol(struct qcam_device *q, int d)
 {
-	if(0x20 & d) {
+	if (d & 0x20) {
 		/* Set bidirectional mode to reverse (data in) */
 		parport_data_reverse(q->pport);
 	} else {
@@ -355,11 +355,11 @@ static int qc_detect(struct qcam_device 
 	/* Be (even more) liberal in what you accept...  */
 
 /*	if (count > 30 && count < 200) */
-	if (count > 20 && count < 400)
-	{
+	if (count > 20 && count < 400) {
 		return 1;	/* found */
 	} else {
-		printk(KERN_ERR "No Quickcam found on port %s\n", q->pport->name);
+		printk(KERN_ERR "No Quickcam found on port %s\n",
+			q->pport->name);
 		return 0;	/* not found */
 	}
 }
_

Patches currently in -mm which might be from brett.warden@gmail.com are

bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register.patch
bw-qcam-use-data_reverse-instead-of-manually-poking-the-control-register-fix.patch
