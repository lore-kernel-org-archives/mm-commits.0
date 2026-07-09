Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D63B2DB789
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 23:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783641091; cv=none; b=JVZ16pWHFAyQKL9mXFmrrjIFu2II+lo9coQNGh49EoTSO5G+uFFDdQ3vO/aNKf+kAH3O5HLl5j6RrJZwlAsj4kwgQAb61GaqV94OcD2TgQGjISD9F+GL8sQaeUpE7uEzD4CSHgTrzUWnkj20IQYC3U4gsa166mLbfOT/yqC+rlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783641091; c=relaxed/simple;
	bh=WJNRJE9rQM0oLDlQtDpsN/DKJTpZIcywaMbW6yZwUvA=;
	h=Date:To:From:Subject:Message-Id; b=OcbrSEj62dCkB7vBugUzt/5gyQH3vGeIgUs3cnQIYx/bHB2lH9ox0iPBGkuZRP6hsT8JI3aViACLRU+3mtw0n/fvAOqd3Und+xba4cekl7ghOGKeEKwcAPnHhLbNp0KlMivtvDlPdmbMfO01m+apuRQjCSiuhzIGO5JXjrTJA8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZnqB2KxH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZnqB2KxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C477A1F000E9;
	Thu,  9 Jul 2026 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783641089;
	bh=FX0HJPbM4O/yzwwjMTF3AoOFC1m3AXMpLfhphgVAAh0=;
	h=Date:To:From:Subject;
	b=ZnqB2KxHJvu1DYh9VJ5ZPqoP3oqZ+HrTfsrxK8g2wL/SMbqIS9ILzSsuZJhvHRxgS
	 AgzxnkleDrSk/bQe5CFaUIPmoJ5YbYfWenUSIUHDiNamt6kuC2dz3EjEpGnXLFS6mS
	 EzK4YXoHkbGxva5bB00Il+NFjt2e05fQAYPLlovM=
Date: Thu, 09 Jul 2026 16:51:29 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full.patch added to mm-nonmm-unstable branch
Message-Id: <20260709235129.C477A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
Date: Thu, 9 Jul 2026 09:01:01 +0300

This reverts commit 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation
failure during read").

Since 'make_bad_inode()' resets inode type to S_IFREG, doing this for
directory inode during active VFS lookup is likely to confuse the latter,
including VFS_BUG_ON_INODE() triggered in this case.

Link: https://lore.kernel.org/20260709060101.207262-1-dmantipov@yandex.ru
Fixes: 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation failure during read")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full
+++ a/fs/ocfs2/inode.c
@@ -1952,8 +1952,6 @@ int ocfs2_read_inode_block_full(struct i
 	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
 			       1, &tmp, flags, ocfs2_validate_inode_block);
 
-	if (rc < 0)
-		make_bad_inode(inode);
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
 		*bh = tmp;
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full.patch

