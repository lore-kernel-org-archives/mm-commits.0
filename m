From: akpm@linux-foundation.org
Subject: +
 mm-move-mremap-from-file_operations-to-vm_operations_struct-fix.patch added to -mm tree
Date: Thu, 16 Jul 2015 16:25:11 -0700
Message-ID: <55a83d57.XULewgAP3ThuHlLp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbbGPXZM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jul 2015 19:25:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-move-mremap-from-file_operations-to-vm_operations_struct-fix
has been added to the -mm tree.  Its filename is
     mm-move-mremap-from-file_operations-to-vm_operations_struct-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-mremap-from-file_operations-to-vm_operations_struct-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-mremap-from-file_operations-to-vm_operations_struct-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject:  mm-move-mremap-from-file_operations-to-vm_operations_struct-fix

fs/aio.c can't be compiled if CONFIG_MMU=n, filemap_page_mkwrite()
is not defined in this case. Add yet another "must not be called"
helper into nommu.c to make the linker happy.

I still think this is pointless, afaics sys_io_setup() simply can't
succeed if CONFIG_MMU=n. Instead we should make CONFIG_AIO depend
on CONFIG_MMU.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/nommu.c~mm-move-mremap-from-file_operations-to-vm_operations_struct-fix mm/nommu.c
--- a/mm/nommu.c~mm-move-mremap-from-file_operations-to-vm_operations_struct-fix
+++ a/mm/nommu.c
@@ -1935,6 +1935,12 @@ void filemap_map_pages(struct vm_area_st
 }
 EXPORT_SYMBOL(filemap_map_pages);
 
+int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	BUG();
+	return 0;
+}
+
 static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long addr, void *buf, int len, int write)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mm-cleaning-per-architecture-mm-hook-header-files.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct-fix.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
linux-next.patch

