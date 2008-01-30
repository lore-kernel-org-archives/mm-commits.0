From: akpm@linux-foundation.org
Subject: + ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch added to -mm tree
Date: Wed, 30 Jan 2008 15:43:15 -0800
Message-ID: <200801302343.m0UNhFbl030781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764032AbYA3Xog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 18:44:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, girish@clusterfs.com, sandeen@sgi.com, snakebyte@gmx.de, stable@kernel.org, tytso@mit.edu


The patch titled
     ext4: fix NULL pointer deref in journal_wait_on_commit_record()
has been added to the -mm tree.  Its filename is
     ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix NULL pointer deref in journal_wait_on_commit_record()
From: Mingming Cao <cmm@us.ibm.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=9849

The buffer head pointer passed to journal_wait_on_commit_record() could be
NULL if the previous journal_submit_commit_record() failed or journal has
already aborted.

We need to check the error returns from journal_submit_commit_record() and
avoid calling journal_wait_on_commit_record() in the failure case.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Eric Sandeen <sandeen@sgi.com>
Cc: Girish Shilamkar <girish@clusterfs.com>
Cc: <snakebyte@gmx.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/jbd2/commit.c~ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record
+++ a/fs/jbd2/commit.c
@@ -870,7 +870,8 @@ wait_for_iobuf:
 		if (err)
 			__jbd2_journal_abort_hard(journal);
 	}
-	err = journal_wait_on_commit_record(cbh);
+	if (!err && !is_journal_aborted(journal))
+		err = journal_wait_on_commit_record(cbh);
 
 	if (err)
 		jbd2_journal_abort(journal, err);
_

Patches currently in -mm which might be from cmm@us.ibm.com are

export-iov_shorten-for-ext4s-use.patch
export-iov_shorten-for-ext4s-use-fix.patch
ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch
