From: akpm@linux-foundation.org
Subject: + drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch added to -mm tree
Date: Fri, 03 Aug 2007 10:43:40 -0700
Message-ID: <200708031743.l73HheIw020116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760163AbXHCRn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 13:43:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eugeneteo@kernel.sg, adaplas@pol.net


The patch titled
     drivers/video/geode/lxfb_core.c: fix lxfb_setup warning
has been added to the -mm tree.  Its filename is
     drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 6 deletions(-)

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
fs-partitions-checkc-add-add_partition-error-handling.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch
