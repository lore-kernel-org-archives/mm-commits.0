From: akpm@linux-foundation.org
Subject: [merged] swapfile-fix-name-leak-in-swapoff.patch removed from -mm tree
Date: Mon, 19 Nov 2012 12:21:43 -0800
Message-ID: <20121119202143.C4BCF82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45068 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2KSUVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:21:45 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so600849yen.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:21:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xtfeng@gmail.com, dannyfeng@tencent.com, jlayton@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: fix name leak in swapoff
has been removed from the -mm tree.  Its filename was
     swapfile-fix-name-leak-in-swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaotian Feng <xtfeng@gmail.com>
Subject: swapfile: fix name leak in swapoff

There's a name leak introduced by 91a27b2 ("vfs: define struct filename
and have getname() return it").  Add the missing putname.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~swapfile-fix-name-leak-in-swapoff mm/swapfile.c
--- a/mm/swapfile.c~swapfile-fix-name-leak-in-swapoff
+++ a/mm/swapfile.c
@@ -1494,9 +1494,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	BUG_ON(!current->mm);
 
 	pathname = getname(specialfile);
-	err = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
-		goto out;
+		return PTR_ERR(pathname);
 
 	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
 	err = PTR_ERR(victim);
@@ -1608,6 +1607,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 out_dput:
 	filp_close(victim, NULL);
 out:
+	putname(pathname);
 	return err;
 }
 
_

Patches currently in -mm which might be from xtfeng@gmail.com are

linux-next.patch
tasklet-ignore-disabled-tasklet-in-tasklet_action.patch

