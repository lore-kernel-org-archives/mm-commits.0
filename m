From: akpm@linux-foundation.org
Subject: [folded-dropped] aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:04:11 -0700
Message-ID: <20121005000411.9F7F11E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46129 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2JEAEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:04:12 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so130124qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:04:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: cleanup an allocation a bit
has been removed from the -mm tree.  Its filename was
     aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch

This patch was dropped because it was folded into aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch

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
@@ -1157,9 +1157,8 @@ addtgt(struct aoedev *d, char *addr, ulo
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
checkpatch-update-suggested-printk-conversions.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch

