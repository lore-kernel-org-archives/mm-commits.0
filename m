From: akpm@linux-foundation.org
Subject: + aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch added to -mm tree
Date: Tue, 11 Sep 2012 15:24:24 -0700
Message-ID: <20120911222424.997A8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39358 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IKWY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 18:24:26 -0400
Received: by yhl10 with SMTP id 10so118791yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 15:24:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, ecashin@coraid.com


The patch titled
     Subject: aoe: cleanup an allocation a bit
has been added to the -mm tree.  Its filename is
     aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: aoe: cleanup an allocation a bit

We changed this recently so we can just use kzalloc() here instead of
kcalloc(1, ...).  Kernel style prefers sizeof(*t) over sizeof *t.  The
kfree(t) is a no-op now as well so that can be removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix
+++ a/drivers/block/aoe/aoecmd.c
@@ -1156,9 +1156,8 @@ addtgt(struct aoedev *d, char *addr, ulo
 			"aoe: device addtgt failure; too many targets\n");
 		return NULL;
 	}
-	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
+	t = kzalloc(sizeof(*t), GFP_ATOMIC);
 	if (!t) {
-		kfree(t);
 		printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
 		return NULL;
 	}
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
drivers-scsi-iprc-missing-unlock-before-a-return.patch
drivers-scsi-iprc-remove-an-unneeded-check.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch

