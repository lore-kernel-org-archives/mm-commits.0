Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2C02572
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 01:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374256; cv=none; b=YIDbGhcZK0KPjqqzs3XF1fKc1G95So5KVBhz8xU37wp7GaLDrrWFH58uk/85Ayp3P4JY7ucAodLF8O3BQ6FyF+freSj6zUNboGmQJ32Kopf1u9gSVqpH6nPy3Dx+79SU6ZJUa0Cd7bsGoA9zqACiejDR00V+yIBWFYaLstU1YHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374256; c=relaxed/simple;
	bh=U+dfrB0GafsEwiffMk74kp8WTIWcgNVzOeOEBLfpSGU=;
	h=Date:To:From:Subject:Message-Id; b=H8pQBwrRzGXfweqpAPlHvgOaczD3O9sQlyTfCVsKfpnu48N4l0V/9y0kOu/fmMwfec1vOYfbe59ttp7uL2qpolXE8I94CzQox8HQ5Z5p32t/tlo4ENzOmDZLwnnPyv3UZeSxLb0oTGgsZxNp4ddCiwbQRN0G7bCVOAZ37wj9V/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=llzrY5Cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="llzrY5Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869F9C4CED0;
	Tue, 12 Nov 2024 01:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374256;
	bh=U+dfrB0GafsEwiffMk74kp8WTIWcgNVzOeOEBLfpSGU=;
	h=Date:To:From:Subject:From;
	b=llzrY5CzcvkwaBhepFB48h+fykQpTpuYwH++5lzJejV0BIuT2AJNdKmg8yCaZSiiF
	 aetc2XVVOOd85BvHNwVX/lNs9/YVaCfid7/4UOk4Ky8tIunxL024QvrVQuW9wXRSz0
	 FsCEc3cD9No0b1/uTB/tufYf9FqnUM+Hw9PNjSYQ=
Date: Mon, 11 Nov 2024 17:17:36 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter.patch removed from -mm tree
Message-Id: <20241112011736.869F9C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix uninitialized value in ocfs2_file_read_iter()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: fix uninitialized value in ocfs2_file_read_iter()
Date: Tue, 29 Oct 2024 12:17:36 +0300

Syzbot has reported the following KMSAN splat:

BUG: KMSAN: uninit-value in ocfs2_file_read_iter+0x9a4/0xf80
 ocfs2_file_read_iter+0x9a4/0xf80
 __io_read+0x8d4/0x20f0
 io_read+0x3e/0xf0
 io_issue_sqe+0x42b/0x22c0
 io_wq_submit_work+0xaf9/0xdc0
 io_worker_handle_work+0xd13/0x2110
 io_wq_worker+0x447/0x1410
 ret_from_fork+0x6f/0x90
 ret_from_fork_asm+0x1a/0x30

Uninit was created at:
 __alloc_pages_noprof+0x9a7/0xe00
 alloc_pages_mpol_noprof+0x299/0x990
 alloc_pages_noprof+0x1bf/0x1e0
 allocate_slab+0x33a/0x1250
 ___slab_alloc+0x12ef/0x35e0
 kmem_cache_alloc_bulk_noprof+0x486/0x1330
 __io_alloc_req_refill+0x84/0x560
 io_submit_sqes+0x172f/0x2f30
 __se_sys_io_uring_enter+0x406/0x41c0
 __x64_sys_io_uring_enter+0x11f/0x1a0
 x64_sys_call+0x2b54/0x3ba0
 do_syscall_64+0xcd/0x1e0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Since an instance of 'struct kiocb' may be passed from the block layer
with 'private' field uninitialized, introduce 'ocfs2_iocb_init_rw_locked()'
and use it from where 'ocfs2_dio_end_io()' might take care, i.e. in
'ocfs2_file_read_iter()' and 'ocfs2_file_write_iter()'.

Link: https://lkml.kernel.org/r/20241029091736.1501946-1-dmantipov@yandex.ru
Fixes: 7cdfc3a1c397 ("ocfs2: Remember rw lock level during direct io")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+a73e253cca4f0230a5a5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a73e253cca4f0230a5a5
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.h |    2 ++
 fs/ocfs2/file.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/fs/ocfs2/aops.h~ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter
+++ a/fs/ocfs2/aops.h
@@ -70,6 +70,8 @@ enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_NUM_LOCKS
 };
 
+#define ocfs2_iocb_init_rw_locked(iocb) \
+	(iocb->private = NULL)
 #define ocfs2_iocb_clear_rw_locked(iocb) \
 	clear_bit(OCFS2_IOCB_RW_LOCK, (unsigned long *)&iocb->private)
 #define ocfs2_iocb_rw_locked_level(iocb) \
--- a/fs/ocfs2/file.c~ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter
+++ a/fs/ocfs2/file.c
@@ -2398,6 +2398,8 @@ static ssize_t ocfs2_file_write_iter(str
 	} else
 		inode_lock(inode);
 
+	ocfs2_iocb_init_rw_locked(iocb);
+
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
@@ -2544,6 +2546,8 @@ static ssize_t ocfs2_file_read_iter(stru
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
 
+	ocfs2_iocb_init_rw_locked(iocb);
+
 	/*
 	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-fix-ubsan-warning-in-ocfs2_verify_volume.patch

