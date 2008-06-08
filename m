From: akpm@linux-foundation.org
Subject: - vt-fix-background-color-on-line-feed-dec-invert.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:34 -0700
Message-ID: <200806081948.m58JmYtn017516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243AbYFHTsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@medozas.de, thunder7@xs4all.nl, mm-commits@vger.kernel.org


The patch titled
     vt: fix background color on line feed, DEC invert
has been removed from the -mm tree.  Its filename was
     vt-fix-background-color-on-line-feed-dec-invert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: fix background color on line feed, DEC invert
From: Jan Engelhardt <jengelh@medozas.de>

Original report: """I used to force my console to black-on-white by the
command `setterm -inversescreen on`.  In 2.6.26-rc4, I get lots of black
background characters."""

Another addendum to commit c9e587ab.  This was previously missed out since
I was not aware of what vc_decscnm was for.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Reported-by: <thunder7@xs4all.nl>
Tested-by: <thunder7@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/vt.c~vt-fix-background-color-on-line-feed-dec-invert drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-background-color-on-line-feed-dec-invert
+++ a/drivers/char/vt.c
@@ -434,7 +434,7 @@ static void update_attr(struct vc_data *
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
-	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, false, false) << 8) | ' ';
+	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, vc->vc_decscnm, false) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
_

Patches currently in -mm which might be from jengelh@medozas.de are

origin.patch
fs-make-struct-file-arg-to-d_path-const.patch

