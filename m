From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Thu, 23 Jan 2020 14:17:53 -0800
Message-ID: <20200123221753.2AyD2XlUX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbgAWWRy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 17:17:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

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
