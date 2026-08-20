Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432CD348C70
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 02:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787194540; cv=none; b=fCgKcW1rtWmXILbirxGFWCK3HK8GtXhnhV20kZabAdJ+izD/4nnmhfbeClkSLU/P1vtZGhzYRbYAuqZVmFGLFMciu/4ETJspSP57BuLCq+yWBsl5ABCpTqvDjvVS+oEhh3p0yRH9uDz06YsB8YP1S6hhtLstA7nnjh/0GxvNGo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787194540; c=relaxed/simple;
	bh=K9ZvgV6dYAK8na+U/4dgQNEA1v762WzdS8CcY9XxROI=;
	h=Date:To:From:Subject:Message-Id; b=j94YvmHct/RqsOP4ootGdwjiuTcJQ9inveuUZyl2vh3fEsN0f+F51ollNfUqq62fyySl2zb81EV6Jy6FTkBlACHHI5Q9Q/fRmy6YPSAk602tosMQr4PG24HMCwG2nGw98Z30VZOI8NMMPOFxIQc8OypYhKb1YryyjRpjyMxpMnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AiUV4V+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AiUV4V+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8E61F000E9;
	Thu, 20 Aug 2026 02:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787194539;
	bh=6djf/1wPxTnP6qAcGn8yIjWM3RG/9+K6qkH13LVsmBo=;
	h=Date:To:From:Subject;
	b=AiUV4V+CohMEvYz/AxOlm5M1YexUrWAo0tVUCCBxsFKI1rHSzxSNBwff76d45Zpl2
	 TEyBrolwQle4lIkldT7Td0CtOkC60VjAATbXsh1LjYfYnxzzYoab2ouD564Ahi4qrv
	 I+IN6c1IOGxB72rBfC0Li3vv6Bilp3xmbIdXCP+Y=
Date: Wed, 19 Aug 2026 19:55:38 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,zhanxusheng@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch removed from -mm tree
Message-Id: <20260820025538.DA8E61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: bound-check dir entries in the readdir re-validation scan
has been removed from the -mm tree.  Its filename was
     ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: ocfs2: bound-check dir entries in the readdir re-validation scan
Date: Tue, 11 Aug 2026 10:43:36 +0800

Patch series "ocfs2: bound-check both readdir re-validation scans", v2.


This patch (of 2):

When the inode version changed since the last readdir(),
ocfs2_dir_foreach_blk_el() re-scans the directory block from its start to
relocate the current position:

	for (i = 0; i < sb->s_blocksize && i < offset; ) {
		de = (struct ocfs2_dir_entry *)(bh->b_data + i);
		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
			break;
		i += le16_to_cpu(de->rec_len);
	}

i walks the block on rec_len values taken from the block itself and the
only thing tested is that rec_len is not too small, so a single bogus
rec_len leaves i anywhere in the block, including its last
OCFS2_DIR_REC_LEN(1) - 1 bytes.  @offset comes from ctx->pos, which
userspace moves with lseek() on the directory fd, and decides how far the
walk gets.

Two bounds are missing, both of which ocfs2_check_dir_entry() applies for
the emit loop below.

de->rec_len sits at byte offset 8 within the entry, so dereferencing de in
that tail reads past the s_blocksize buffer.  ocfs2_check_dir_entry()
declines to look at an entry that close to the end:

	size - buf_offset < OCFS2_DIR_REC_LEN(1)

Nothing bounds i += rec_len either, so i can end up past the block.  The
emit loop that follows is guarded by offset < sb->s_blocksize and does not
run, but

	offset = i;
	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;

runs first and ORs a value with bits above the block mask into ctx->pos,
corrupting the block number readdir() resumes from. 
ocfs2_check_dir_entry() rejects that as "directory entry overrun":

	next_offset = buf_offset + rlen;
	... next_offset > size

Apply both bounds.  For a consistent directory this changes nothing:
entries are at least OCFS2_DIR_REC_LEN(1) bytes and do not cross the end
of the block, so no valid entry is skipped.

Found by the sashiko review tool; fix approach suggested by Joseph Qi.

Link: https://lore.kernel.org/20260811024337.3972976-1-zhanxusheng@xiaomi.com
Link: https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com
Link: https://lore.kernel.org/20260811024337.3972976-2-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan
+++ a/fs/ocfs2/dir.c
@@ -1945,7 +1945,10 @@ static int ocfs2_dir_foreach_blk_el(stru
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, *f_version)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize &&
+			     i < offset;) {
+				unsigned int rec_len;
+
 				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
 				/* It's too expensive to do a full
 				 * dirent test each time round this
@@ -1953,10 +1956,11 @@ static int ocfs2_dir_foreach_blk_el(stru
 				 * least that it is non-zero.  A
 				 * failure will be detected in the
 				 * dirent test below. */
-				if (le16_to_cpu(de->rec_len) <
-				    OCFS2_DIR_REC_LEN(1))
+				rec_len = le16_to_cpu(de->rec_len);
+				if (rec_len < OCFS2_DIR_REC_LEN(1) ||
+				    i + rec_len > sb->s_blocksize)
 					break;
-				i += le16_to_cpu(de->rec_len);
+				i += rec_len;
 			}
 			offset = i;
 			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
_

Patches currently in -mm which might be from zhanxusheng@xiaomi.com are


