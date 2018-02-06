From: akpm@linux-foundation.org
Subject: [patch 019/114] proc: less memory for /proc/*/map_files
 readdir
Date: Tue, 06 Feb 2018 15:37:06 -0800
Message-ID: <20180206233706.B7jdSewus%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbeBFXhI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
