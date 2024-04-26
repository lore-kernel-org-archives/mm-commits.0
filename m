Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4323581752;
	Fri, 26 Apr 2024 04:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104481; cv=none; b=GjQxQPbdiULfIiXmBaYh4KgIX9swTsN5NCnO1T0b2xVB1183J2rg0yrY8D5hqYKyizZYxKEjs8dh7nXLayMh4acCS/YsBGwJzuMZ7TaM/n5cnG/KKnSOaM3XZQJxl3GY3/PU46WROpndhdrp7PsF/iLWsEoaIxBX3dRBwjJ6ZBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104481; c=relaxed/simple;
	bh=rQUxGAas+v6RdTCo9X6ggN1SFzZohczAumuJY+P1sY8=;
	h=Date:To:From:Subject:Message-Id; b=DN/84a0iT6BMyDnOH+PY0mVTrXjMfMxS6UQB+NH5ybeSyp9g/Rrye21/73A08FHGxBt9W62cJ223Jmij5iDrzBrFUNcreOOC10eju0OBuWFu6DRbaZ+PZnmxjIPqRGh0vB+rhGd2Av74Z2Orv5F6U/vLlY12hFv7QbyGzsYo6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bo7Aou5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bo7Aou5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CB5C113CD;
	Fri, 26 Apr 2024 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104481;
	bh=rQUxGAas+v6RdTCo9X6ggN1SFzZohczAumuJY+P1sY8=;
	h=Date:To:From:Subject:From;
	b=Bo7Aou5rrC3Aokyj2sh15NaBuvH3XnjJ83XE2VyASAqujfBPxxQdQ310EVOYI6TG2
	 2w5z67PkEGXgcu8eG+aoNfvsYmhN1CoYe1V9lfX5q7ivk5TCEEm41SiW5ZyRJuyUBg
	 HUrTcOigXNCLFkB1p9xXntkkfQD0RV65J7c+FFI4=
Date: Thu, 25 Apr 2024 21:08:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch removed from -mm tree
Message-Id: <20240426040801.16CB5C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
has been removed from the -mm tree.  Its filename was
     ocfs2-update-inode-fsync-transaction-id-in-ocfs2_unlink-and-ocfs2_link.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link
Date: Mon, 8 Apr 2024 16:20:40 +0800

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

Link: https://lkml.kernel.org/r/20240408082041.20925-4-glass.su@suse.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
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


