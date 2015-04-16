From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:53:05 -0700
Message-ID: <552fe8f1.BAyYq0r/cf1hJ1DT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, kirill@shutemov.name, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: also print a_ops->readpage in print_bad_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/memory: also print a_ops->readpage in print_bad_pte()

A lot of filesystems use generic_file_mmap() and filemap_fault(),
f_op->mmap and vm_ops->fault aren't enough to identify filesystem.

This prints file name, vm_ops->fault, f_op->mmap and a_ops->readpage
(which is almost always implemented and filesystem-specific).

Example:

[   23.676410] BUG: Bad page map in process sh  pte:1b7e6025 pmd:19bbd067
[   23.676887] page:ffffea00006df980 count:4 mapcount:1 mapping:ffff8800196426c0 index:0x97
[   23.677481] flags: 0x10000000000000c(referenced|uptodate)
[   23.677896] page dumped because: bad pte
[   23.678205] addr:00007f52fcb17000 vm_flags:00000075 anon_vma:          (null) mapping:ffff8800196426c0 index:97
[   23.678922] file:libc-2.19.so fault:filemap_fault mmap:generic_file_readonly_mmap readpage:v9fs_vfs_readpage

[akpm@linux-foundation.org: use pr_alert, per Kirill]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-memory-print-also-a_ops-readpage-in-print_bad_pte mm/memory.c
--- a/mm/memory.c~mm-memory-print-also-a_ops-readpage-in-print_bad_pte
+++ a/mm/memory.c
@@ -690,12 +690,11 @@ static void print_bad_pte(struct vm_area
 	/*
 	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
 	 */
-	if (vma->vm_ops)
-		printk(KERN_ALERT "vma->vm_ops->fault: %pSR\n",
-		       vma->vm_ops->fault);
-	if (vma->vm_file)
-		printk(KERN_ALERT "vma->vm_file->f_op->mmap: %pSR\n",
-		       vma->vm_file->f_op->mmap);
+	pr_alert("file:%pD fault:%pf mmap:%pf readpage:%pf\n",
+		 vma->vm_file,
+		 vma->vm_ops ? vma->vm_ops->fault : NULL,
+		 vma->vm_file ? vma->vm_file->f_op->mmap : NULL,
+		 mapping ? mapping->a_ops->readpage : NULL);
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

origin.patch
mm-rcu-protected-get_mm_exe_file.patch
mm-rcu-protected-get_mm_exe_file-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
linux-next.patch
prctl-avoid-using-mmap_sem-for-exe_file-serialization.patch

