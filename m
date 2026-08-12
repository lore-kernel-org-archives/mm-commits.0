Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDED42FE07D
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 02:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500661; cv=none; b=cpqZK7Q0/SDZqm42h+wuqNi/IZXHX0dZL1viPRxD+Lz089hfhB6iRvgSVqk3+SeLOdblTDSI9sGhxG3YdhDSXGpNtaWcWdchLaNT+inx/GcfvAhIuCur5N8KGx3Cbqx2d106sR3E7SYKcwCYODxWVKkyqzi934pIEwfRlI6qzYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500661; c=relaxed/simple;
	bh=NCE28JSP9FvgcpyRUiMAci9AanJS2aLxMASxzfxzsa0=;
	h=Date:To:From:Subject:Message-Id; b=Mu/jDI7vyaZC5EWId9T4miRzswPtflAwb6YrRpgJLZrCxj5uK+ymA5EsV2H+FL9Fn5DP3TY4pGBsMERAG+FbdBTwrWvD9jpaCk2IA4KZ+tVBVpgVWqkZGlBwDsPRJMGxlcynJRV32hkzstsV6Iufy5B1jyq8L9xFL8LmvIMY1sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LaiwTTrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LaiwTTrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE851F000E9;
	Wed, 12 Aug 2026 02:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786500659;
	bh=++ARQbHR6aWfvvN/hfvo2QGkDfueZfG9szSwu5Hy1lg=;
	h=Date:To:From:Subject;
	b=LaiwTTrMgkfA7U2lPyz9HXCw05PS2BtPfG+3LtrDIzqXzaS4wFwyRHpcOKqAHEZ15
	 6WlS7FoHI+RBZPRNQwzSfqezvbXsnmDsuIn+tbVdnSuQh6Um4QJJsybcDuhbI+KOVx
	 l9RR7Ype+pyVUjEjqx0UR7P5crM2+sArI7bDsle0=
Date: Tue, 11 Aug 2026 19:10:58 -0700
To: mm-commits@vger.kernel.org,zhanxusheng@xiaomi.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,zhanxusheng1024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-bound-check-dir-entries-in-the-inline-data-re-validation-scan.patch added to mm-nonmm-unstable branch
Message-Id: <20260812021059.5CE851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: bound-check dir entries in the inline-data re-validation scan
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-bound-check-dir-entries-in-the-inline-data-re-validation-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-bound-check-dir-entries-in-the-inline-data-re-validation-scan.patch

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
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
Subject: ocfs2: bound-check dir entries in the inline-data re-validation scan
Date: Tue, 11 Aug 2026 10:43:37 +0800

ocfs2_dir_foreach_blk_id() re-scans the inline data area the same way
ocfs2_dir_foreach_blk_el() re-scans a directory block, and is missing the
same two bounds:

	for (i = 0; i < i_size_read(inode) && i < offset; ) {
		de = (struct ocfs2_dir_entry *)(data->id_data + i);
		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
			break;
		i += le16_to_cpu(de->rec_len);
	}

ocfs2_validate_inode_block() keeps i_size inside the inline area:

	if (le16_to_cpu(data->id_count) >
	    ocfs2_max_inline_data_with_xattr(sb, di))
	if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count))

and that area runs to the end of the inode block, so for a full inline
directory data->id_data + i_size is the end of di_bh->b_data.  A bogus
rec_len leaves i in the last OCFS2_DIR_REC_LEN(1) - 1 bytes of it, and
de->rec_len, at byte offset 8 within the entry, is then read past the
block.

The emit loop below hands i_size_read(inode) to ocfs2_check_dir_entry(),
which refuses both an entry that close to the end and one whose rec_len
runs past it.  Apply the same two bounds to the re-validation scan,
reading i_size once into a local as ocfs2_check_dir_entry() takes it as
@size.

Unlike the extent case there is no mask to corrupt here: an unbounded i
only sets ctx->pos past i_size, which ends the readdir early rather than
moving it to the wrong place.

Link: https://lore.kernel.org/20260811024337.3972976-3-zhanxusheng@xiaomi.com
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-bound-check-dir-entries-in-the-inline-data-re-validation-scan
+++ a/fs/ocfs2/dir.c
@@ -1849,7 +1849,12 @@ static int ocfs2_dir_foreach_blk_id(stru
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, *f_version)) {
-			for (i = 0; i < i_size_read(inode) && i < offset; ) {
+			loff_t size = i_size_read(inode);
+
+			for (i = 0; i + OCFS2_DIR_REC_LEN(1) <= size &&
+			     i < offset;) {
+				unsigned int rec_len;
+
 				de = (struct ocfs2_dir_entry *)
 					(data->id_data + i);
 				/* It's too expensive to do a full
@@ -1858,10 +1863,11 @@ static int ocfs2_dir_foreach_blk_id(stru
 				 * least that it is non-zero.  A
 				 * failure will be detected in the
 				 * dirent test below. */
-				if (le16_to_cpu(de->rec_len) <
-				    OCFS2_DIR_REC_LEN(1))
+				rec_len = le16_to_cpu(de->rec_len);
+				if (rec_len < OCFS2_DIR_REC_LEN(1) ||
+				    i + rec_len > size)
 					break;
-				i += le16_to_cpu(de->rec_len);
+				i += rec_len;
 			}
 			ctx->pos = offset = i;
 			*f_version = inode_query_iversion(inode);
_

Patches currently in -mm which might be from zhanxusheng1024@gmail.com are

maple_tree-remove-unused-mas_is_root_limits.patch
ocfs2-fix-readdir-position-truncation-on-32-bit-kernels.patch
ocfs2-bound-check-dir-entries-in-the-readdir-re-validation-scan.patch
ocfs2-bound-check-dir-entries-in-the-inline-data-re-validation-scan.patch

