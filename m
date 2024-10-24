Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A09175D53;
	Thu, 24 Oct 2024 06:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750527; cv=none; b=LMPpkr2d8j8jVQttnWNz+XJ5UKmMLBOo02pitTfMV7opf4AGiWaH/kL1gIySJaqsS8/zygMmy9SlNjvnYfk/bHDfBxz2bOZ7i67VNYvwGIGXmJRAXU1+sLd0rm/+9W2rTC/wZdVhARzT3t8ZUJ4mOMfywj9uTo43KZmpZlzNYRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750527; c=relaxed/simple;
	bh=FOOzta/UdX2RtUPe2fQc6zNRgJvCXD3sI6dpXhCGqFA=;
	h=Date:To:From:Subject:Message-Id; b=KqEeXYEoUKuFwQNrVlwSvXk6nih1UrNe0HLjVDFnQKjpS/juMfqFJLyKwupHqTkiec76tL5+otrgNeNhzBUksC7GKN2XFReztbI98MsIe2g8yQIB0m4gw4itrZ6btByWic677pqcVZQRz1Wr4SdnrYidQxG2rTa1IMLtnFSM2yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MwGyED3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MwGyED3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F368C4CECC;
	Thu, 24 Oct 2024 06:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750527;
	bh=FOOzta/UdX2RtUPe2fQc6zNRgJvCXD3sI6dpXhCGqFA=;
	h=Date:To:From:Subject:From;
	b=MwGyED3XLYZTvFMBNlZnArF5/hHNBKmCiPyc84jId3Oj4+q0gcBAAxu9qX/8pYhps
	 hDuSLje7wc7Ks3EO7/W9o4YepTt50QEK1elAT7GwJeSD9n2CmFM5dMpmlJcq/zp0Dv
	 2UdF3cwPiOkCSyfY1w77eRJbUqCPoNDIyexLUdCo=
Date: Wed, 23 Oct 2024 23:15:26 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,syzkaller@googlegroup.com,stable@vger.kernel.org,hughd@google.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-data-race-in-shmem_getattr.patch removed from -mm tree
Message-Id: <20241024061527.5F368C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix data-race in shmem_getattr()
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-data-race-in-shmem_getattr.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm: shmem: fix data-race in shmem_getattr()
Date: Mon, 9 Sep 2024 21:35:58 +0900

I got the following KCSAN report during syzbot testing:

==================================================================
BUG: KCSAN: data-race in generic_fillattr / inode_set_ctime_current

write to 0xffff888102eb3260 of 4 bytes by task 6565 on cpu 1:
 inode_set_ctime_to_ts include/linux/fs.h:1638 [inline]
 inode_set_ctime_current+0x169/0x1d0 fs/inode.c:2626
 shmem_mknod+0x117/0x180 mm/shmem.c:3443
 shmem_create+0x34/0x40 mm/shmem.c:3497
 lookup_open fs/namei.c:3578 [inline]
 open_last_lookups fs/namei.c:3647 [inline]
 path_openat+0xdbc/0x1f00 fs/namei.c:3883
 do_filp_open+0xf7/0x200 fs/namei.c:3913
 do_sys_openat2+0xab/0x120 fs/open.c:1416
 do_sys_open fs/open.c:1431 [inline]
 __do_sys_openat fs/open.c:1447 [inline]
 __se_sys_openat fs/open.c:1442 [inline]
 __x64_sys_openat+0xf3/0x120 fs/open.c:1442
 x64_sys_call+0x1025/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:258
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x54/0x120 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

read to 0xffff888102eb3260 of 4 bytes by task 3498 on cpu 0:
 inode_get_ctime_nsec include/linux/fs.h:1623 [inline]
 inode_get_ctime include/linux/fs.h:1629 [inline]
 generic_fillattr+0x1dd/0x2f0 fs/stat.c:62
 shmem_getattr+0x17b/0x200 mm/shmem.c:1157
 vfs_getattr_nosec fs/stat.c:166 [inline]
 vfs_getattr+0x19b/0x1e0 fs/stat.c:207
 vfs_statx_path fs/stat.c:251 [inline]
 vfs_statx+0x134/0x2f0 fs/stat.c:315
 vfs_fstatat+0xec/0x110 fs/stat.c:341
 __do_sys_newfstatat fs/stat.c:505 [inline]
 __se_sys_newfstatat+0x58/0x260 fs/stat.c:499
 __x64_sys_newfstatat+0x55/0x70 fs/stat.c:499
 x64_sys_call+0x141f/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:263
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x54/0x120 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

value changed: 0x2755ae53 -> 0x27ee44d3

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 3498 Comm: udevd Not tainted 6.11.0-rc6-syzkaller-00326-gd1f2d51b711a-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
==================================================================

When calling generic_fillattr(), if you don't hold read lock, data-race
will occur in inode member variables, which can cause unexpected
behavior.

Since there is no special protection when shmem_getattr() calls
generic_fillattr(), data-race occurs by functions such as shmem_unlink()
or shmem_mknod(). This can cause unexpected results, so commenting it out
is not enough.

Therefore, when calling generic_fillattr() from shmem_getattr(), it is
appropriate to protect the inode using inode_lock_shared() and
inode_unlock_shared() to prevent data-race.

Link: https://lkml.kernel.org/r/20240909123558.70229-1-aha310510@gmail.com
Fixes: 44a30220bc0a ("shmem: recalculate file inode when fstat")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot <syzkaller@googlegroup.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~mm-shmem-fix-data-race-in-shmem_getattr
+++ a/mm/shmem.c
@@ -1166,7 +1166,9 @@ static int shmem_getattr(struct mnt_idma
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 			STATX_ATTR_IMMUTABLE |
 			STATX_ATTR_NODUMP);
+	inode_lock_shared(inode);
 	generic_fillattr(idmap, request_mask, inode, stat);
+	inode_unlock_shared(inode);
 
 	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
_

Patches currently in -mm which might be from aha310510@gmail.com are


