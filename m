Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A602989B5
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 02:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500470; cv=none; b=LDniCzyS395+npNAxOTULgDiaAdSEPj1ajwGqd61IH9VOvlU8TM7u9CKkT3TVF2gFXwAHgUBQz3kgWPuC46jZxqQG3kz1w1fwWI7suja9HlR638ZT3EfzHBpzGdkdkI1Qda61eq/VhkL3tJzcNPs5RZ4RRig89GGYiqHUAXqZww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500470; c=relaxed/simple;
	bh=L55WNRFZMKgvUXPQtxoqMxAbmsyv/u56TXqstSBskIY=;
	h=Date:To:From:Subject:Message-Id; b=rhwq5T1KYztLoEt+tCj0CuOQOhYpfoN1AxLsQnkYTLusanOjG2l51Csc+0VnwlOW+LX44OiCdM2qepnOUjS9ZHi2++8iVbuYC/sbVXSzHT6iozt51AiugGgV9w8MgJA4Se3UB1cwqpx7efggSqnMi854zA+2xx6MYwnh4Rq7hto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MQt41AxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MQt41AxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9931F000E9;
	Wed, 12 Aug 2026 02:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786500468;
	bh=FHHDtgX+g8l5asqt+UiIiq66rwCzh4um2zvrlJUnzDA=;
	h=Date:To:From:Subject;
	b=MQt41AxDbs2Tc2wygaL424jL1pOlvbyLxeYceveDQww/jyCyW7inzxzR1/fIaHBVA
	 wStcODn+3ga6RQ0VQlElYbq6hsf8WV3G9uM8zKdJswFhC6n6iede+lENQt/ZpOebe6
	 gmKwkb3uN7EFOmRXb/R4L/D35OW/bx+EwOlt4Z5E=
Date: Tue, 11 Aug 2026 19:07:48 -0700
To: mm-commits@vger.kernel.org,zhanxusheng@xiaomi.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,zhanxusheng1024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch removed from -mm tree
Message-Id: <20260812020748.9E9931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: bound-check dir entries in the readdir re-validation scan
has been removed from the -mm tree.  Its filename was
     ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: ocfs2: bound-check dir entries in the readdir re-validation scan
Date: Thu, 6 Aug 2026 20:21:33 +0800

When the inode version changed since the last readdir(),
ocfs2_dir_foreach_blk_el() re-scans the directory block from its start to
relocate the current position:

	for (i = 0; i < sb->s_blocksize && i < offset; ) {
		de = (struct ocfs2_dir_entry *)(bh->b_data + i);
		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
			break;
		i += le16_to_cpu(de->rec_len);
	}

The loop dereferences de->rec_len (at byte offset 8 within the entry)
guarded only by i < sb->s_blocksize.  `offset` is derived from ctx->pos,
which userspace controls via lseek() on the directory fd, so i can reach
the last bytes of the block; reading de->rec_len then reads a few bytes
past the s_blocksize-sized block buffer (an out-of-bounds read).

The main emit loop below already guards this via ocfs2_check_dir_entry(),
which rejects entries too close to the buffer end before touching de. 
Apply the same lower bound to the re-validation scan so that a full
minimal directory entry is known to fit before de is dereferenced.  For a
consistent directory this changes nothing: entries are at least
OCFS2_DIR_REC_LEN(1) bytes, so no valid entry starts in the excluded tail.

Found by the sashiko review tool; fix approach suggested by Joseph Qi.

Link: https://lore.kernel.org/20260806122133.956847-1-zhanxusheng@xiaomi.com
Link: https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dir.c~ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan
+++ a/fs/ocfs2/dir.c
@@ -1945,7 +1945,8 @@ static int ocfs2_dir_foreach_blk_el(stru
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, *f_version)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize &&
+			     i < offset;) {
 				de = (struct ocfs2_dir_entry *) (bh->b_data + i);
 				/* It's too expensive to do a full
 				 * dirent test each time round this
_

Patches currently in -mm which might be from zhanxusheng1024@gmail.com are

maple_tree-remove-unused-mas_is_root_limits.patch
ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch

