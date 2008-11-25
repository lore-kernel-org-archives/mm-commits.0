From: akpm@linux-foundation.org
Subject: + fix-fb-console-blanking.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:45:34 -0800
Message-ID: <200811252245.mAPMjYM7021693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYKYWqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:46:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, geert@linux-m68k.org


The patch titled
     fbdev: fix FB console blanking
has been added to the -mm tree.  Its filename is
     fix-fb-console-blanking.patch

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
@@ -2324,16 +2324,13 @@ static int fbcon_blank(struct vc_data *v
 
  	if (!fbcon_is_inactive(vc, info)) {
 		if (ops->blank_state != blank) {
-			int ret = 1;
