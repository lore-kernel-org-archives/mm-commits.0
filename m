From: akpm@linux-foundation.org
Subject: + autofs-use-is_root-to-replace-root-dentry-checks.patch added to -mm tree
Date: Tue, 03 Dec 2013 13:30:38 -0800
Message-ID: <529e4d7e.6YfTOGsCCFny7j28%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3LCVaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 16:30:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, rui.xiang@huawei.com

Subject: + autofs-use-is_root-to-replace-root-dentry-checks.patch added to -mm tree
To: rui.xiang@huawei.com,raven@themaw.net
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 13:30:38 -0800


The patch titled
     Subject: autofs: use IS_ROOT to replace root dentry checks
has been added to the -mm tree.  Its filename is
     autofs-use-is_root-to-replace-root-dentry-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-use-is_root-to-replace-root-dentry-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-use-is_root-to-replace-root-dentry-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rui Xiang <rui.xiang@huawei.com>
Subject: autofs: use IS_ROOT to replace root dentry checks

Use the helper macro !IS_ROOT to replace parent != dentry->d_parent.  Just
clean up.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/root.c~autofs-use-is_root-to-replace-root-dentry-checks fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-use-is_root-to-replace-root-dentry-checks
+++ a/fs/autofs4/root.c
@@ -558,7 +558,7 @@ static int autofs4_dir_symlink(struct in
 	dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
+	if (p_ino && !IS_ROOT(dentry))
 		atomic_inc(&p_ino->count);
 
 	dir->i_mtime = CURRENT_TIME;
@@ -593,7 +593,7 @@ static int autofs4_dir_unlink(struct ino
 
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
-		if (p_ino && dentry->d_parent != dentry)
+		if (p_ino && !IS_ROOT(dentry))
 			atomic_dec(&p_ino->count);
 	}
 	dput(ino->dentry);
@@ -732,7 +732,7 @@ static int autofs4_dir_mkdir(struct inod
 	dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
+	if (p_ino && !IS_ROOT(dentry))
 		atomic_inc(&p_ino->count);
 	inc_nlink(dir);
 	dir->i_mtime = CURRENT_TIME;
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

autofs-fix-the-return-value-of-autofs4_fill_super.patch
autofs-use-is_root-to-replace-root-dentry-checks.patch

