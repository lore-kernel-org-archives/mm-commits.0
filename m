Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B887313AA53;
	Wed, 25 Sep 2024 09:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727256636; cv=none; b=HvooN77g4s+a21J2uD39OSdGKOBs/FXuYjgkEUaB1wkR4xT93naOHsD04EMLbutps2fkkoYnb66uKfIzRVNdkcYFe2JOspeFUsKTDaD7SD7Vzv7cc+hoVbMTseOgI/fq8en8Vv0dHe51ILINEj72Yyi+1Ftr+fmds+OqNw4rtbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727256636; c=relaxed/simple;
	bh=GNZNgJHmdsf7x6AVCHa2KLXudfTWAf1UoTDhQRpdXeE=;
	h=Date:To:From:Subject:Message-Id; b=WefNGzCz7huLozc7KbdrFLOVByE4/jHRdnis9b1fWtAItFGUZcjr1cuOa6yaDKBIEU3b0UIIwFEr5AW/lGqbRSWde5utuueV3sem2a431cXDW7DFhE+tULTEws4JcwbT96+ReUmEkTELjIp/yfUmjvALmvNxvu9k3fq/pTQt9DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DlmIiUbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DlmIiUbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33920C4CEC3;
	Wed, 25 Sep 2024 09:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727256636;
	bh=GNZNgJHmdsf7x6AVCHa2KLXudfTWAf1UoTDhQRpdXeE=;
	h=Date:To:From:Subject:From;
	b=DlmIiUbb88fKC38NPoy0eMibKGPMP6hzGnTjXoRUCZ5qB8eFflpACEpzCBfvMHEnE
	 ZArAsuMkNmJCP25Oh87CnARsOhdAfwb5Gb4J6WbcbpFffbbrHGYEEm9smrW0srky52
	 WZ0JI+WWEpKBDSeTCrbQ+z+y6gCE/j+ppptev+Gg=
Date: Wed, 25 Sep 2024 02:30:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-uninit-value-in-ocfs2_get_block.patch added to mm-hotfixes-unstable branch
Message-Id: <20240925093036.33920C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix uninit-value in ocfs2_get_block()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-uninit-value-in-ocfs2_get_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-uninit-value-in-ocfs2_get_block.patch

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

ocfs2-fix-uninit-value-in-ocfs2_get_block.patch

