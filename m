Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BA1631;
	Wed, 14 Aug 2024 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596603; cv=none; b=VUliDyzQzG37SNAuwsu+25vYzJMd0hZHhODigtgX7bv7TcVie/ADRIgc2yjpuGlRguBfSZc5zzGuSlc9fKbd7lbncQMIHdtdMM7bH9bS5AkT4PEdSBOXQ3r5G6nGXOrJ7bTSSpXeyqF8ArPtHTJDAM5YxI/hr5YZxvgg8XJsdKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596603; c=relaxed/simple;
	bh=I32+sTObO1qHA580hNby1ngJWF5eI+mQSCNRkHDgNhA=;
	h=Date:To:From:Subject:Message-Id; b=HlSBbTKyWpdTGoo6QcustLoaPSppZhDQ4MysO2t6bGvLBMdn+2PRNEANqY1dsMA3pL2eRVF3/giXr1Ox1qazgbl4zhaDj8APnQqvExH4oCZEn10/8U/tEE07EEEXd68l3qYqotkAp06bjnsi2zbD0/6w6gcWJXR4ekUIJvWLLWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wIwB2lL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wIwB2lL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9121FC32782;
	Wed, 14 Aug 2024 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723596602;
	bh=I32+sTObO1qHA580hNby1ngJWF5eI+mQSCNRkHDgNhA=;
	h=Date:To:From:Subject:From;
	b=wIwB2lL/5vdLN3JxUM9BreLVaoNb271sZMAP/Wwb6xaVQfzU5PRoqVxtzW1MSNDTk
	 ZCweGICPvmNKS4XcnpZarZlLK1h42OETK8i2gkaMte+pYcpRQAguUv4s+rejZ/Qzio
	 KwLGardXIeB0tzCHPr6V7/WaeBgVFXy9itpcyaXc=
Date: Tue, 13 Aug 2024 17:50:01 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,lizhi.xu@windriver.com,jack@suse.cz,brauner@kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-sanity-check-symbolic-link-size.patch added to mm-hotfixes-unstable branch
Message-Id: <20240814005002.9121FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: sanity check symbolic link size
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-sanity-check-symbolic-link-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-sanity-check-symbolic-link-size.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: sanity check symbolic link size
Date: Sun, 11 Aug 2024 21:13:01 +0100

Syzkiller reports a "KMSAN: uninit-value in pick_link" bug.

This is caused by an uninitialised page, which is ultimately caused
by a corrupted symbolic link size read from disk.

The reason why the corrupted symlink size causes an uninitialised
page is due to the following sequence of events:

1. squashfs_read_inode() is called to read the symbolic
   link from disk.  This assigns the corrupted value
   3875536935 to inode->i_size.

2. Later squashfs_symlink_read_folio() is called, which assigns
   this corrupted value to the length variable, which being a
   signed int, overflows producing a negative number.

3. The following loop that fills in the page contents checks that
   the copied bytes is less than length, which being negative means
   the loop is skipped, producing an unitialised page.

This patch adds a sanity check which checks that the symbolic
link size is not larger than expected.

Link: https://lkml.kernel.org/r/20240811201301.13076-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Lizhi Xu <lizhi.xu@windriver.com>
Reported-by: syzbot+24ac24ff58dc5b0d26b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000a90e8c061e86a76b@google.com/
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/squashfs/inode.c~squashfs-sanity-check-symbolic-link-size
+++ a/fs/squashfs/inode.c
@@ -279,8 +279,13 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
+		if (inode->i_size > PAGE_SIZE) {
+			ERROR("Corrupted symlink\n");
+			return -EINVAL;
+		}
+
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_symlink_inode_ops;
 		inode_nohighmem(inode);
 		inode->i_data.a_ops = &squashfs_symlink_aops;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-sanity-check-symbolic-link-size.patch

