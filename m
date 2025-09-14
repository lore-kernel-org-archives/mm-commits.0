Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EFE381AF
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810111; cv=none; b=ungZtYXfAd3or5F9ybUSq4ueclyrQ4RDiLVuXUIVUNMDKHroqXptqLdKuVlGgrvSB7FGRZ62uS1HmR4ZP4cYp+HxLrS75XjOATBBn+6dtkRMJm+CTQX5k9fbkgvaN/MQgDQygEVPx2bExxR+aYCPZCVdrBpy5wuocjQGbKYVIU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810111; c=relaxed/simple;
	bh=twZsXYZ5jdqwSZEHVb4MVkfA0cTX2atgUKx9qk9OBrM=;
	h=Date:To:From:Subject:Message-Id; b=vDCnyxM3FPj47U2d+xlWxD/v/dW4lGYNpqRdkQyITny0APJ97CwEksptyvbuawd73HgjhAUk88neOdOr/IbB4cfA5NSGTons80s28AbkXJ/IGP6bZ1fGb/ZIc8Q1zwfVdre2lsdMcnKftF/BVpBMHJYZe+pf3M4SYwSXPsMHKS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xNPTfAE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xNPTfAE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F228DC4CEEB;
	Sun, 14 Sep 2025 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810111;
	bh=twZsXYZ5jdqwSZEHVb4MVkfA0cTX2atgUKx9qk9OBrM=;
	h=Date:To:From:Subject:From;
	b=xNPTfAE6TatxRkzLhqQmdFop8QEYlUiPeihq+4qRX2sZJQLKhrtCG3+NXzylR3jOw
	 FWUWZj669yGOSD+OucsspROb2ZLvhW9nbis+F2BJt1WEUjz4WoSyxkZpq8z+1g3wza
	 v17A+Z6xjQoDRXxu5qEGlm/YnYyMm+BTFdbj0SOA=
Date: Sat, 13 Sep 2025 17:35:10 -0700
To: mm-commits@vger.kernel.org,syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,phillip@squashfs.org.uk,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-verify-inode-mode-when-loading-from-disk.patch removed from -mm tree
Message-Id: <20250914003510.F228DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: verify inode mode when loading from disk
has been removed from the -mm tree.  Its filename was
     squashfs-verify-inode-mode-when-loading-from-disk.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: squashfs: verify inode mode when loading from disk
Date: Wed, 13 Aug 2025 16:17:43 +0900

The inode mode loaded from corrupted disk might by error contain the file
type bits.  Since the file type bits are set by squashfs_read_inode()
using bitwise OR, the file type bits must not be set by
squashfs_new_inode() from squashfs_read_inode(); otherwise, an invalid
file type bits later confuses may_open().

Link: https://lkml.kernel.org/r/f63d8d11-2254-4fc3-9292-9a43a93b374e@I-love.SAKURA.ne.jp
Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/squashfs/inode.c~squashfs-verify-inode-mode-when-loading-from-disk
+++ a/fs/squashfs/inode.c
@@ -68,6 +68,10 @@ static int squashfs_new_inode(struct sup
 	inode->i_mode = le16_to_cpu(sqsh_ino->mode);
 	inode->i_size = 0;
 
+	/* File type must not be set at this moment, for it will later be set by the caller. */
+	if (inode->i_mode & S_IFMT)
+		err = -EIO;
+
 	return err;
 }
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

ocfs2-kill-osb-system_file_mutex-lock.patch

