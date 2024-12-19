Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB45613AA38;
	Thu, 19 Dec 2024 03:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577533; cv=none; b=cV8QgZR3QSQQ+IBw4cx+ffP93NI/LwZUnriS89GbX2LyqGg95YUk1F2VsT42ZC78LPgfmcGLQI5nfLjTI+rb/L/kExn1HOY+nP/aH1pMozAJzakHPZjFzXvjQcqByab2QYpjvnSCIarZsPhkCby+NPFI0YRJR5nlBnDUOmxyqJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577533; c=relaxed/simple;
	bh=1CpTYVDTCADa0cOS9W/tKjlaFJ/uO/n2FqWnGU+oHYI=;
	h=Date:To:From:Subject:Message-Id; b=N4YUZe99pS/UdUPnG1UwzOIkY9XJ71EkrZICw9v2tF0+O/MJpV4/XWt/6wVKO0aN8laiy5uOKk7NMAugAabPcdJS/NGY2WtycIFNmn+UA7xEb3+u90GjqTapA1vAhPfJ/w+TUmZGifsSuiGcefthI7co5xj+q+t8bHPrnpP8Q+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B6YNJzKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B6YNJzKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1379C4CECD;
	Thu, 19 Dec 2024 03:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577532;
	bh=1CpTYVDTCADa0cOS9W/tKjlaFJ/uO/n2FqWnGU+oHYI=;
	h=Date:To:From:Subject:From;
	b=B6YNJzKwX3yeISjR1WJKnKOwrIK9+fC26AfCDT1/XldGgQdqhwCK/WpDN7j/qU7ln
	 NtJNj19i4oO3u0Yc8vkwocf9zclss434PKUFl1gK9bV5+AJEuBjVjLk7quUcUu1szn
	 Dp7pNfW1pRN7fj44qveMd7plEQT+q+g0fe/ACz8A=
Date: Wed, 18 Dec 2024 19:05:32 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-prevent-use-of-deleted-inode.patch removed from -mm tree
Message-Id: <20241219030532.B1379C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: prevent use of deleted inode
has been removed from the -mm tree.  Its filename was
     nilfs2-prevent-use-of-deleted-inode.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Adam Davis <eadavis@qq.com>
Subject: nilfs2: prevent use of deleted inode
Date: Mon, 9 Dec 2024 15:56:52 +0900

syzbot reported a WARNING in nilfs_rmdir. [1]

Because the inode bitmap is corrupted, an inode with an inode number that
should exist as a ".nilfs" file was reassigned by nilfs_mkdir for "file0",
causing an inode duplication during execution.  And this causes an
underflow of i_nlink in rmdir operations.

The inode is used twice by the same task to unmount and remove directories
".nilfs" and "file0", it trigger warning in nilfs_rmdir.

Avoid to this issue, check i_nlink in nilfs_iget(), if it is 0, it means
that this inode has been deleted, and iput is executed to reclaim it.

[1]
WARNING: CPU: 1 PID: 5824 at fs/inode.c:407 drop_nlink+0xc4/0x110 fs/inode.c:407
...
Call Trace:
 <TASK>
 nilfs_rmdir+0x1b0/0x250 fs/nilfs2/namei.c:342
 vfs_rmdir+0x3a3/0x510 fs/namei.c:4394
 do_rmdir+0x3b5/0x580 fs/namei.c:4453
 __do_sys_rmdir fs/namei.c:4472 [inline]
 __se_sys_rmdir fs/namei.c:4470 [inline]
 __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lkml.kernel.org/r/20241209065759.6781-1-konishi.ryusuke@gmail.com
Fixes: d25006523d0b ("nilfs2: pathname operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9260555647a5132edd48
Tested-by: syzbot+9260555647a5132edd48@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    8 +++++++-
 fs/nilfs2/namei.c |    5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c~nilfs2-prevent-use-of-deleted-inode
+++ a/fs/nilfs2/inode.c
@@ -544,8 +544,14 @@ struct inode *nilfs_iget(struct super_bl
 	inode = nilfs_iget_locked(sb, root, ino);
 	if (unlikely(!inode))
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW))
+
+	if (!(inode->i_state & I_NEW)) {
+		if (!inode->i_nlink) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
 		return inode;
+	}
 
 	err = __nilfs_read_inode(sb, root, ino, inode);
 	if (unlikely(err)) {
--- a/fs/nilfs2/namei.c~nilfs2-prevent-use-of-deleted-inode
+++ a/fs/nilfs2/namei.c
@@ -67,6 +67,11 @@ nilfs_lookup(struct inode *dir, struct d
 		inode = NULL;
 	} else {
 		inode = nilfs_iget(dir->i_sb, NILFS_I(dir)->i_root, ino);
+		if (inode == ERR_PTR(-ESTALE)) {
+			nilfs_error(dir->i_sb,
+					"deleted inode referenced: %lu", ino);
+			return ERR_PTR(-EIO);
+		}
 	}
 
 	return d_splice_alias(inode, dentry);
_

Patches currently in -mm which might be from eadavis@qq.com are


