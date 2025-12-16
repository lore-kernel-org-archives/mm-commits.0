Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E5632572F
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765913110; cv=none; b=s+rOp8UfussC2tojoaYVeQEwdK7rFVul1IV02hiuIHa0kVu2u/IYc8A/ftLy1RNbQh1Q9jui7XswouO4S3fixGu3GYHsWbkA8/lRzb4GKItiLqF1+dLKJVRGIBvygv2e4iQlamE2amT+WXBDz/MsD5w3QgtRVfuUENdH293Xdeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765913110; c=relaxed/simple;
	bh=5HZtx2wG0k/U/iPEhaYbB8wk9+XHPo1U6nJS1gR93Ro=;
	h=Date:To:From:Subject:Message-Id; b=dxRl/2SyI3FUw4Gzt5vhcFancTe1Kmd5KrOmN5wJ+dsXKlAkATUY2/81samtIlQW4QXMMQ7XDB68kG/n7iz1ifftzzaMm5J4Uo0z2onyPQIAoLwQjSX35phSPvMMjbxTSjIcXF9Rdxhj50JoIo61aEjAHscy1JzcSdLOmWY1bz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZ4xlI6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZ4xlI6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46DBC4CEF1;
	Tue, 16 Dec 2025 19:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765913109;
	bh=5HZtx2wG0k/U/iPEhaYbB8wk9+XHPo1U6nJS1gR93Ro=;
	h=Date:To:From:Subject:From;
	b=ZZ4xlI6QKg//8s7EAlXPF6EPFqpgANQms5nqZVWUQwuQw5l8wCivXvtYiyPX6HMFs
	 bxZdOlcreKXQzjJo7ZxEnm/aJJymc2YgSayOFrLVrqh8j/1Un7v+tZoDUyOXLV9aYS
	 lKj2prhbHFhWI/1FWAPiKZc2DxprYtWF35YrzSrc=
Date: Tue, 16 Dec 2025 11:25:09 -0800
To: mm-commits@vger.kernel.org,syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,activprithvi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-validate-function-for-slot-map-blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20251216192509.C46DBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add validate function for slot map blocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-validate-function-for-slot-map-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-validate-function-for-slot-map-blocks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

ocfs2-add-validate-function-for-slot-map-blocks.patch

