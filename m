Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5FF7D3F4
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 03:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730776110; cv=none; b=aQwX8hRBh2gIsaq8tKkzB0rfDhzqK6SFOww3N/CCEfMI0xhoAbn/ZMl6tLCH+5keb5Oj8cB0wB5xBqaKa7CcuIj0l6xRN3geFp73XahmWNVVJeNMeDtRSK7SFcpTFG+mIwMtM+cHpf+x5MBbWGOg7MXVGb0ib4xWFnKsAl/GdnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730776110; c=relaxed/simple;
	bh=2COzPjzAp+v/zVY/AJ4+6iQ7JYb6N87TX6SnA8zwUxo=;
	h=Date:To:From:Subject:Message-Id; b=h85fNcqkCwXS0y9wFusC3bcezXjJUBEvxFdrkPJyczc41GZ8100FU/zMhG1Cz8EPserczBKsPe5ww2CVnz09PwQf+SSkWW5oxqnZOHb+dQZ06I20YaX/Jze1qEtFlpv6wEZqoJsD+sV6ZjHoZ8QPLNgwBbV8Ml9kfMFvbsZ8B4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h9G3x6NC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h9G3x6NC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1191C4CECE;
	Tue,  5 Nov 2024 03:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730776110;
	bh=2COzPjzAp+v/zVY/AJ4+6iQ7JYb6N87TX6SnA8zwUxo=;
	h=Date:To:From:Subject:From;
	b=h9G3x6NCb57flB2wp8uLi6dyYyIuTfMSQohFiRxjD/jzJrg7fMJ0WYuc+wBNf32co
	 Cu6m263o71/GVdD9t+OR62SIy3rM2fPZMiCpPE/XcK4wnTrf7hljk3/rj0C60qpvI9
	 v87bsyIF78LIeB2FMRRTQb7Ru1AaN44zXzlFOxlM=
Date: Mon, 04 Nov 2024 19:08:29 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,ghe@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter.patch added to mm-nonmm-unstable branch
Message-Id: <20241105030829.F1191C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix uninitialized value in ocfs2_file_read_iter()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter.patch

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
Cc: Gang He <ghe@suse.com>
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

ocfs2-fix-uninitialized-value-in-ocfs2_file_read_iter.patch

