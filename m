From: akpm@linux-foundation.org
Subject: [merged] s3c-fb-pm-fix.patch removed from -mm tree
Date: Fri, 29 May 2009 11:43:11 -0700
Message-ID: <200905291843.n4TIhBXe011425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbZE2Swm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:52:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, ben-linux@fluff.org, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     S3C-fb: PM fix
has been removed from the -mm tree.  Its filename was
     s3c-fb-pm-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: S3C-fb: PM fix
From: Marek Szyprowski <m.szyprowski@samsung.com>

Correctly restore the FrameBuffer register state in the resume function.

Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-pm-fix drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-pm-fix
+++ a/drivers/video/s3c-fb.c
@@ -947,7 +947,8 @@ static int __devexit s3c_fb_remove(struc
 	int win;
 
 	for (win = 0; win <= S3C_FB_MAX_WIN; win++)
-		s3c_fb_release_win(sfb, sfb->windows[win]);
+		if (sfb->windows[win])
+			s3c_fb_release_win(sfb, sfb->windows[win]);
 
 	iounmap(sfb->regs);
 
@@ -985,11 +986,20 @@ static int s3c_fb_suspend(struct platfor
 static int s3c_fb_resume(struct platform_device *pdev)
 {
 	struct s3c_fb *sfb = platform_get_drvdata(pdev);
+	struct s3c_fb_platdata *pd = sfb->pdata;
 	struct s3c_fb_win *win;
 	int win_no;
 
 	clk_enable(sfb->bus_clk);
 
+	/* setup registers */
+	writel(pd->vidcon1, sfb->regs + VIDCON1);
+
+	/* zero all windows before we do anything */
+	for (win_no = 0; win_no < S3C_FB_MAX_WIN; win_no++)
+		s3c_fb_clear_win(sfb, win_no);
+
+	/* restore framebuffers */
 	for (win_no = 0; win_no < S3C_FB_MAX_WIN; win_no++) {
 		win = sfb->windows[win_no];
 		if (!win)
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
s3c-fb-fix-resource-releasing-on-error-during-probing.patch

