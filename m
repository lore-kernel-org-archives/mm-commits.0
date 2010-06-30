From: akpm@linux-foundation.org
Subject: + drivers-video-fbmemc-simplify-strlen==0-check-in-fb_get_options.patch added to -mm tree
Date: Wed, 30 Jun 2010 15:52:43 -0700
Message-ID: <201006302252.o5UMqhSa031176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757366Ab0F3Wxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 18:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com


The patch titled
     drivers/video/fbmem.c: simplify strlen()==0 check in fb_get_options()
has been added to the -mm tree.  Its filename is
     drivers-video-fbmemc-simplify-strlen==0-check-in-fb_get_options.patch

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
Subject: drivers/video/fbmem.c: simplify strlen()==0 check in fb_get_options()
From: Denys Vlasenko <vda.linux@googlemail.com>

Replaced !strlen(str) check with !str[0].  Removed the variable which was
used solely to store strlen result.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/fbmem.c~drivers-video-fbmemc-simplify-strlen==0-check-in-fb_get_options drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~drivers-video-fbmemc-simplify-strlen==0-check-in-fb_get_options
+++ a/drivers/video/fbmem.c
@@ -1786,7 +1786,7 @@ static int ofonly __read_mostly;
 int fb_get_options(char *name, char **option)
 {
 	char *opt, *options = NULL;
-	int opt_len, retval = 0;
+	int retval = 0;
 	int name_len = strlen(name), i;
 
 	if (name_len && ofonly && strncmp(name, "offb", 4))
@@ -1796,8 +1796,7 @@ int fb_get_options(char *name, char **op
 		for (i = 0; i < FB_MAX; i++) {
 			if (video_options[i] == NULL)
 				continue;
-			opt_len = strlen(video_options[i]);
-			if (!opt_len)
+			if (!video_options[i][0])
 				continue;
 			opt = video_options[i];
 			if (!strncmp(name, opt, name_len) &&
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

modpost-support-objects-with-more-than-64k-sections.patch
fbcon-deinline-large-static-function-get_color.patch
fbcon-uninline-four-foo_update_attr-functions.patch
drivers-video-fbmemc-simplify-strlen==0-check-in-fb_get_options.patch

