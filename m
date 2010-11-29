From: akpm@linux-foundation.org
Subject: [merged] backlight-grab-ops_lock-before-testing-bd-ops.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:28 -0800
Message-ID: <201011291951.oATJpvwj007339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752869Ab0K2Twj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:52:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, rpurdie@linux.intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     backlight: grab ops_lock before testing bd->ops
has been removed from the -mm tree.  Its filename was
     backlight-grab-ops_lock-before-testing-bd-ops.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: backlight: grab ops_lock before testing bd->ops
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

According to the comment describing ops_lock in the definition of struc=
t
backlight_device and when comparing with other functions in backlight.c
the mutex must be hold when checking ops to be non-NULL.

=46ixes a problem added by c835ee7f4154992e6 ("backlight: Add suspend/r=
esume
support to the backlight core") in Jan 2009.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-grab-ops_lock-b=
efore-testing-bd-ops drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-grab-ops_lock-befor=
e-testing-bd-ops
+++ a/drivers/video/backlight/backlight.c
@@ -197,12 +197,12 @@ static int backlight_suspend(struct devi
 {
 	struct backlight_device *bd =3D to_backlight_device(dev);
=20
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state |=3D BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
=20
 	return 0;
 }
@@ -211,12 +211,12 @@ static int backlight_resume(struct devic
 {
 	struct backlight_device *bd =3D to_backlight_device(dev);
=20
-	if (bd->ops->options & BL_CORE_SUSPENDRESUME) {
-		mutex_lock(&bd->ops_lock);
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state &=3D ~BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
-		mutex_unlock(&bd->ops_lock);
 	}
+	mutex_unlock(&bd->ops_lock);
=20
 	return 0;
 }
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
