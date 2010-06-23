From: akpm@linux-foundation.org
Subject: + fbcon-deinline-large-static-function-get_color.patch added to -mm tree
Date: Wed, 23 Jun 2010 13:01:15 -0700
Message-ID: <201006232001.o5NK1FbF028587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab0FWUBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 16:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com


The patch titled
     fbcon: uninline large static function get_color()
has been added to the -mm tree.  Its filename is
     fbcon-deinline-large-static-function-get_color.patch

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
Subject: fbcon: uninline large static function get_color()
From: Denys Vlasenko <vda.linux@googlemail.com>

This function's body is good two screenfuls and it has six callsites.  No
apparent reason why it is marked inline.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-deinline-large-static-function-get_color drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-deinline-large-static-function-get_color
+++ a/drivers/video/console/fbcon.c
@@ -287,7 +287,7 @@ static inline int fbcon_is_inactive(stru
 		!vt_force_oops_output(vc);
 }
 
-static inline int get_color(struct vc_data *vc, struct fb_info *info,
+static int get_color(struct vc_data *vc, struct fb_info *info,
 	      u16 c, int is_fg)
 {
 	int depth = fb_get_color_depth(&info->var, &info->fix);
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

modpost-support-objects-with-more-than-64k-sections.patch
fbcon-deinline-large-static-function-get_color.patch

