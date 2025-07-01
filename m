Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E852C1E50E
	for <mm-commits@vger.kernel.org>; Tue,  1 Jul 2025 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751331613; cv=none; b=hwRaGSlpgyBHIEUrWy+xofBKDQzrwevE/uixtO6l/t/prqlBsX+9rrms6wRQnwjKO1ibrx1WY5GVVe24gDqeq6GIpXg/q7N4dE3Jbn/uDO7zLam6sOGirgCNYlIJOa651oDIyCB1/zHr8ERDZXXf3NckQ++nOUCawSurXyKT6RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751331613; c=relaxed/simple;
	bh=cLxaWvCtniNXQZGzSJcN5vEL7niXqyIGjmcjuu96c0o=;
	h=Date:To:From:Subject:Message-Id; b=oqKIgf6hemtSBbS8ri34VOqDHpzsJ9JyQUWd+y+asE2ZeoGE5LvEqFumx6SwFpEIs/IkCDU+hHqxKvtCgoPCj1KKZWUnPBdAaGTmAOW7/Bnu5Zh6Xu8C1hIXShkamVu8YxnLY9DHehIxQaI8AGhsRVV5/4dv42b0ZL3VcmpNg5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0j+oIUhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0j+oIUhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CA9C4CEE3;
	Tue,  1 Jul 2025 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751331612;
	bh=cLxaWvCtniNXQZGzSJcN5vEL7niXqyIGjmcjuu96c0o=;
	h=Date:To:From:Subject:From;
	b=0j+oIUhePpwDJ3deizv02srjeKAfuSyJTDw+e1K0bgCRUWmgthbRxGb6nCeMXVXV+
	 37gE/kJVHaqCuxIOal7dDK1ibRrYjRn0CRARua2GXe6QqZ5IJpcw2WMk4f4IddnF5R
	 cMrVSmD5PLG4V698Kocjoy0/MHKiSV8zx24++Bmc=
Date: Mon, 30 Jun 2025 18:00:11 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com,richard@nod.at,piaojun@huawei.com,penguin-kernel@i-love-sakura.ne.jp,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-update-d_splice_alias-return-code-checking.patch added to mm-nonmm-unstable branch
Message-Id: <20250701010012.72CA9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: update d_splice_alias() return code checking
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-update-d_splice_alias-return-code-checking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-update-d_splice_alias-return-code-checking.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: ocfs2: update d_splice_alias() return code checking
Date: Mon, 30 Jun 2025 19:21:31 +0900

When commit d3556babd7fa ("ocfs2: fix d_splice_alias() return code
checking") was merged into v3.18-rc3, d_splice_alias() was returning one
of a valid dentry, NULL or an ERR_PTR.

When commit b5ae6b15bd73 ("merge d_materialise_unique() into
d_splice_alias()") was merged into v3.19-rc1, d_splice_alias() started
returning -ELOOP as one of ERR_PTR values.

Now, when syzkaller mounts a crafted ocfs2 filesystem image that hits
d_splice_alias() == -ELOOP case from ocfs2_lookup(), ocfs2_lookup() fails
to handle -ELOOP case and generic_shutdown_super() hits "VFS: Busy inodes
after unmount" message.

Instead of calling ocfs2_dentry_attach_lock() or ocfs2_dentry_attach_gen()
when d_splice_alias() returned an ERR_PTR value, change ocfs2_lookup() to
bail out immediately.

Also, ocfs2_lookup() needs to call dupt() when ocfs2_dentry_attach_lock()
returned an ERR_PTR value.

Link: https://lkml.kernel.org/r/da5be67d-2a0b-4b93-85d6-42f3b7440135@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1134d3a5b062e9665a7a
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tetsuo Handa <penguin-kernel@i-love-sakura.ne.jp>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-update-d_splice_alias-return-code-checking
+++ a/fs/ocfs2/namei.c
@@ -142,6 +142,8 @@ static struct dentry *ocfs2_lookup(struc
 
 bail_add:
 	ret = d_splice_alias(inode, dentry);
+	if (IS_ERR(ret))
+		goto bail_unlock;
 
 	if (inode) {
 		/*
@@ -154,15 +156,16 @@ bail_add:
 		 * NOTE: This dentry already has ->d_op set from
 		 * ocfs2_get_parent() and ocfs2_get_dentry()
 		 */
-		if (!IS_ERR_OR_NULL(ret))
+		if (ret)
 			dentry = ret;
 
 		status = ocfs2_dentry_attach_lock(dentry, inode,
 						  OCFS2_I(dir)->ip_blkno);
 		if (status) {
 			mlog_errno(status);
+			if (ret)
+				dput(ret);
 			ret = ERR_PTR(status);
-			goto bail_unlock;
 		}
 	} else
 		ocfs2_dentry_attach_gen(dentry);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

ocfs2-kill-osb-system_file_mutex-lock.patch
ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch
ocfs2-update-d_splice_alias-return-code-checking.patch

