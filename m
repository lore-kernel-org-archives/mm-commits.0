Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E28345CDD;
	Fri,  3 Apr 2026 05:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775194076; cv=none; b=CGqDK9VxlN3WI2BgY+eGPXeup9+E9Dxa9SX8eB5MdyVfMhYLUALf8fTEx4vGSRVuEal5fsMijaN7vMkhNCpPQM3mSzbcJ4LTvPS8vk9o1qQUnkdRR+FaYQBbDl+H9+stR54VMU9foindKalMmQzHefENmFS6Tl+LlfgDkhPlSBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775194076; c=relaxed/simple;
	bh=FISPdyOFrZe+ATdMVkGKeWhDuCEENstA4r+bEa9c9Aw=;
	h=Date:To:From:Subject:Message-Id; b=aiTthFlN/LXycxer5P1ZPUOBPEejlkLddIAdLUYR7+q3SKQiazyOpGr6gMxZeyW7QgAZLeu6IMn6FtJRokX9oEID36ZyC2Tuk+WhjLdi3jioAqYECfyM2mNbXgI9ZiONkToqaH0qoXPqISh9twatcNyetguwp0uLoD2+sSlXYzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s37K6hzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s37K6hzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A022DC4CEF7;
	Fri,  3 Apr 2026 05:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775194075;
	bh=FISPdyOFrZe+ATdMVkGKeWhDuCEENstA4r+bEa9c9Aw=;
	h=Date:To:From:Subject:From;
	b=s37K6hzZr2dNVWSjS0S0tNWVWsrp0drmBD6WpYNWOkHtx5uF3ZbHFPr99K/y6hVN5
	 QUtA+cXcXpS4zFOm1OOWitI/w95RJjTxT06sI2d1pvJoR/rttnRp5jIu7mc2epeIz9
	 byAHriGnv2yC0JPihbyviazYM+OFrjK7QbSNhetU=
Date: Thu, 02 Apr 2026 22:27:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,tejas.bharambe@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch added to mm-nonmm-unstable branch
Message-Id: <20260403052755.A022DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Tejas Bharambe <tejas.bharambe@outlook.com>
Subject: ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Wed, 1 Apr 2026 21:02:34 -0700

filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
as documented in mm/filemap.c:

  "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
  may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."

When this happens, a concurrent munmap() can call remove_vma() and free
the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
dereferences it -- a use-after-free.

Fix this by saving the inode reference before calling filemap_fault(),
and removing vma from the trace event. The inode remains valid across
the lock drop since the file is still open, so the trace can fire in
all cases without dereferencing the potentially freed vma.

Link: https://lkml.kernel.org/r/20260403035333.136824-1-tejas.bharambe@outlook.com
Link: https://lkml.kernel.org/r/20260402040234.92432-1-tejas.bharambe@outlook.com
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

 fs/ocfs2/mmap.c        |    6 +++---
 fs/ocfs2/ocfs2_trace.h |   10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/mmap.c~ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry
+++ a/fs/ocfs2/mmap.c
@@ -30,7 +30,7 @@
 
 static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	sigset_t oldset;
 	vm_fault_t ret;
 
@@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_
 	ret = filemap_fault(vmf);
 	ocfs2_unblock_signals(&oldset);
 
-	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
-			  vma, vmf->page, vmf->pgoff);
+	trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
+			  vmf->page, vmf->pgoff);
 	return ret;
 }
 
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

ocfs2-fix-use-after-free-in-ocfs2_fault-when-vm_fault_retry.patch

