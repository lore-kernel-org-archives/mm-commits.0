From: akpm@linux-foundation.org
Subject: + s3c-fb-fix-off-by-one-bug-in-loop-indexes.patch added to -mm tree
Date: Fri, 17 Jul 2009 16:28:38 -0700
Message-ID: <200907172328.n6HNScZj005688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbZGQX3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 19:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, krzysztof.h1@poczta.fm, kyungmin.park@samsung.com, m.szyprowski@samsung.com, rmk@arm.linux.org.uk


The patch titled
     s3c-fb: fix off-by-one bug in loop indexes
has been added to the -mm tree.  Its filename is
     s3c-fb-fix-off-by-one-bug-in-loop-indexes.patch

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
Subject: s3c-fb: fix off-by-one bug in loop indexes
From: Pawel Osciak <p.osciak@samsung.com>

Fixed off-by-one bug in loop indexes - some elements beyond windows' array
were accessed, which might result in memory access violations when
removing/suspending the device.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-fix-off-by-one-bug-in-loop-indexes drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-fix-off-by-one-bug-in-loop-indexes
+++ a/drivers/video/s3c-fb.c
@@ -964,7 +964,7 @@ static int __devexit s3c_fb_remove(struc
 	struct s3c_fb *sfb = platform_get_drvdata(pdev);
 	int win;
 
-	for (win = 0; win <= S3C_FB_MAX_WIN; win++)
+	for (win = 0; win < S3C_FB_MAX_WIN; win++)
 		if (sfb->windows[win])
 			s3c_fb_release_win(sfb, sfb->windows[win]);
 
@@ -988,7 +988,7 @@ static int s3c_fb_suspend(struct platfor
 	struct s3c_fb_win *win;
 	int win_no;
 
-	for (win_no = S3C_FB_MAX_WIN; win_no >= 0; win_no--) {
+	for (win_no = S3C_FB_MAX_WIN - 1; win_no >= 0; win_no--) {
 		win = sfb->windows[win_no];
 		if (!win)
 			continue;
_

Patches currently in -mm which might be from p.osciak@samsung.com are

s3c-fb-fix-off-by-one-bug-in-loop-indexes.patch

