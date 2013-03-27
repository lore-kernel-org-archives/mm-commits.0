From: akpm@linux-foundation.org
Subject: + drivers-video-mmp-corec-fix-use-after-free-bug.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:54:17 -0700
Message-ID: <20130327205417.6DC6531C254@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:38432 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3C0UyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:54:18 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so873068vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:54:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: epure.andrei@gmail.com, FlorianSchandinat@gmx.de


The patch titled
     Subject: drivers/video/mmp/core.c: fix use-after-free bug
has been added to the -mm tree.  Its filename is
     drivers-video-mmp-corec-fix-use-after-free-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
