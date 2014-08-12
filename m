From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch removed from -mm tree
Date: Tue, 12 Aug 2014 13:35:18 -0700
Message-ID: <53ea7a86.Hj8hOXZJHMaquF+G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35632 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaHLUfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:35:19 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so1316262yha.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:35:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remap_file_pages: grab file ref to prevent race while mmaping
has been removed from the -mm tree.  Its filename was
     mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

This patch was dropped because it was folded into mm-replace-remap_file_pages-syscall-with-emulation.patch

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: remap_file_pages: grab file ref to prevent race while mmaping

A file reference should be held while a file is mmaped, otherwise it might
be freed while being used.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix-3 mm/mmap.c
--- a/mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix-3
+++ a/mm/mmap.c
@@ -2616,6 +2616,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	struct vm_area_struct *vma;
 	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
+	struct file *file;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
@@ -2659,8 +2660,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		munlock_vma_pages_range(vma, start, start + size);
 	}
 
+	file = get_file(vma->vm_file);
 	ret = do_mmap_pgoff(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate);
+	fput(file);
 out:
 	up_write(&mm->mmap_sem);
 	if (populate)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

