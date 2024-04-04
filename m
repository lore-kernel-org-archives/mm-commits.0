Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6914C6F
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 01:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712195516; cv=none; b=SV6v9Rqb7whchBsMq0MkDtOSWyLQlyhpqD3hnrHGlzJOyJLm588v2QXnl8nfK4A21ecMWf9VFvBBdZm/O8KYFYXDemnSuV+ijLLeJLUFxdTo0i2viVU7GTP0aEvwMZTZwuKb3KoIZdzKU4+w1B/capuWr/8I1/tuOQzrNv8OsGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712195516; c=relaxed/simple;
	bh=o6tVtu0rPC8VjyiF58JZ5z3KIC1JlHQ2bq7z0ct5t7I=;
	h=Date:To:From:Subject:Message-Id; b=hkw7FF9TFzu462EbyQsYh9R6hLEGMG/r+yncXkm6FrVXOGmiXd4picZwj/La7wmqtQHQHyb3/WEQqguI71iUumCRjoqmaJmRp8bccz4yBC2XbijijR5uRfgQWFEg6rGRoVubLgDFby4A0qt9fPzchItVRYAfy29uhW3R9j8+J3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CAmN2URl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CAmN2URl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B912C433F1;
	Thu,  4 Apr 2024 01:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712195516;
	bh=o6tVtu0rPC8VjyiF58JZ5z3KIC1JlHQ2bq7z0ct5t7I=;
	h=Date:To:From:Subject:From;
	b=CAmN2URlS468ogNiUj+SxKT/kRj5RvC2NYn0VVtEdpEX+sfw4N6jMCiYY9aavyw2J
	 hInRNQCQdLI5cs/jEeO/giPizDCQzDcW3fPESzpc8UeCodMEcsBmga73/rv5aJVMt8
	 Ks24+RhhN84gT2REO9tVz/SK7eL2FhvNSZZoChHY=
Date: Wed, 03 Apr 2024 18:51:55 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch added to mm-nonmm-unstable branch
Message-Id: <20240404015156.0B912C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch

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
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
Date: Tue, 2 Apr 2024 09:46:50 +0800

transaction id should be updated in ocfs2_unlink and ocfs2_link. 
Otherwise, inode link will be wrong after journal replay even fsync was
called before power failure:
=======================================================================
$ touch testdir/bar
$ ln testdir/bar testdir/bar_link
$ fsync testdir/bar
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
$ stat -c %h $SCRATCH_MNT/testdir/bar
1
=======================================================================

Link: https://lkml.kernel.org/r/20240402014651.13723-4-glass.su@suse.com
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/namei.c~ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link
+++ a/fs/ocfs2/namei.c
@@ -797,6 +797,7 @@ static int ocfs2_link(struct dentry *old
 	ocfs2_set_links_count(fe, inode->i_nlink);
 	fe->i_ctime = cpu_to_le64(inode_get_ctime_sec(inode));
 	fe->i_ctime_nsec = cpu_to_le32(inode_get_ctime_nsec(inode));
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	err = ocfs2_add_entry(handle, dentry, inode,
@@ -993,6 +994,7 @@ static int ocfs2_unlink(struct inode *di
 		drop_nlink(inode);
 	drop_nlink(inode);
 	ocfs2_set_links_count(fe, inode->i_nlink);
+	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 	ocfs2_journal_dirty(handle, fe_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch
ocfs2-return-real-error-code-in-ocfs2_dio_wr_get_block.patch
ocfs2-fix-races-between-hole-punching-and-aiodio.patch
ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch
ocfs2-use-coarse-time-for-new-created-files.patch

