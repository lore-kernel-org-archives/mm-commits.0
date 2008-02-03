From: akpm@linux-foundation.org
Subject: - ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:57 -0800
Message-ID: <200802032022.m13KMcBv030028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbYBCU1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:27:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, girish@clusterfs.com, sandeen@sgi.com, snakebyte@gmx.de, stable@kernel.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext4: fix NULL pointer deref in journal_wait_on_commit_record()
has been removed from the -mm tree.  Its filename was
     ext4-fix-null-pointer-deref-in-journal_wait_on_commit_record.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -872,7 +872,8 @@ wait_for_iobuf:
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

origin.patch
