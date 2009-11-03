From: akpm@linux-foundation.org
Subject: + drivers-video-move-dereference-after-null-test.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:24:21 -0800
Message-ID: <200911030624.nA36OMDk029789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbZKCGYr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:24:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, daniel@caiaq.de, eric.y.miao@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     drivers/video: Move dereference after NULL test
has been added to the -mm tree.  Its filename is
     drivers-video-move-dereference-after-null-test.patch

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
Subject: drivers/video: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

If the NULL test on fbi is needed, then the dereference should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/pxafb.c~drivers-video-move-dereference-after-null-test drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~drivers-video-move-dereference-after-null-test
+++ a/drivers/video/pxafb.c
@@ -1208,13 +1208,14 @@ static void setup_smart_timing(struct px
 static int pxafb_smart_thread(void *arg)
 {
 	struct pxafb_info *fbi = arg;
-	struct pxafb_mach_info *inf = fbi->dev->platform_data;
+	struct pxafb_mach_info *inf;
 
-	if (!fbi || !inf->smart_update) {
+	if (!fbi || !fbi->dev->platform_data->smart_update) {
 		pr_err("%s: not properly initialized, thread terminated\n",
 				__func__);
 		return -EINVAL;
 	}
+	inf = fbi->dev->platform_data;
 
 	pr_debug("%s(): task starting\n", __func__);
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-message-move-dereference-after-null-test.patch
drivers-acpi-move-dereference-after-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-cpuidle-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-ata-libata-move-dereference-after-null-test.patch
drivers-scsi-remove-unnecessary-null-test.patch
arch-arm-plat-omap-drop-an-unnecessary-null-test.patch
arch-arm-plat-s3c24xx-move-dereference-after-null-test.patch

