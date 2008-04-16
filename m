From: akpm@linux-foundation.org
Subject: - ibmcam-improve-support-for-the-ibm-pc-camera-pro.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:44 -0700
Message-ID: <200804162255.m3GMtiuH011146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757032AbYDPXBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhilvert@gmail.com, greg@kroah.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ibmcam: improve support for the IBM PC Camera Pro
has been removed from the -mm tree.  Its filename was
     ibmcam-improve-support-for-the-ibm-pc-camera-pro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmcam: improve support for the IBM PC Camera Pro
From: David Hilvert <dhilvert@gmail.com>

This patch modifies Dmitri's original ibmcam driver for Linux to improve
support for the IBM PC Camera Pro.  It may also offer improved support for
other models classified by the driver as 'Model 3', such as the IBM PC Camera
Pro Max.

See http://auricle.dyndns.org/xvp610/

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvideo/ibmcam.c |   62 ++++++++++++++++++------
 1 file changed, 47 insertions(+), 15 deletions(-)

diff -puN drivers/media/video/usbvideo/ibmcam.c~ibmcam-improve-support-for-the-ibm-pc-camera-pro drivers/media/video/usbvideo/ibmcam.c
--- a/drivers/media/video/usbvideo/ibmcam.c~ibmcam-improve-support-for-the-ibm-pc-camera-pro
+++ a/drivers/media/video/usbvideo/ibmcam.c
@@ -802,6 +802,21 @@ static enum ParseState ibmcam_model2_320
 		return scan_Continue;
 }
 
+/*
+ * ibmcam_model3_parse_lines()
+ *
+ * | Even lines |     Odd Lines       |
+ * -----------------------------------|
+ * |YYY........Y|UYVYUYVY.........UYVY|
+ * |YYY........Y|UYVYUYVY.........UYVY|
+ * |............|.....................|
+ * |YYY........Y|UYVYUYVY.........UYVY|
+ * |------------+---------------------|
+ *
+ * There is one (U, V) chroma pair for every four luma (Y) values.  This
+ * function reads a pair of lines at a time and obtains missing chroma values
+ * from adjacent pixels.
+ */
 static enum ParseState ibmcam_model3_parse_lines(
 	struct uvd *uvd,
 	struct usbvideo_frame *frame,
@@ -816,6 +831,7 @@ static enum ParseState ibmcam_model3_par
 	const int ccm = 128; /* Color correction median - see below */
 	int i, u, v, rw, data_w=0, data_h=0, color_corr;
 	static unsigned char lineBuffer[640*3];
+	int line;
 
 	color_corr = (uvd->vpic.colour - 0x8000) >> 8; /* -128..+127 = -ccm..+(ccm-1)*/
 	RESTRICT_TO_RANGE(color_corr, -ccm, ccm+1);
@@ -869,15 +885,15 @@ static enum ParseState ibmcam_model3_par
 		return scan_NextFrame;
 	}
 
-	/* Make sure there's enough data for the entire line */
-	len = 3 * data_w; /* <y-data> <uv-data> */
+	/* Make sure that lineBuffer can store two lines of data */
+	len = 3 * data_w; /* <y-data> <uyvy-data> */
 	assert(len <= sizeof(lineBuffer));
 
-	/* Make sure there's enough data for the entire line */
+	/* Make sure there's enough data for two lines */
 	if (RingQueue_GetLength(&uvd->dp) < len)
 		return scan_Out;
 
-	/* Suck one line out of the ring queue */
+	/* Suck two lines of data out of the ring queue */
 	RingQueue_Dequeue(&uvd->dp, lineBuffer, len);
 
 	data = lineBuffer;
@@ -887,15 +903,23 @@ static enum ParseState ibmcam_model3_par
 	rw = (int)VIDEOSIZE_Y(frame->request) - (int)(frame->curline) - 1;
 	RESTRICT_TO_RANGE(rw, 0, VIDEOSIZE_Y(frame->request)-1);
 
-	for (i = 0; i < VIDEOSIZE_X(frame->request); i++) {
-		int y, rv, gv, bv;	/* RGB components */
+	/* Iterate over two lines. */
+	for (line = 0; line < 2; line++) {
+		for (i = 0; i < VIDEOSIZE_X(frame->request); i++) {
+			int y;
+			int rv, gv, bv;	/* RGB components */
+
+			if (i >= data_w) {
+				RGB24_PUTPIXEL(frame, i, rw, 0, 0, 0);
+				continue;
+			}
 
-		if (i < data_w) {
-			y = data[i];	/* Luminosity is the first line */
+			/* first line is YYY...Y; second is UYVY...UYVY */
+			y = data[(line == 0) ? i : (i*2 + 1)];
 
 			/* Apply static color correction */
-			u = color[i*2] + hue_corr;
-			v = color[i*2 + 1] + hue2_corr;
+			u = color[(i/2)*4] + hue_corr;
+			v = color[(i/2)*4 + 2] + hue2_corr;
 
 			/* Apply color correction */
 			if (color_corr != 0) {
@@ -903,13 +927,21 @@ static enum ParseState ibmcam_model3_par
 				u = 128 + ((ccm + color_corr) * (u - 128)) / ccm;
 				v = 128 + ((ccm + color_corr) * (v - 128)) / ccm;
 			}
-		} else
-			y = 0, u = v = 128;
 
-		YUV_TO_RGB_BY_THE_BOOK(y, u, v, rv, gv, bv);
-		RGB24_PUTPIXEL(frame, i, rw, rv, gv, bv); /* Done by deinterlacing now */
+
+			YUV_TO_RGB_BY_THE_BOOK(y, u, v, rv, gv, bv);
+			RGB24_PUTPIXEL(frame, i, rw, rv, gv, bv);  /* No deinterlacing */
+		}
+
+		/* Check for the end of requested data */
+		if (rw == 0)
+			break;
+
+		/* Prepare for the second line */
+		rw--;
+		data = lineBuffer + data_w;
 	}
-	frame->deinterlace = Deinterlace_FillEvenLines;
+	frame->deinterlace = Deinterlace_None;
 
 	/*
 	 * Account for number of bytes that we wrote into output V4L frame.
_

Patches currently in -mm which might be from dhilvert@gmail.com are

git-dvb.patch

