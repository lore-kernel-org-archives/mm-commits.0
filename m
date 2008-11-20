From: akpm@linux-foundation.org
Subject: - drivers-video-bad-error-test-before-a-dereference.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:06 -0800
Message-ID: <200811202042.mAKKg6wV006732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753756AbYKTUmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:42:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brunel@diku.dk, julia@diku.dk, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video: bad error test before a dereference
has been removed from the -mm tree.  Its filename was
     drivers-video-bad-error-test-before-a-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video: bad error test before a dereference
From: Julien Brunel <brunel@diku.dk>

The error test that follows the call to backlight_device_register semms
not to concern the right variable.

A simplified version of the semantic match that finds this problem is
as follows:
(http://www.emn.fr/x-info/coccinelle/)
// <smpl>
@def0@
expression x;
position p0;
@@
x@p0 = backlight_device_register(...)

@protected@
expression def0.x,E;
position def0.p0;
position p;
statement S;
@@
x@p0
... when != x = E
if (!IS_ERR(x) && ...) {<... x@p ...>} else S

@unprotected@
expression def0.x;
identifier fld;
position def0.p0;
position p != protected.p;
@@
x@p0
... when != x = E
* x@p->fld
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~drivers-video-bad-error-test-before-a-dereference drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~drivers-video-bad-error-test-before-a-dereference
+++ a/drivers/video/atmel_lcdfb.c
@@ -132,7 +132,7 @@ static void init_backlight(struct atmel_
 
 	bl = backlight_device_register("backlight", &sinfo->pdev->dev,
 			sinfo, &atmel_lcdc_bl_ops);
-	if (IS_ERR(sinfo->backlight)) {
+	if (IS_ERR(bl)) {
 		dev_err(&sinfo->pdev->dev, "error %ld on backlight register\n",
 				PTR_ERR(bl));
 		return;
_

Patches currently in -mm which might be from brunel@diku.dk are

origin.patch

