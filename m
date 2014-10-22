From: akpm@linux-foundation.org
Subject: + ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
 added to -mm tree
Date: Wed, 22 Oct 2014 12:44:31 -0700
Message-ID: <5448091f.rAv4xcTn3qQtZlpr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbaJVTob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:44:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove bogus test from ocfs2_read_locked_inode()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
mm-add-strictlimit-knob-v2.patch

