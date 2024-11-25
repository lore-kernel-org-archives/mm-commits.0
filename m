Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A4B63C
	for <mm-commits@vger.kernel.org>; Mon, 25 Nov 2024 04:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732509619; cv=none; b=BwHkfUlHOeqhewUs6kmG81pk0ZB1U0QRAnJ8654opduv68WzHW3eyk3veXkmRZbiO3Y/aa9W3T89Cr0KTqs4cPM29qRryFJHa6MsYgcUHyoxoocWcXvoBPWqWS2DG4EHqFZBlWh7eUrZPJrxqDuwbsGglyYhk+2EGg6m3gDTVxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732509619; c=relaxed/simple;
	bh=nravz9rUDUd18PqpfOWSxfKpbgQMMPAtpQ4K/kmWzW8=;
	h=Date:To:From:Subject:Message-Id; b=h5LoukDYLqaiVwjVUpJV5+RGW+8C/2DeeB+YUjWFDXrXu/uQ1sepKZ3veCORtbDyX2sY94H4OiXWpbG0h3il3p7dIFIQpvIWVVh8t+JS8E5Dzhak1FFewidUaIu5luqHiPzkb02LXqB+BCl0D0fqnuxH0oCWQsXb0oI+8zi26Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sSEZfrE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSEZfrE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC1AC4CECE;
	Mon, 25 Nov 2024 04:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732509618;
	bh=nravz9rUDUd18PqpfOWSxfKpbgQMMPAtpQ4K/kmWzW8=;
	h=Date:To:From:Subject:From;
	b=sSEZfrE/j8fxdqM37gMHmiXxv36TidTvRzJNJSfoWvAcHfGRR0irvbFrPwRXQpGti
	 4y7MgYeYHUkwVIG9rc1LDq3RvRgaWAA0S/apomsYRrpUxUFHm+g/o+aPjJICgIlbv4
	 EEwhfe4Xu0HgCo1VADY39qjgcEHYN2mEkWWkYwWc=
Date: Sun, 24 Nov 2024 20:40:09 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-free-inode-when-ocfs2_get_init_inode-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20241125044016.4EC1AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: free inode when ocfs2_get_init_inode() fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-free-inode-when-ocfs2_get_init_inode-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-free-inode-when-ocfs2_get_init_inode-fails.patch

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
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: ocfs2: free inode when ocfs2_get_init_inode() fails
Date: Sat, 23 Nov 2024 22:28:34 +0900

syzbot is reporting busy inodes after unmount, for commit 9c89fe0af826
("ocfs2: Handle error from dquot_initialize()") forgot to call iput() when
new_inode() succeeded and dquot_initialize() failed.

Link: https://lkml.kernel.org/r/e68c0224-b7c6-4784-b4fa-a9fc8c675525@I-love.SAKURA.ne.jp
Fixes: 9c89fe0af826 ("ocfs2: Handle error from dquot_initialize()")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot+0af00f6a2cba2058b5db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0af00f6a2cba2058b5db
Tested-by: syzbot+0af00f6a2cba2058b5db@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/namei.c~ocfs2-free-inode-when-ocfs2_get_init_inode-fails
+++ a/fs/ocfs2/namei.c
@@ -200,8 +200,10 @@ static struct inode *ocfs2_get_init_inod
 	mode = mode_strip_sgid(&nop_mnt_idmap, dir, mode);
 	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
 	status = dquot_initialize(inode);
-	if (status)
+	if (status) {
+		iput(inode);
 		return ERR_PTR(status);
+	}
 
 	return inode;
 }
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

ocfs2-free-inode-when-ocfs2_get_init_inode-fails.patch

