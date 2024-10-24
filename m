Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503593C3C;
	Thu, 24 Oct 2024 03:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739029; cv=none; b=hafPnT+1jO75XeIWCwpljdFTRura6Z7Y7M9Bi3AsXDCC3grZ3zcKYrrrtU9OZ1D1XE54FiSipalgb/JqU10f+jgjW9ReSNH7BCvb7r9im6fG8LF1t0fBexGNTwbtMVRVuOaY3xDmyfpEts0Cmwt6G/61Nr00dypeKe/RdoFlPss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739029; c=relaxed/simple;
	bh=ko+SpEJILyrR8OVQ+wNJ9ZAyrCCB+UJNtwb2QbMGWgA=;
	h=Date:To:From:Subject:Message-Id; b=kr+1h/swcCszQ59bt/6/hLBk0XkxiIGD9VNh6CI5dB035Y8u9B5kLVTc8xawNpptZIAUTw+R1mRZmdTIXfegvdAxIVizasJ5+ucOaPBzVma1lX0ZiFZLL1nd33Ma9Bo8NqLMjx8DJuAepcaQDoGaw6DUL3xzxi37pj1Nb6+i1DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xSgQMeIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xSgQMeIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE30DC4CEC6;
	Thu, 24 Oct 2024 03:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739028;
	bh=ko+SpEJILyrR8OVQ+wNJ9ZAyrCCB+UJNtwb2QbMGWgA=;
	h=Date:To:From:Subject:From;
	b=xSgQMeINL3vPIBcX3+44Tk5+DayR2ZjMI9ZE0NKhK9ukNT2mQjAX85ydJUypA5rpZ
	 9Zoxz2X1BeB+MO3uEPoO0AAOaXPpcTHVBiRxnjcGVc6TADXDB82R7hqaNNz9c0EOnu
	 SXzcAM11Y5z51RsquxiXVbqHnlzBjfQZ6Ub/FbIc=
Date: Wed, 23 Oct 2024 20:03:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch added to mm-hotfixes-unstable branch
Message-Id: <20241024030348.BE30DC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix potential deadlock with newly created symlinks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch

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
Subject: nilfs2: fix potential deadlock with newly created symlinks
Date: Sun, 20 Oct 2024 13:51:28 +0900

Syzbot reported that page_symlink(), called by nilfs_symlink(), triggers
memory reclamation involving the filesystem layer, which can result in
circular lock dependencies among the reader/writer semaphore
nilfs->ns_segctor_sem, s_writers percpu_rwsem (intwrite) and the
fs_reclaim pseudo lock.

This is because after commit 21fc61c73c39 ("don't put symlink bodies in
pagecache into highmem"), the gfp flags of the page cache for symbolic
links are overwritten to GFP_KERNEL via inode_nohighmem().

This is not a problem for symlinks read from the backing device, because
the __GFP_FS flag is dropped after inode_nohighmem() is called.  However,
when a new symlink is created with nilfs_symlink(), the gfp flags remain
overwritten to GFP_KERNEL.  Then, memory allocation called from
page_symlink() etc.  triggers memory reclamation including the FS layer,
which may call nilfs_evict_inode() or nilfs_dirty_inode().  And these can
cause a deadlock if they are called while nilfs->ns_segctor_sem is held:

Fix this issue by dropping the __GFP_FS flag from the page cache GFP flags
of newly created symlinks in the same way that nilfs_new_inode() and
__nilfs_read_inode() do, as a workaround until we adopt nofs allocation
scope consistently or improve the locking constraints.

Link: https://lkml.kernel.org/r/20241020050003.4308-1-konishi.ryusuke@gmail.com
Fixes: 21fc61c73c39 ("don't put symlink bodies in pagecache into highmem")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9ef37ac20608f4836256
Tested-by: syzbot+9ef37ac20608f4836256@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/namei.c~nilfs2-fix-potential-deadlock-with-newly-created-symlinks
+++ a/fs/nilfs2/namei.c
@@ -157,6 +157,9 @@ static int nilfs_symlink(struct mnt_idma
 	/* slow symlink */
 	inode->i_op = &nilfs_symlink_inode_operations;
 	inode_nohighmem(inode);
+	mapping_set_gfp_mask(inode->i_mapping,
+			     mapping_gfp_constraint(inode->i_mapping,
+						    ~__GFP_FS));
 	inode->i_mapping->a_ops = &nilfs_aops;
 	err = page_symlink(inode, symname, l);
 	if (err)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-kernel-bug-due-to-missing-clearing-of-checked-flag.patch
nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch

