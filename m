From: akpm@linux-foundation.org
Subject: [merged] drivers-video-mmp-corec-fix-use-after-free-bug.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:37 -0700
Message-ID: <20130422200637.73D6B31C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:33317 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab3DVUGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:48 -0400
Received: by mail-ia0-f201.google.com with SMTP id n19so863690ian.4
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: epure.andrei@gmail.com, FlorianSchandinat@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/mmp/core.c: fix use-after-free bug
has been removed from the -mm tree.  Its filename was
     drivers-video-mmp-corec-fix-use-after-free-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrei Epure <epure.andrei@gmail.com>
Subject: drivers/video/mmp/core.c: fix use-after-free bug

Found with coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mmp/core.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/mmp/core.c~drivers-video-mmp-corec-fix-use-after-free-bug drivers/video/mmp/core.c
--- a/drivers/video/mmp/core.c~drivers-video-mmp-corec-fix-use-after-free-bug
+++ a/drivers/video/mmp/core.c
@@ -252,7 +252,5 @@ void mmp_unregister_path(struct mmp_path
 
 	kfree(path);
 	mutex_unlock(&disp_lock);
