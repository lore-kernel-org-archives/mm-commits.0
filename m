From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-shift-left-overflow.patch removed from -mm
 tree
Date: Fri, 07 Aug 2015 12:03:20 -0700
Message-ID: <55c500f8.hKoBSJU4TMhDkKky%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946135AbbHGTDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix shift left overflow
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-shift-left-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix shift left overflow

When using a large volume, for example 9T volume with 2T already used,
frequent creation of small files with O_DIRECT when the IO is not
cluster aligned may clear sectors in the wrong place.  This will cause
filesystem corruption.

This is because p_cpos is a u32.  When calculating the corresponding
sector it should be converted to u64 first, otherwise it may overflow.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-shift-left-overflow fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-shift-left-overflow
+++ a/fs/ocfs2/aops.c
@@ -685,7 +685,7 @@ static int ocfs2_direct_IO_zero_extend(s
 
 	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
 		u64 s = i_size_read(inode);
-		sector_t sector = (p_cpos << (osb->s_clustersize_bits - 9)) +
+		sector_t sector = ((u64)p_cpos << (osb->s_clustersize_bits - 9)) +
 			(do_div(s, osb->s_clustersize) >> 9);
 
 		ret = blkdev_issue_zeroout(osb->sb->s_bdev, sector,
@@ -910,7 +910,7 @@ static ssize_t ocfs2_direct_IO_write(str
 		BUG_ON(!p_cpos || (ext_flags & OCFS2_EXT_UNWRITTEN));
 
 		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
-				p_cpos << (osb->s_clustersize_bits - 9),
+				(u64)p_cpos << (osb->s_clustersize_bits - 9),
 				zero_len_head >> 9, GFP_NOFS, false);
 		if (ret < 0)
 			mlog_errno(ret);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-adjust-code-to-match-locking-unlocking-order.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

