From: akpm@linux-foundation.org
Subject: + ocfs2-fix-null-pointer-dereferrence-in-__ocfs2_change_file_space.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:43:02 -0700
Message-ID: <20120620224302.B31D1A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36918 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab2FTWnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:43:05 -0400
Received: by wibhn6 with SMTP id hn6so272500wib.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:43:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luis.henriques@canonical.com, jlbec@evilplan.org, magnade@gmail.com, mfasheh@suse.com, stable@vger.kernel.org, sunil.mushran@oracle.com


The patch titled
     Subject: ocfs2: fix NULL pointer dereferrence in __ocfs2_change_file_space()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-null-pointer-dereferrence-in-__ocfs2_change_file_space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Henriques <luis.henriques@canonical.com>
Subject: ocfs2: fix NULL pointer dereferrence in __ocfs2_change_file_space()

As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
as the first parameter (file), it may trigger a NULL pointer dereferrence
due to a missing check.

Addresses http://bugs.launchpad.net/bugs/1006012

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Reported-by: Bret Towe <magnade@gmail.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
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
Subject: Subject: ocfs2: fix NULL pointer dereferrence in __ocfs2_change_file_space()

Patches currently in -mm which might be from luis.henriques@canonical.com are

ocfs2-fix-null-pointer-dereferrence-in-__ocfs2_change_file_space.patch

