Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECF22FB98D
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755125877; cv=none; b=JjdX+P84vIO95PkF00i702detPo/XBo5i4EKcGcNu1hweOYYBoPvc5y6jBHQCtm/kFbR2byIwlCKxfyyrFWPsBaumi+H0kEE+kbYaph583QuarEKGITQvDz/UWEC/WWJIQY/7h36sQVWQ1i+FtQ0XPHSDtYBqMsj5CW+xkgju40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755125877; c=relaxed/simple;
	bh=jQsNL1TmX0NCRXGUj3X7eLayuwU7DQb+j6z/S4NgvuE=;
	h=Date:To:From:Subject:Message-Id; b=Fv8VOIgUfT9trIrgNBu7nh0dgcWSeMtyCyVtvKjb3V1TOk5Hg2gOMNj1DOU40KeRemRJA3Bax5l//gou5sXNjSt4y2hfl7E8CRAiyPeNk/TJRrbyhBO6Ju9DCCn4sZfJe7Qsv1VW23Bii7EKN+collBkcpa9HpIouQdCiLdd8X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANcvQ+iW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANcvQ+iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29BFC4CEEB;
	Wed, 13 Aug 2025 22:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755125877;
	bh=jQsNL1TmX0NCRXGUj3X7eLayuwU7DQb+j6z/S4NgvuE=;
	h=Date:To:From:Subject:From;
	b=ANcvQ+iW7HpawJWSOxz7mQakl694bctI+HA6yruKLxvF1R2p8K8svCImmP53DDaM/
	 mmb+wuEWLopE7X6nGBZKIeLkgr6BjzYfocJqhLUH6VquJHoir4rv7Tu3A7GCKnaAtn
	 3DZyu7e73ryULOD8v62CVXp7m5mmXkgSfy7jeQzI=
Date: Wed, 13 Aug 2025 15:57:56 -0700
To: mm-commits@vger.kernel.org,syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,phillip@squashfs.org.uk,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-verify-inode-mode-when-loading-from-disk.patch added to mm-nonmm-unstable branch
Message-Id: <20250813225756.F29BFC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: verify inode mode when loading from disk
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-verify-inode-mode-when-loading-from-disk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-verify-inode-mode-when-loading-from-disk.patch

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
Cc: Phillip Lougher <phillip@squashfs.org.uk>
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
squashfs-verify-inode-mode-when-loading-from-disk.patch

