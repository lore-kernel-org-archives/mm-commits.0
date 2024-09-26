Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F312F59C;
	Thu, 26 Sep 2024 21:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384666; cv=none; b=c0maZ5QGnTKMH1+Lf9vYbygqW3AdrFRLJoi5ezLyQNurQtId3u1f/5CAU5SGfap/lykwvAQJA729rGMurTELUuKzUIpeyH9TMqoO9BMcVOen4tGz2OcvrYbmhw7OasH/ZKmT3pqW87XFodomT1a+ZVXNa5x82yVhimQB9/MHUBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384666; c=relaxed/simple;
	bh=oya1ePRMiXGKM3xMDTrnTlV/vIzqfre1aee1S/E4J4Q=;
	h=Date:To:From:Subject:Message-Id; b=nJjz+Y76vUP8q44N86EvH9iBZ17r1yG9Hj8gAVQEX/0k633W3Sg6224N633lcxWvzGfin/oZhGXnXBj9Ay4Yh5Qf2aorMt2DGO5LYvn6v+O2Brxq/jaLs+RLrEJELNQBJ0XvW78OgVQQpKi+aPrCGeVU7cctvFaVsu4cQO5p8vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V6yBxt8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V6yBxt8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3742CC4CEC5;
	Thu, 26 Sep 2024 21:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384666;
	bh=oya1ePRMiXGKM3xMDTrnTlV/vIzqfre1aee1S/E4J4Q=;
	h=Date:To:From:Subject:From;
	b=V6yBxt8cOBeT9QRuye2j/2zbXmXKZfk8e15jKysiBVqdP7p1hXbLdmG7cGw2LDGa/
	 sSTXHhHHqaMRxWmGDubYidtQ5C74q2EB9CG3bDqM8UD8CyvVWC8xkJWfaAylB54hbZ
	 Bt8jtf/kaLguNb/ARL2wvoCSAUMzDnbBOIJfg100=
Date: Thu, 26 Sep 2024 14:04:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-uninit-value-in-ocfs2_get_block.patch removed from -mm tree
Message-Id: <20240926210426.3742CC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix uninit-value in ocfs2_get_block()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-uninit-value-in-ocfs2_get_block.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix uninit-value in ocfs2_get_block()
Date: Wed, 25 Sep 2024 17:06:00 +0800

syzbot reported an uninit-value BUG:

BUG: KMSAN: uninit-value in ocfs2_get_block+0xed2/0x2710 fs/ocfs2/aops.c:159
ocfs2_get_block+0xed2/0x2710 fs/ocfs2/aops.c:159
do_mpage_readpage+0xc45/0x2780 fs/mpage.c:225
mpage_readahead+0x43f/0x840 fs/mpage.c:374
ocfs2_readahead+0x269/0x320 fs/ocfs2/aops.c:381
read_pages+0x193/0x1110 mm/readahead.c:160
page_cache_ra_unbounded+0x901/0x9f0 mm/readahead.c:273
do_page_cache_ra mm/readahead.c:303 [inline]
force_page_cache_ra+0x3b1/0x4b0 mm/readahead.c:332
force_page_cache_readahead mm/internal.h:347 [inline]
generic_fadvise+0x6b0/0xa90 mm/fadvise.c:106
vfs_fadvise mm/fadvise.c:185 [inline]
ksys_fadvise64_64 mm/fadvise.c:199 [inline]
__do_sys_fadvise64 mm/fadvise.c:214 [inline]
__se_sys_fadvise64 mm/fadvise.c:212 [inline]
__x64_sys_fadvise64+0x1fb/0x3a0 mm/fadvise.c:212
x64_sys_call+0xe11/0x3ba0
arch/x86/include/generated/asm/syscalls_64.h:222
do_syscall_x64 arch/x86/entry/common.c:52 [inline]
do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
entry_SYSCALL_64_after_hwframe+0x77/0x7f

This is because when ocfs2_extent_map_get_blocks() fails, p_blkno is
uninitialized.  So the error log will trigger the above uninit-value
access.

The error log is out-of-date since get_blocks() was removed long time ago.
And the error code will be logged in ocfs2_extent_map_get_blocks() once
ocfs2_get_cluster() fails, so fix this by only logging inode and block.

Link: https://syzkaller.appspot.com/bug?extid=9709e73bae885b05314b
Link: https://lkml.kernel.org/r/20240925090600.3643376-1-joseph.qi@linux.alibaba.com
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com
Tested-by: syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-fix-uninit-value-in-ocfs2_get_block
+++ a/fs/ocfs2/aops.c
@@ -156,9 +156,8 @@ int ocfs2_get_block(struct inode *inode,
 	err = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno, &count,
 					  &ext_flags);
 	if (err) {
-		mlog(ML_ERROR, "Error %d from get_blocks(0x%p, %llu, 1, "
-		     "%llu, NULL)\n", err, inode, (unsigned long long)iblock,
-		     (unsigned long long)p_blkno);
+		mlog(ML_ERROR, "get_blocks() failed, inode: 0x%p, "
+		     "block: %llu\n", inode, (unsigned long long)iblock);
 		goto bail;
 	}
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


