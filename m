From: akpm@linux-foundation.org
Subject: + remove-filesize-checks-for-sync-i-o-journal-commit.patch added
 to -mm tree
Date: Tue, 04 Nov 2014 14:44:45 -0800
Message-ID: <545956dd.1HEIaZ4sSzz81wTJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDWoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 17:44:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.de, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove filesize checks for sync I/O journal commit
has been added to the -mm tree.  Its filename is
     remove-filesize-checks-for-sync-i-o-journal-commit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-filesize-checks-for-sync-i-o-journal-commit.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/remove-filesize-checks-for-sync-i-o-journal-commit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: remove filesize checks for sync I/O journal commit

Filesize is not a good indication that the file needs to be synced.
An example where this breaks is:
 1. Open the file in O_SYNC|O_RDWR
 2. Read a small portion of the file (say 64 bytes)
 3. Lseek to starting of the file
 4. Write 64 bytes

If the node crashes, it is not written out to disk because this was not
committed in the journal and the other node which reads the file after
recovery reads stale data (even if the write on the other node was
successful)

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/file.c~remove-filesize-checks-for-sync-i-o-journal-commit fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~remove-filesize-checks-for-sync-i-o-journal-commit
+++ a/fs/ocfs2/file.c
@@ -2381,9 +2381,7 @@ out_dio:
 		if (ret < 0)
 			written = ret;
 
-		if (!ret && ((old_size != i_size_read(inode)) ||
-			     (old_clusters != OCFS2_I(inode)->ip_clusters) ||
-			     has_refcount)) {
+		if (!ret) {
 			ret = jbd2_journal_force_commit(osb->journal->j_journal);
 			if (ret < 0)
 				written = ret;
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

remove-filesize-checks-for-sync-i-o-journal-commit.patch

