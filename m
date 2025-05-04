Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DD8C8FE
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 00:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746319923; cv=none; b=Y7ORaDHPTP/+gdDNa3Jgo0WIBGewopc18Pj4hqbLzfbaMIlnLX7IFGBni7u0plRrGA37fawk5TVXW1zEQ9qYf0XXffUdKNk90jSWwALYCoF/rGHEPTyBnK4zoTmLOQBuhfQWlHxqz4wmXKAWlnlCSEo1YUuz30d5ZGb5QkLdUPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746319923; c=relaxed/simple;
	bh=nxEP2bxfjUGeamjGz+jbzLVTGhJLv2poAO0sAHITJtY=;
	h=Date:To:From:Subject:Message-Id; b=Vzb8qmOHQn65OnCnihdEObBTMgU6mSiSSzTCoqA/r0He5F1BmJU3KXYySh9SaUgIQxY7GQHRadSLfq0N04uocDfcPhZnBydgNnN4Q+kU2t2oezoMbONlT8UVNkjfEQW0qaviAj1yWIBf9QsYkLNSJvXsDkGYh7Eo7c1DB/agodc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0yjC6Dot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0yjC6Dot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14445C4CEE3;
	Sun,  4 May 2025 00:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746319923;
	bh=nxEP2bxfjUGeamjGz+jbzLVTGhJLv2poAO0sAHITJtY=;
	h=Date:To:From:Subject:From;
	b=0yjC6DotrJSi1rccgdpgcJxUjH4S/2a0RnJ69UyzM38q8zcD8vqMVemHH0GxJk1y/
	 CVyFz4N643ZI1vcfIYzfs4PK0wTu5023416PFvEo5aCvi2etRMVTzSLLz0CTahPNOX
	 x1OcyNaGx0t6N99znWCXDLsEfWedQONam4SR9/x0=
Date: Sat, 03 May 2025 17:52:02 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch added to mm-hotfixes-unstable branch
Message-Id: <20250504005203.14445C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch

