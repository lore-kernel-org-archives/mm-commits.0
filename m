From: akpm@linux-foundation.org
Subject: + proc-less-memory-for-proc-map_files-readdir.patch added to -mm
 tree
Date: Tue, 21 Nov 2017 15:24:39 -0800
Message-ID: <5a14b5b7.hnmWw+0MqyFUt9LP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdKUXYl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:24:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: less memory for /proc/*/map_files readdir
has been added to the -mm tree.  Its filename is
     proc-less-memory-for-proc-map_files-readdir.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-less-memory-for-proc-map_files-readdir.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-less-memory-for-proc-map_files-readdir.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2027,9 +2027,9 @@ out:
 }
 
 struct map_files_info {
+	unsigned long	start;
+	unsigned long	end;
 	fmode_t		mode;
-	unsigned int	len;
-	unsigned char	name[4*sizeof(long)+2]; /* max: %lx-%lx\0 */
 };
 
 /*
@@ -2199,10 +2199,9 @@ proc_map_files_readdir(struct file *file
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
@@ -2210,9 +2209,13 @@ proc_map_files_readdir(struct file *file
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

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
proc-simpler-proc-vmcore-cleanup.patch
proc-less-memory-for-proc-map_files-readdir.patch
seq_file-delete-small-value-optimization.patch

