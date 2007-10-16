From: akpm@linux-foundation.org
Subject: - drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:55 -0700
Message-ID: <200710162042.l9GKgt1r015928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935850AbXJPVH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugeneteo@kernel.sg, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/geode/lxfb_core.c: fix lxfb_setup warning
has been removed from the -mm tree.  Its filename was
     drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/geode/lxfb_core.c: fix lxfb_setup warning
From: Eugene Teo <eugeneteo@kernel.sg>

drivers/video/geode/lxfb_core.c: In function 'lxfb_setup':
drivers/video/geode/lxfb_core.c:564: warning: unused variable 'opt'

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/video/geode/lxfb_core.c~drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning
+++ a/drivers/video/geode/lxfb_core.c
@@ -566,12 +566,7 @@ static int __init lxfb_setup(char *optio
 	if (!options || !*options)
 		return 0;
 
-	while (1) {
-		char *opt = strsep(&options, ",");
-
-		if (opt == NULL)
-			break;
-
+	while ((opt = strsep(&options, ",")) != NULL) {
 		if (!*opt)
 			continue;
 
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

origin.patch
git-alsa.patch
fix-tsk-exit_state-usage-resend.patch
