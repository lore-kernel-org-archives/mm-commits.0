From: akpm@linux-foundation.org
Subject: [merged] proc-less-memory-for-proc-map_files-readdir.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:56:00 -0800
Message-ID: <20180207195600.TASHo4x8g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbeBGT4B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: less memory for /proc/*/map_files readdir
has been removed from the -mm tree.  Its filename was
     proc-less-memory-for-proc-map_files-readdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: less memory for /proc/*/map_files readdir

dentry name can be evaluated later, right before calling into VFS.

Also, spend less time under ->mmap_sem.

Link: http://lkml.kernel.org/r/20171110163034.GA2534@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-less-memory-for-proc-map_files-readdir fs/proc/base.c
--- a/fs/proc/base.c~proc-less-memory-for-proc-map_files-readdir
+++ a/fs/proc/base.c
@@ -2026,9 +2026,9 @@ out:
 }
 
 struct map_files_info {
+	unsigned long	start;
+	unsigned long	end;
 	fmode_t		mode;
-	unsigned int	len;
-	unsigned char	name[4*sizeof(long)+2]; /* max: %lx-%lx\0 */
 };
 
 /*
@@ -2198,10 +2198,9 @@ proc_map_files_readdir(struct file *file
 			if (++pos <= ctx->pos)
 				continue;
 
+			info.start = vma->vm_start;
+			info.end = vma->vm_end;
 			info.mode = vma->vm_file->f_mode;
-			info.len = snprintf(info.name,
-					sizeof(info.name), "%lx-%lx",
-					vma->vm_start, vma->vm_end);
 			if (flex_array_put(fa, i++, &info, GFP_KERNEL))
 				BUG();
 		}
@@ -2209,9 +2208,13 @@ proc_map_files_readdir(struct file *file
 	up_read(&mm->mmap_sem);
 
 	for (i = 0; i < nr_files; i++) {
+		char buf[4 * sizeof(long) + 2];	/* max: %lx-%lx\0 */
+		unsigned int len;
+
 		p = flex_array_get(fa, i);
+		len = snprintf(buf, sizeof(buf), "%lx-%lx", p->start, p->end);
 		if (!proc_fill_cache(file, ctx,
-				      p->name, p->len,
+				      buf, len,
 				      proc_map_files_instantiate,
 				      task,
 				      (void *)(unsigned long)p->mode))
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch

