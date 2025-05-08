Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1476E21C9F2
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686468; cv=none; b=FPqKe4hry7iwSY1etVbfP349cb6BUV/tJXPwlVGSdLCwXVvHRZ7wZ4VjXCxOBf3NYzE7oBE6jmaIMgufJtfv4Nazy8Wvyr1yTqYxjkCCZe3uvrV2lPEpdrHQ1T/UrRAAgDZ+E942xX3YwfjKOs7JW1PF1XiGSehwF/54UjAZgBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686468; c=relaxed/simple;
	bh=wxcEFMvUtB5nrd8bEdVgNg8csOQgGxGzlz+tvRlJhQc=;
	h=Date:To:From:Subject:Message-Id; b=pNpkju5iU98nSI5pjdkkW1h+VSJqiBHygAeivyiFivDQj0c6+yN5htrHCTveiCihkzNNXw3b8Iw3oDe2KTAi2HXXmVrOLNxqQUUxD4JZ/OPLKda3MLqkOyKb0WbqxQ7T3Df1FqZ2haz8RzcMJQGnNxiHnXX2pgiZg/PxSOEH7Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k1LPOkmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k1LPOkmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD39BC4CEEF;
	Thu,  8 May 2025 06:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686467;
	bh=wxcEFMvUtB5nrd8bEdVgNg8csOQgGxGzlz+tvRlJhQc=;
	h=Date:To:From:Subject:From;
	b=k1LPOkmcUIaS3Ve7UxXoMfbMUyLyX9acJli0BDMt3m7fXD5DlXR+u6P7FIdP6FAl0
	 jx2N7KJvLabIQFhLBA9hChIktMGEYupHyMHPCA5mLO1pxKK08X8/tl2eneVLW7iTtB
	 4ysk9jiH/pl4wUAwM/V0FeR2Fx28PA06wptu3c8Y=
Date: Wed, 07 May 2025 23:41:07 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch removed from -mm tree
Message-Id: <20250508064107.DD39BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
Date: Sat, 3 May 2025 14:33:14 +0900

After commit c0e473a0d226 ("block: fix race between set_blocksize and read
paths") was merged, set_blocksize() called by sb_set_blocksize() now locks
the inode of the backing device file.  As a result of this change, syzbot
started reporting deadlock warnings due to a circular dependency involving
the semaphore "ns_sem" of the nilfs object, the inode lock of the backing
device file, and the locks that this inode lock is transitively dependent
on.

This is caused by a new lock dependency added by the above change, since
init_nilfs() calls sb_set_blocksize() in the lock section of "ns_sem". 
However, these warnings are false positives because init_nilfs() is called
in the early stage of the mount operation and the filesystem has not yet
started.

The reason why "ns_sem" is locked in init_nilfs() was to avoid a race
condition in nilfs_fill_super() caused by sharing a nilfs object among
multiple filesystem instances (super block structures) in the early
implementation.  However, nilfs objects and super block structures have
long ago become one-to-one, and there is no longer any need to use the
semaphore there.

So, fix this issue by removing the use of the semaphore "ns_sem" in
init_nilfs().

Link: https://lkml.kernel.org/r/20250503053327.12294-1-konishi.ryusuke@gmail.com
Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00f7f5b884b117ee6773
Tested-by: syzbot+00f7f5b884b117ee6773@syzkaller.appspotmail.com
Reported-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f30591e72bfc24d4715b
Tested-by: syzbot+f30591e72bfc24d4715b@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs
+++ a/fs/nilfs2/the_nilfs.c
@@ -705,8 +705,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	int blocksize;
 	int err;
 
-	down_write(&nilfs->ns_sem);
-
 	blocksize = sb_min_blocksize(sb, NILFS_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		nilfs_err(sb, "unable to set blocksize");
@@ -779,7 +777,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
-	up_write(&nilfs->ns_sem);
 	return err;
 
  failed_sbh:
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch

