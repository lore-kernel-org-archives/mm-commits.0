From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 22 Jan 2020 11:42:08 -0800
Message-ID: <20200122194208.LcgkMYSmp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVTmJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 22 Jan 2020 14:42:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/io_uring.c                 |   16 ----------------
 include/uapi/linux/io_uring.h |    3 ---
 2 files changed, 19 deletions(-)

--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -5568,29 +5568,13 @@ static int __io_sqe_files_update(struct
 	int fd, i, err;
 	__u32 done;
 
-<<<<<<< HEAD
-	if (!ctx->file_table)
-		return -ENXIO;
-	if (!nr_args)
-		return -EINVAL;
-	if (copy_from_user(&up, arg, sizeof(up)))
-		return -EFAULT;
-	if (up.resv)
-		return -EINVAL;
-	if (check_add_overflow(up.offset, nr_args, &done))
-=======
 	if (check_add_overflow(up->offset, nr_args, &done))
->>>>>>> linux-next/akpm-base
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
 
 	done = 0;
-<<<<<<< HEAD
-	fds = u64_to_user_ptr(up.fds);
-=======
 	fds = u64_to_user_ptr(up->fds);
->>>>>>> linux-next/akpm-base
 	while (nr_args) {
 		struct fixed_file_table *table;
 		unsigned index;
--- a/include/uapi/linux/io_uring.h~linux-next-git-rejects
+++ a/include/uapi/linux/io_uring.h
@@ -213,8 +213,6 @@ struct io_uring_files_update {
 	__u32 offset;
 	__u32 resv;
 	__aligned_u64 /* __s32 * */ fds;
-<<<<<<< HEAD
-=======
 };
 
 #define IO_URING_OP_SUPPORTED	(1U << 0)
@@ -232,7 +230,6 @@ struct io_uring_probe {
 	__u16 resv;
 	__u32 resv2[3];
 	struct io_uring_probe_op ops[0];
->>>>>>> linux-next/akpm-base
 };
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmscan-remove-unused-reclaim_off-reclaim_zone-fix.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-fix.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
