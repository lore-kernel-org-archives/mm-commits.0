Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C59D32ED3C
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967314; cv=none; b=RMnnl146ynuIGO2TeYCC3OrtOGc/F7hSyE5HBrz3z6UqndB4LxsjBQ3D19CZugYGXcQMr9iTqej9GoUsN6/cqqwQ9oVicQwQ7oBClfqjGJXXVrd8+wxXhtjAnWIZN+MQ33wHC72xEAdn4mEUIUGTQ0ntVs9wVGoACBnbjpcaS3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967314; c=relaxed/simple;
	bh=N7CmXrnWWR4VslxIQVEOAy2SCGRd9fDHKuQ7Qid0fkI=;
	h=Date:To:From:Subject:Message-Id; b=UtSzCv0JzKfyl/zpX3IXBb+AdzHPz+0PrpTAz04SVamfTrMMUKkRXiI6YAcKnFcIJnkBVxiNqpHEJhbDtEaoo706rEkm48pOy10lCQlh/++kOTSXX1gDMRyiQ0YAdVp84sCg9V36g7PjYGkf35W8W8CvTg4jUsWS5tY0EvkfZ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NDIt3Z63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NDIt3Z63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C44FC16AAE;
	Wed, 21 Jan 2026 03:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967313;
	bh=N7CmXrnWWR4VslxIQVEOAy2SCGRd9fDHKuQ7Qid0fkI=;
	h=Date:To:From:Subject:From;
	b=NDIt3Z630LH77lAsZIaIcWB7bfVj+s9IBh24HN1Ci6IYWdHvsEaJdtJbXqyziJ9tK
	 p0P0JKb7dPri5Wj2E0J2fufFZMmnQCCkTRY+hqDEamKJv16Hn5LIcZaKiv3gTpytvA
	 pViHMo5BLRGmdHOYtuvvYYb4UlCVrQglr3snXttA=
Date: Tue, 20 Jan 2026 19:48:32 -0800
To: mm-commits@vger.kernel.org,syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,activprithvi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-validate-function-for-slot-map-blocks.patch removed from -mm tree
Message-Id: <20260121034833.6C44FC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add validate function for slot map blocks
has been removed from the -mm tree.  Its filename was
     ocfs2-add-validate-function-for-slot-map-blocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Prithvi Tambewagh <activprithvi@gmail.com>
Subject: ocfs2: add validate function for slot map blocks
Date: Tue, 16 Dec 2025 00:15:57 +0530

When the filesystem is being mounted, the kernel panics while the data
regarding slot map allocation to the local node, is being written to the
disk.  This occurs because the value of slot map buffer head block number,
which should have been greater than or equal to `OCFS2_SUPER_BLOCK_BLKNO`
(evaluating to 2) is less than it, indicative of disk metadata corruption.
This triggers BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in
ocfs2_write_block(), causing the kernel to panic.

This is fixed by introducing function ocfs2_validate_slot_map_block() to
validate slot map blocks.  It first checks if the buffer head passed to it
is up to date and valid, else it panics the kernel at that point itself. 
Further, it contains an if condition block, which checks if
`bh->b_blocknr` is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if yes, then
ocfs2_error is called, which prints the error log, for debugging purposes,
and the return value of ocfs2_error() is returned.  If the if condition is
false, value 0 is returned by ocfs2_validate_slot_map_block().

This function is used as validate function in calls to ocfs2_read_blocks()
in ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers().

Link: https://lkml.kernel.org/r/20251215184600.13147-1-activprithvi@gmail.com
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
Tested-by: <syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/slot_map.c~ocfs2-add-validate-function-for-slot-map-blocks
+++ a/fs/ocfs2/slot_map.c
@@ -44,6 +44,9 @@ struct ocfs2_slot_info {
 static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 				    unsigned int node_num);
 
+static int ocfs2_validate_slot_map_block(struct super_block *sb,
+					  struct buffer_head *bh);
+
 static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
 				  int slot_num)
 {
@@ -132,7 +135,8 @@ int ocfs2_refresh_slot_info(struct ocfs2
 	 * this is not true, the read of -1 (UINT64_MAX) will fail.
 	 */
 	ret = ocfs2_read_blocks(INODE_CACHE(si->si_inode), -1, si->si_blocks,
-				si->si_bh, OCFS2_BH_IGNORE_CACHE, NULL);
+				si->si_bh, OCFS2_BH_IGNORE_CACHE,
+				ocfs2_validate_slot_map_block);
 	if (ret == 0) {
 		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
@@ -332,6 +336,24 @@ int ocfs2_clear_slot(struct ocfs2_super
 	return ocfs2_update_disk_slot(osb, osb->slot_info, slot_num);
 }
 
+static int ocfs2_validate_slot_map_block(struct super_block *sb,
+					  struct buffer_head *bh)
+{
+	int rc;
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		rc = ocfs2_error(sb,
+				 "Invalid Slot Map Buffer Head "
+				 "Block Number : %llu, Should be >= %d",
+				 (unsigned long long)bh->b_blocknr,
+				 OCFS2_SUPER_BLOCK_BLKNO);
+		return rc;
+	}
+	return 0;
+}
+
 static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 				  struct ocfs2_slot_info *si)
 {
@@ -383,7 +405,8 @@ static int ocfs2_map_slot_buffers(struct
 
 		bh = NULL;  /* Acquire a fresh bh */
 		status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
-					   1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
+					   1, &bh, OCFS2_BH_IGNORE_CACHE,
+					   ocfs2_validate_slot_map_block);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
_

Patches currently in -mm which might be from activprithvi@gmail.com are


