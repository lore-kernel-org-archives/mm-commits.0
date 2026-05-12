Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25B33859EC
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778621670; cv=none; b=eCcmQQruLPZOHMDxh6MoVrGmIh2MTm9iN3ANkn43sTvUmRMCiCXfxTiFzu0WVCJJYJq9GBxnS+2IIQOS5FvN/z1yDM7Cpo/OkpJu3jcHPCJCuacpIRMjJmwlxehUu8E3EQZrYevuCtrsVK3hDIOUvZZC1zXZM7qlmCXWaefTF/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778621670; c=relaxed/simple;
	bh=OosCv7ieAVq4o/LxqtrXXj8qGwxakoXKApT7XDKG/do=;
	h=Date:To:From:Subject:Message-Id; b=Ysl/p/brC+wVj1h/x4lZoILy278RxHIlCjRX0/kfhunv8dKW6eMp2Blk41saSw6RoCyJwL6PYbi1GHx7nGlE3N0+YJ10WnC/nNT9sLoMXW8A2+3636OPp2Jnlu88HpRXBDcTuCs3pMzl5xxqLl1hr9UdFx16CTS02SuXvQe81Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ot7FlzLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ot7FlzLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844F8C2BCB0;
	Tue, 12 May 2026 21:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778621669;
	bh=OosCv7ieAVq4o/LxqtrXXj8qGwxakoXKApT7XDKG/do=;
	h=Date:To:From:Subject:From;
	b=ot7FlzLNVJNNQlabKvshp28h9EYwPfQDlM40swNljQzbmuJNjJJSXRAWRnuUd3QIy
	 gPOjYKcf3btesFSbDmEo6H1SsIWeFiAsaBa0gj0g8QWwFeY7deksZmKXdPq6xuUaF3
	 YJukwFQCstFIWQoN6+8xXw+AH7FY+jPZQKJxt+Gs=
Date: Tue, 12 May 2026 14:34:29 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-inconsistent-inode-size-before-truncate.patch added to mm-nonmm-unstable branch
Message-Id: <20260512213429.844F8C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject inconsistent inode size before truncate
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-inconsistent-inode-size-before-truncate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-inconsistent-inode-size-before-truncate.patch

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
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: reject inconsistent inode size before truncate
Date: Tue, 12 May 2026 10:16:00 +0800

[BUG]
openat(..., O_WRONLY|O_CREAT|O_TRUNC) can hit:

kernel BUG at fs/ocfs2/file.c:454!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_truncate_file+0x1204/0x13c0 fs/ocfs2/file.c:454
Call Trace:
 ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
 notify_change+0x4b5/0x1030 fs/attr.c:546
 do_truncate+0x1d2/0x230 fs/open.c:68
 handle_truncate fs/namei.c:3596 [inline]
 do_open fs/namei.c:3979 [inline]
 path_openat+0x260f/0x2ce0 fs/namei.c:4134
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x15b/0x220 fs/open.c:1463
 ...

[CAUSE]
ocfs2_truncate_file() treats di_bh->i_size matching inode->i_size as an
internal code invariant and BUGs if it is broken.

That assumption is too strong for corrupted metadata. The dinode block can
still be structurally valid enough to pass ocfs2_read_inode_block() while
no longer matching an already-instantiated VFS inode. On local mounts,
ocfs2_inode_lock_update() skips refresh entirely, so truncate can
observe the mismatch directly and crash instead of rejecting the
corruption.

[FIX]
Turn the BUG_ON into normal OCFS2 corruption handling. If truncate sees
di_bh->i_size disagree with inode->i_size, report it with ocfs2_error() and
abort before touching truncate state.

This keeps the fix at the first boundary that actually requires the
sizes to match and avoids widening checks into hotter generic
inode-lock paths

Link: https://lore.kernel.org/20260512021601.3936417-1-gality369@gmail.com
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-reject-inconsistent-inode-size-before-truncate
+++ a/fs/ocfs2/file.c
@@ -444,21 +444,26 @@ int ocfs2_truncate_file(struct inode *in
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	/* We trust di_bh because it comes from ocfs2_inode_lock(), which
-	 * already validated it */
+	/*
+	 * On local mounts ocfs2_inode_lock_update() skips the inode
+	 * refresh path, so truncation still needs to reject an inode
+	 * state that no longer matches di_bh.
+	 */
 	fe = (struct ocfs2_dinode *) di_bh->b_data;
 
 	trace_ocfs2_truncate_file((unsigned long long)OCFS2_I(inode)->ip_blkno,
 				  (unsigned long long)le64_to_cpu(fe->i_size),
 				  (unsigned long long)new_i_size);
 
-	mlog_bug_on_msg(le64_to_cpu(fe->i_size) != i_size_read(inode),
-			"Inode %llu, inode i_size = %lld != di "
-			"i_size = %llu, i_flags = 0x%x\n",
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			i_size_read(inode),
-			(unsigned long long)le64_to_cpu(fe->i_size),
-			le32_to_cpu(fe->i_flags));
+	if (unlikely(le64_to_cpu(fe->i_size) != i_size_read(inode))) {
+		status = ocfs2_error(inode->i_sb,
+				     "Inode %llu has inconsistent i_size: inode = %lld, dinode = %llu, i_flags = 0x%x\n",
+				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				     i_size_read(inode),
+				     (unsigned long long)le64_to_cpu(fe->i_size),
+				     le32_to_cpu(fe->i_flags));
+		goto bail;
+	}
 
 	if (new_i_size > le64_to_cpu(fe->i_size)) {
 		trace_ocfs2_truncate_file_error(
_

Patches currently in -mm which might be from gality369@gmail.com are

ocfs2-reject-inconsistent-inode-size-before-truncate.patch
ocfs2-dont-bug_on-an-invalid-journal-dinode.patch

