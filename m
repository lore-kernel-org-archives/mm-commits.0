From: akpm@linux-foundation.org
Subject: + ocfs2-fix-shift-left-overflow.patch added to -mm tree
Date: Tue, 28 Jul 2015 13:53:51 -0700
Message-ID: <55b7ebdf.mwy32X2N62YzpBAj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbG1Uxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 16:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix shift left overflow
has been added to the -mm tree.  Its filename is
     ocfs2-fix-shift-left-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-shift-left-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-shift-left-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix shift left overflow

cluster pos is defined as u32, when calculate corresponding sector it
should be converted to u64 first, otherwise it may overflow.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-shift-left-overflow fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-shift-left-overflow
+++ a/fs/ocfs2/aops.c
@@ -688,7 +688,7 @@ static int ocfs2_direct_IO_zero_extend(s
 
 	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
 		u64 s = i_size_read(inode);
-		sector_t sector = (p_cpos << (osb->s_clustersize_bits - 9)) +
+		sector_t sector = ((u64)p_cpos << (osb->s_clustersize_bits - 9)) +
 			(do_div(s, osb->s_clustersize) >> 9);
 
 		ret = blkdev_issue_zeroout(osb->sb->s_bdev, sector,
@@ -916,7 +916,7 @@ static ssize_t ocfs2_direct_IO_write(str
 		BUG_ON(!p_cpos || (ext_flags & OCFS2_EXT_UNWRITTEN));
 
 		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
-				p_cpos << (osb->s_clustersize_bits - 9),
+				(u64)p_cpos << (osb->s_clustersize_bits - 9),
 				zero_len_head >> 9, GFP_NOFS, false);
 		if (ret < 0)
 			mlog_errno(ret);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-fix-shift-left-overflow.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

