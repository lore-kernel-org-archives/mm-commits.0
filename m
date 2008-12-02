From: akpm@linux-foundation.org
Subject: - fix-fb-console-blanking.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:39:03 -0800
Message-ID: <200812021839.mB2Id3rh007266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126AbYLBSjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix FB console blanking
has been removed from the -mm tree.  Its filename was
     fix-fb-console-blanking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: fix FB console blanking
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

The commit aef7db4bd5a3b6068dfa05919a3d685199eed116 fixed the problem with
recursive locking in fb blanking code if blank is caused by user setting
the /sys/class/graphics/fb*/blank.  However this broke the fbcon timeout
blanking.

If you use a driver that defines ->fb_blank operation and at the same time
that driver relies on other driver (e.g.  backlight or lcd class) to blank
the screen, when the fbcon times out and tries to blank the fb, it will
call only fb driver blanker and won't notify the other driver.  Thus FB
output is disabled, but the screen isn't blanked.

Restore fbcon blanking and at the same time apply the proper fix for the
above problem: if fbcon_blank is called with FBINFO_FLAG_USEREVENT, we are
already called through notification from fb_blank, thus we don't have to
blank the fb again.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/console/fbcon.c~fix-fb-console-blanking drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fix-fb-console-blanking
+++ a/drivers/video/console/fbcon.c
@@ -2389,16 +2389,13 @@ static int fbcon_blank(struct vc_data *v
 
  	if (!fbcon_is_inactive(vc, info)) {
 		if (ops->blank_state != blank) {
-			int ret = 1;
