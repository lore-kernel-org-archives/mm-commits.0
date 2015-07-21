From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-move-mremap-from-file_operations-to-vm_operations_struct-fix.patch
 removed from -mm tree
Date: Tue, 21 Jul 2015 12:56:27 -0700
Message-ID: <55aea3eb.evhjj8ocqFgLX8Ek%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbGUT42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 15:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-move-mremap-from-file_operations-to-vm_operations_struct-fix
has been removed from the -mm tree.  Its filename was
     mm-move-mremap-from-file_operations-to-vm_operations_struct-fix.patch

This patch was dropped because an updated version will be merged

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

signal-fix-information-leak-in-copy_siginfo_from_user32.patch
signal-fix-information-leak-in-copy_siginfo_to_user.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct-v3.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
linux-next.patch

