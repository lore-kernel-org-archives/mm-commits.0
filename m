From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch removed from -mm tree
Date: Tue, 12 Aug 2014 13:35:16 -0700
Message-ID: <53ea7a84.YO4PsFp9QkZ5DL4l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:44416 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaHLUfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:35:17 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2687052pab.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:35:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remap_file_pages: initialize populate before usage
has been removed from the -mm tree.  Its filename was
     mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch

This patch was dropped because it was folded into mm-replace-remap_file_pages-syscall-with-emulation.patch

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: remap_file_pages: initialize populate before usage

'populate' wasn't initialized before being used in error paths,
causing panics when mm_populate() would get called with invalid
values.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix-2 mm/mmap.c
--- a/mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix-2
+++ a/mm/mmap.c
@@ -2614,7 +2614,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long populate;
+	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

