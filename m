From: akpm@linux-foundation.org
Subject: + mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
 added to -mm tree
Date: Fri, 03 Apr 2015 15:12:11 -0700
Message-ID: <551f103b.kIkdY9ZbnmSLT0Nx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbDCWMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 18:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, kirill@shutemov.name, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: also print a_ops->readpage in print_bad_pte()
has been added to the -mm tree.  Its filename is
     mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-memory-print-also-a_ops-readpage-in-print_bad_pte mm/memory.c
--- a/mm/memory.c~mm-memory-print-also-a_ops-readpage-in-print_bad_pte
+++ a/mm/memory.c
@@ -690,12 +690,12 @@ static void print_bad_pte(struct vm_area
 	/*
 	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
 	 */
-	if (vma->vm_ops)
-		printk(KERN_ALERT "vma->vm_ops->fault: %pSR\n",
-		       vma->vm_ops->fault);
-	if (vma->vm_file)
-		printk(KERN_ALERT "vma->vm_file->f_op->mmap: %pSR\n",
-		       vma->vm_file->f_op->mmap);
+	printk(KERN_ALERT
+		"file:%pD fault:%pf mmap:%pf readpage:%pf\n",
+		vma->vm_file,
+		vma->vm_ops ? vma->vm_ops->fault : NULL,
+		vma->vm_file ? vma->vm_file->f_op->mmap : NULL,
+		mapping ? mapping->a_ops->readpage : NULL);
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

page_writeback-cleanup-mess-around-cancel_dirty_page.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
mm-rcu-protected-get_mm_exe_file-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
linux-next.patch
prctl-avoid-using-mmap_sem-for-exe_file-serialization.patch

