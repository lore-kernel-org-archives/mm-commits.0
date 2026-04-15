Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDFA57C9F;
	Wed, 15 Apr 2026 09:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244576; cv=none; b=MRCZ1/k1QHmjK88VYklR/ycKVT0HMcJTWzabqgo6I5f3640TCvbqGFQ6SMOZ2gqS+P2dv/MozMzUsyjqgoaOfeTzflVWQgoofSDUJC9LlD/reJIFbpBR2wTnubx2pKUsX8d2zgrSjQR5fiy9mcrF4kaEthqcnjMKeGx3yF4890I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244576; c=relaxed/simple;
	bh=Xg1OB2nI74Uzv79SyIalBjj2Phu6e8WjX8DGMlc+NXc=;
	h=Date:To:From:Subject:Message-Id; b=DX7DeEt5vQTEyVdHpzfByv8DRLk6KlfilPAS/ketvdLRrd55LBTfG7BcX1T7usn9McUPbFNb/dDhCjGzLyTQfjx34tVxVXmoWhgpXnOfsEWU56aE9cJ3qs78rUbaMDTzYvkaV2o5cywNg3+bnd4U9tYqX1oBG9vyvJaIsEgQ1Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I5P3lSkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I5P3lSkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9ECC19424;
	Wed, 15 Apr 2026 09:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244575;
	bh=Xg1OB2nI74Uzv79SyIalBjj2Phu6e8WjX8DGMlc+NXc=;
	h=Date:To:From:Subject:From;
	b=I5P3lSkhoj4+TTFss3vbQtCV8FKbr544HhKskUClYxEqzG1y3bH/Cvcxb+iHrrSEZ
	 hoPoEKuENZNmjX+N61VvYYniVRqPLGq/66qm+QAQW65c7+bpgZ/VmAn0xDdcs/qKVD
	 4p6AJhkjvjSseT23ItSn8P0ENrJUQ8wUyPJXWuao=
Date: Wed, 15 Apr 2026 02:16:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,tejas.bharambe@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch removed from -mm tree
Message-Id: <20260415091615.3C9ECC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tejas Bharambe <tejas.bharambe@outlook.com>
Subject: ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Fri, 10 Apr 2026 01:38:16 -0700

filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
as documented in mm/filemap.c:

  "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
  may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."

When this happens, a concurrent munmap() can call remove_vma() and free
the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
dereferences it -- a use-after-free.

Fix this by saving ip_blkno as a plain integer before calling
filemap_fault(), and removing vma from the trace event. Since
ip_blkno is copied by value before the lock can be dropped, it
remains valid regardless of what happens to the vma or inode
afterward.

Link: https://lkml.kernel.org/r/20260410083816.34951-1-tejas.bharambe@outlook.com
Fixes: 614a9e849ca6 ("ocfs2: Remove FILE_IO from masklog.")
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/mmap.c        |    7 +++----
 fs/ocfs2/ocfs2_trace.h |   10 ++++------
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/mmap.c~ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry
+++ a/fs/ocfs2/mmap.c
@@ -30,7 +30,8 @@
 
 static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
+	unsigned long long ip_blkno =
+		OCFS2_I(file_inode(vmf->vma->vm_file))->ip_blkno;
 	sigset_t oldset;
 	vm_fault_t ret;
 
@@ -38,11 +39,9 @@ static vm_fault_t ocfs2_fault(struct vm_
 	ret = filemap_fault(vmf);
 	ocfs2_unblock_signals(&oldset);
 
-	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
-			  vma, vmf->page, vmf->pgoff);
+	trace_ocfs2_fault(ip_blkno, vmf->page, vmf->pgoff);
 	return ret;
 }
-
 static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 			struct buffer_head *di_bh, struct folio *folio)
 {
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,
 
 TRACE_EVENT(ocfs2_fault,
 	TP_PROTO(unsigned long long ino,
-		 void *area, void *page, unsigned long pgoff),
-	TP_ARGS(ino, area, page, pgoff),
+		 void *page, unsigned long pgoff),
+	TP_ARGS(ino, page, pgoff),
 	TP_STRUCT__entry(
 		__field(unsigned long long, ino)
-		__field(void *, area)
 		__field(void *, page)
 		__field(unsigned long, pgoff)
 	),
 	TP_fast_assign(
 		__entry->ino = ino;
-		__entry->area = area;
 		__entry->page = page;
 		__entry->pgoff = pgoff;
 	),
-	TP_printk("%llu %p %p %lu",
-		  __entry->ino, __entry->area, __entry->page, __entry->pgoff)
+	TP_printk("%llu %p %lu",
+		  __entry->ino, __entry->page, __entry->pgoff)
 );
 
 /* End of trace events for fs/ocfs2/mmap.c. */
_

Patches currently in -mm which might be from tejas.bharambe@outlook.com are


