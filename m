From: akpm@linux-foundation.org
Subject: - drivers-media-video-gspca-zc3xxc-fix-oops.patch removed from -mm tree
Date: Mon, 18 Aug 2008 23:49:48 -0700
Message-ID: <200808190649.m7J6nmf9003201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbYHSGuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 02:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: parag.warudkar@gmail.com, mchehab@infradead.org, moinejf@free.fr, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/gspca/zc3xx.c: fix oops
has been removed from the -mm tree.  Its filename was
     drivers-media-video-gspca-zc3xxc-fix-oops.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/gspca/zc3xx.c: fix oops
From: "Parag Warudkar" <parag.warudkar@gmail.com>

Fix a couple of NULL pointer dereferences in zc3xx.

Without this patch my machine oopses as soon as I open Kopete-kde4. 
Patch tested to work fine (no detectable differences in image rendered by
camera - as crappy as ever, no more oopses ;) on x86 with a Creative
Webcam Notebook.

OOPS Analysis
-------------------
http://marc.info/?l=linux-kernel&m=121769418920774&w=4

4575.306109] Code: 83 ec 04 0f b6 90 da 07 00 00 8b a8 04 02 00 00 0f
b6 80 d9 07 00 00 8b 3c 95 f4 dc 15 f9 8b 14 95 d8 dc 15 f9 83 c0 80
89 14 24 <0f> b6 37 0f af f0 8d b6 00 00 00 00 0f b6 83 00 dc 15 f9 0f
af
[ 4575.306133] EIP: [<f915c2d4>] setcontrast+0x34/0xf0 [gspca_zc3xx]
SS:ESP 0068:da81bd64

Which corresponds to -

1374: 0f b6 37 movzbl (%edi),%esi
--^^-- Faulting instruction
1377: 0f af f0 imul %eax,%esi
137a: 8d b6 00 00 00 00 lea 0x0(%esi),%esi

That is this code in zc3xx.c -
k = (sd->contrast - 128) /* -128 / 128 */
                    * Tgamma[0];

Where Tgamma = gamma_tb[sd->gamma];

For sd->gamma=0 Tgamma is NULL -

static const __u8 *gamma_tb[] = {
NULL, ...

Kopete seems to trigger the zero gamma on ioctl and we happily oops in
that case.

Fix this by detecting the zero gamma case while trying to preserve
intended effect of zero gamma.

On reviewing the code, the exact same problem exists for Tgradient where
it is dereferenced when NULL.  Fix that too.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/zc3xx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/gspca/zc3xx.c~drivers-media-video-gspca-zc3xxc-fix-oops drivers/media/video/gspca/zc3xx.c
--- a/drivers/media/video/gspca/zc3xx.c~drivers-media-video-gspca-zc3xxc-fix-oops
+++ a/drivers/media/video/gspca/zc3xx.c
@@ -6476,12 +6476,15 @@ static void setcontrast(struct gspca_dev
 	Tgamma = gamma_tb[sd->gamma];
 	Tgradient = gradient_tb[sd->gamma];
 
-	k = (sd->contrast - 128)		/* -128 / 128 */
+	if(!Tgamma)
+		k = 0;
+	else
+		k = (sd->contrast - 128)		/* -128 / 128 */
 			* Tgamma[0];
 	PDEBUG(D_CONF, "gamma:%d contrast:%d gamma coeff: %d/128",
 		sd->gamma, sd->contrast, k);
 	for (i = 0; i < 16; i++) {
-		g = Tgamma[i] + kgamma_tb[i] * k / 128;
+		g = (Tgamma ? Tgamma[i] : 0) + kgamma_tb[i] * k / 128;
 		if (g > 0xff)
 			g = 0xff;
 		else if (g <= 0)
@@ -6497,7 +6500,7 @@ static void setcontrast(struct gspca_dev
 	PDEBUG(D_CONF, "    %02x %02x %02x %02x %02x %02x %02x %02x",
 		v[8], v[9], v[10], v[11], v[12], v[13], v[14], v[15]);
 	for (i = 0; i < 16; i++) {
-		g = Tgradient[i] - kgrad_tb[i] * k / 128;
+		g = (Tgradient ? Tgradient[i] : 0) - kgrad_tb[i] * k / 128;
 		if (g > 0xff)
 			g = 0xff;
 		else if (g <= 0) {
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

drivers-media-video-gspca-zc3xxc-fix-oops.patch
drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes.patch

