From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-null-pointer-dereferrence-in-__ocfs2_change_file_space.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:32 -0700
Message-ID: <20120712193632.BF66E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:61302 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2GLTgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:33 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so266112ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luis.henriques@canonical.com, jlbec@evilplan.org, magnade@gmail.com, mfasheh@suse.com, stable@vger.kernel.org, sunil.mushran@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix NULL pointer dereference in __ocfs2_change_file_space()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereferrence-in-__ocfs2_change_file_space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Henriques <luis.henriques@canonical.com>
Subject: ocfs2: fix NULL pointer dereference in __ocfs2_change_file_space()

As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
as the first parameter (file), it may trigger a NULL pointer dereferrence
due to a missing check.

Addresses http://bugs.launchpad.net/bugs/1006012

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Reported-by: Bret Towe <magnade@gmail.com>
Tested-by: Bret Towe <magnade@gmail.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-null-pointer-dereferrence-in-__ocfs2_change_file_space fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-null-pointer-dereferrence-in-__ocfs2_change_file_space
+++ a/fs/ocfs2/file.c
@@ -1950,7 +1950,7 @@ static int __ocfs2_change_file_space(str
 	if (ret < 0)
 		mlog_errno(ret);
 
-	if (file->f_flags & O_SYNC)
+	if (file && (file->f_flags & O_SYNC))
 		handle->h_sync = 1;
 
 	ocfs2_commit_trans(osb, handle);
_

Patches currently in -mm which might be from luis.henriques@canonical.com are

origin.patch
linux-next.patch

