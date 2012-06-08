From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:35 -0700
Message-ID: <20120608194135.6972FA022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:46566 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab2FHTlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:37 -0400
Received: by eaao13 with SMTP id o13so126102eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: shm: restore MADV_REMOVE functionality on shared memory segments
has been removed from the -mm tree.  Its filename was
     ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: ipc: shm: restore MADV_REMOVE functionality on shared memory segments

Commit 17cf28af ("mm/fs: remove truncate_range") removed the
truncate_range inode operation in favour of the fallocate file operation.

When using SYSV IPC shared memory segments, calling madvise with the
MADV_REMOVE advice on an area of shared memory will attempt to invoke the
.fallocate function for the shm_file_operations, which is NULL and
therefore returns -EOPNOTSUPP to userspace.  The previous behaviour would
inherit the inode_operations from the underlying tmpfs file and invoke
truncate_range there.

This patch restores the previous behaviour by wrapping the underlying
fallocate function in shm_fallocate, as we do for fsync.

[hughd@google.com: use -ENOTSUPP in shm_fallocate()]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN ipc/shm.c~ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments ipc/shm.c
--- a/ipc/shm.c~ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments
+++ a/ipc/shm.c
@@ -393,6 +393,16 @@ static int shm_fsync(struct file *file, 
 	return sfd->file->f_op->fsync(sfd->file, start, end, datasync);
 }
 
+static long shm_fallocate(struct file *file, int mode, loff_t offset,
+			  loff_t len)
+{
+	struct shm_file_data *sfd = shm_file_data(file);
+
+	if (!sfd->file->f_op->fallocate)
+		return -EOPNOTSUPP;
+	return sfd->file->f_op->fallocate(file, mode, offset, len);
+}
+
 static unsigned long shm_get_unmapped_area(struct file *file,
 	unsigned long addr, unsigned long len, unsigned long pgoff,
 	unsigned long flags)
@@ -410,6 +420,7 @@ static const struct file_operations shm_
 	.get_unmapped_area	= shm_get_unmapped_area,
 #endif
 	.llseek		= noop_llseek,
+	.fallocate	= shm_fallocate,
 };
 
 static const struct file_operations shm_file_operations_huge = {
@@ -418,6 +429,7 @@ static const struct file_operations shm_
 	.release	= shm_release,
 	.get_unmapped_area	= shm_get_unmapped_area,
 	.llseek		= noop_llseek,
+	.fallocate	= shm_fallocate,
 };
 
 int is_file_shm_hugepages(struct file *file)
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch

