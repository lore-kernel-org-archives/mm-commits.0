From: akpm@linux-foundation.org
Subject: + drivers-media-use-array_size.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:18:21 -0800
Message-ID: <200811122318.mACNILWw017694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYKLXSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:18:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media: use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     drivers-media-use-array_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>


ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/tuners/mxl5005s.c        |    6 +++---
 drivers/media/video/gspca/gspca.c             |    2 +-
 drivers/media/video/gspca/mars.c              |    2 +-
 drivers/media/video/gspca/spca500.c           |    4 ++--
 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/media/common/tuners/mxl5005s.c~drivers-media-use-array_size drivers/media/common/tuners/mxl5005s.c
--- a/drivers/media/common/tuners/mxl5005s.c~drivers-media-use-array_size
+++ a/drivers/media/common/tuners/mxl5005s.c
@@ -3598,7 +3598,7 @@ static u16 MXL_GetInitRegister(struct dv
 		76, 77, 91, 134, 135, 137, 147,
 		156, 166, 167, 168, 25 };
 
-	*count = sizeof(RegAddr) / sizeof(u8);
+	*count = ARRAY_SIZE(RegAddr);
 
 	status += MXL_BlockInit(fe);
 
@@ -3630,7 +3630,7 @@ static u16 MXL_GetCHRegister(struct dvb_
 	*/
 #endif
 
-	*count = sizeof(RegAddr) / sizeof(u8);
+	*count = ARRAY_SIZE(RegAddr);
 
 	for (i = 0 ; i < *count; i++) {
 		RegNum[i] = RegAddr[i];
@@ -3648,7 +3648,7 @@ static u16 MXL_GetCHRegister_ZeroIF(stru
 
 	u8 RegAddr[] = {43, 136};
 
-	*count = sizeof(RegAddr) / sizeof(u8);
+	*count = ARRAY_SIZE(RegAddr);
 
 	for (i = 0; i < *count; i++) {
 		RegNum[i] = RegAddr[i];
diff -puN drivers/media/video/gspca/gspca.c~drivers-media-use-array_size drivers/media/video/gspca/gspca.c
--- a/drivers/media/video/gspca/gspca.c~drivers-media-use-array_size
+++ a/drivers/media/video/gspca/gspca.c
@@ -737,7 +737,7 @@ static int vidioc_enum_fmt_vid_cap(struc
 			if (fmtdesc->index == index)
 				break;		/* new format */
 			index++;
-			if (index >= sizeof fmt_tb / sizeof fmt_tb[0])
+			if (index >= ARRAY_SIZE(fmt_tb))
 				return -EINVAL;
 		}
 	}
diff -puN drivers/media/video/gspca/mars.c~drivers-media-use-array_size drivers/media/video/gspca/mars.c
--- a/drivers/media/video/gspca/mars.c~drivers-media-use-array_size
+++ a/drivers/media/video/gspca/mars.c
@@ -123,7 +123,7 @@ static int sd_config(struct gspca_dev *g
 	cam = &gspca_dev->cam;
 	cam->epaddr = 0x01;
 	cam->cam_mode = vga_mode;
-	cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+	cam->nmodes = ARRAY_SIZE(vga_mode);
 	sd->qindex = 1;			/* set the quantization table */
 	return 0;
 }
diff -puN drivers/media/video/gspca/spca500.c~drivers-media-use-array_size drivers/media/video/gspca/spca500.c
--- a/drivers/media/video/gspca/spca500.c~drivers-media-use-array_size
+++ a/drivers/media/video/gspca/spca500.c
@@ -633,10 +633,10 @@ static int sd_config(struct gspca_dev *g
 	sd->subtype = id->driver_info;
 	if (sd->subtype != LogitechClickSmart310) {
 		cam->cam_mode = vga_mode;
-		cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+		cam->nmodes = ARRAY_SIZE(vga_mode);
 	} else {
 		cam->cam_mode = sif_mode;
-		cam->nmodes = sizeof sif_mode / sizeof sif_mode[0];
+		cam->nmodes = ARRAY_SIZE(sif_mode);
 	}
 	sd->qindex = 5;
 	sd->brightness = BRIGHTNESS_DEF;
diff -puN drivers/media/video/saa7134/saa7134-tvaudio.c~drivers-media-use-array_size drivers/media/video/saa7134/saa7134-tvaudio.c
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c~drivers-media-use-array_size
+++ a/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -159,7 +159,7 @@ static struct saa7134_tvaudio tvaudio[] 
 		.mode          = TVAUDIO_FM_MONO,
 	}
 };
-#define TVAUDIO (sizeof(tvaudio)/sizeof(struct saa7134_tvaudio))
+#define TVAUDIO ARRAY_SIZE(tvaudio)
 
 /* ------------------------------------------------------------------ */
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
crypto-md4c-use-array_size.patch

