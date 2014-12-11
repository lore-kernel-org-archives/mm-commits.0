From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:12 -0800
Message-ID: <5489e890.hDb/lNn85fI7Jdme%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbaLKSzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove bogus test from ocfs2_read_locked_inode()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: remove bogus test from ocfs2_read_locked_inode()

'args' are always set for ocfs2_read_locked_inode() and brelse() checks
whether bh is NULL.  So the test (args && bh) is unnecessary (plus the
args part is really confusing anyway).  Remove it.

Coverity id: 1128856.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode
+++ a/fs/ocfs2/inode.c
@@ -540,8 +540,7 @@ bail:
 	if (status < 0)
 		make_bad_inode(inode);
 
-	if (args && bh)
-		brelse(bh);
+	brelse(bh);
 
 	return status;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-unify-inode-and-mount-marks-handling.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch

