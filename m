Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA85F278754
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751059700; cv=none; b=JC4Ymj92oQAEXjmpL2mKWdv4HBBRSRY84z2jepnPyP2JTwZBwsAxRPTjxhQZVQMaIxj0Nt0xXArVUtvwt8OBJZXIFHyMQXWRYEZ4nZCTeFPV0Y0grrxWAS1OZ9sMnitPRaU6VY6oGshD9LXQlEOV7Lu/W6PJfDzUC2ZI1OuGIkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751059700; c=relaxed/simple;
	bh=XTQ6heRouRHRllA43eKLFFvJQ1LjGqfNLhfBS0Vc/FE=;
	h=Date:To:From:Subject:Message-Id; b=IdCYz+4H0RdF7xNXmWKwpHgdSJoTHm0zXlY6u6AIbMy24helOamnUSIOQN2/SH7Z7zQpoB5m+LxLyr73Hf2OFri8OmsxWV9oV3RLkv20RJYp1mCxJLwjrhQ6y3QSq/40TN8jc6itcTxJDexvLcCohBIllWZhptjps4UN1tHsq/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nh5G69dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nh5G69dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E91C4CEE3;
	Fri, 27 Jun 2025 21:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751059697;
	bh=XTQ6heRouRHRllA43eKLFFvJQ1LjGqfNLhfBS0Vc/FE=;
	h=Date:To:From:Subject:From;
	b=Nh5G69dMlBGVtnXS3r09Aqde7VFLG8rM43UDBfaxLdqS6eGY4bqvzWbu7K9xMWZTR
	 G/DRR2TPbMa0TFk7xfDAoKq1LhsAzCALcNAiPaunHlt3t5kkX23bCTF07Q5Qghdwzm
	 xD4B0nZ8mbqfUHMR1x320bv+e/NOnjmo43lFKx1Q=
Date: Fri, 27 Jun 2025 14:28:16 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-update-d_splice_alias-return-code-checking.patch added to mm-nonmm-unstable branch
Message-Id: <20250627212817.78E91C4CEE3@smtp.kernel.org>
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
Date: Fri, 27 Jun 2025 23:19:30 +0900

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

Link: https://lkml.kernel.org/r/d84dc916-2982-45dc-a9a5-a6255cbc62bd@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1134d3a5b062e9665a7a
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-update-d_splice_alias-return-code-checking
+++ a/fs/ocfs2/namei.c
@@ -142,6 +142,8 @@ static struct dentry *ocfs2_lookup(struc
 
 bail_add:
 	ret = d_splice_alias(inode, dentry);
+	if (IS_ERR(ret))
+		goto bail_unlock;
 
 	if (inode) {
 		/*
@@ -154,13 +156,12 @@ bail_add:
 		 * NOTE: This dentry already has ->d_op set from
 		 * ocfs2_get_parent() and ocfs2_get_dentry()
 		 */
-		if (!IS_ERR_OR_NULL(ret))
-			dentry = ret;
-
-		status = ocfs2_dentry_attach_lock(dentry, inode,
+		status = ocfs2_dentry_attach_lock(ret ? ret : dentry, inode,
 						  OCFS2_I(dir)->ip_blkno);
 		if (status) {
 			mlog_errno(status);
+			if (ret)
+				dput(ret);
 			ret = ERR_PTR(status);
 			goto bail_unlock;
 		}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

ocfs2-kill-osb-system_file_mutex-lock.patch
ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch
ocfs2-update-d_splice_alias-return-code-checking.patch

