Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B4A6FBF
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 03:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457318; cv=none; b=DnjQDed6lOJFvSljnsjuM1c2OV1mLXV0jBLtDccI+xbvfklRZK9eEfWUcYp/pbyw/zyxmCsGiB8q6bSSC22tmtcy4xrDu3FtWGl9FckiNALP8gOHPBKt/9oxT5gNiWJObKwxXd91tZ7MSOpKu4yrPoQ3jXS5HuTZnwzc0fhFe9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457318; c=relaxed/simple;
	bh=o+houXisXb5Zddu4Uw/dGeziP7uIZQarMspO0KMbDdo=;
	h=Date:To:From:Subject:Message-Id; b=Wfc8WwCFxrM6jKXXH3JSI/GA1Azl12m5fX2dRis8eQblg5UCx7/0QDsZZuEMIQFf9YKUfS0EqzgpS4RCFsLD6n0vRw/vMU0VswifiD2FtskFnAKqvG68fQTjC3wD7RxZaXas7e6Zc7BBkT3ZOEqPaeq7uY7D3x1RjKAEecYhlu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uR9amAa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uR9amAa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B06C4CED1;
	Fri,  6 Dec 2024 03:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457318;
	bh=o+houXisXb5Zddu4Uw/dGeziP7uIZQarMspO0KMbDdo=;
	h=Date:To:From:Subject:From;
	b=uR9amAa2zsHfFxjw1A5dRAFWm3tixJyBkEbxka85OQMtCVNZAK1wRsirEcQLD7nkv
	 p+wDIrk4BOF7+VPjyUYqPBjsFXjGRc/1R1x7dAyNqyE/Kf9TwPlE2gEXydkvTdguVE
	 9shiT3OMkoARwULjiuWqG9bC7RD+lUpjpXLoFJl8=
Date: Thu, 05 Dec 2024 19:55:17 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-free-inode-when-ocfs2_get_init_inode-fails.patch removed from -mm tree
Message-Id: <20241206035518.33B06C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: free inode when ocfs2_get_init_inode() fails
has been removed from the -mm tree.  Its filename was
     ocfs2-free-inode-when-ocfs2_get_init_inode-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


