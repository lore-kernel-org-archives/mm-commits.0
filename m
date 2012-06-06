From: akpm@linux-foundation.org
Subject: + ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch added to -mm tree
Date: Wed, 06 Jun 2012 16:04:45 -0700
Message-ID: <20120606230445.8FD42A02BF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33227 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab2FFXEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 19:04:46 -0400
Received: by ghbz15 with SMTP id z15so767120ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 16:04:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, hughd@google.com


The patch titled
     Subject: ipc: shm: restore MADV_REMOVE functionality on shared memory segments
has been added to the -mm tree.  Its filename is
     ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Hugh Dickins <hughd@google.com>
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
+		return -EINVAL;
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
Subject: Subject: ipc: shm: restore MADV_REMOVE functionality on shared memory segments

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch

