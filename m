From: akpm@linux-foundation.org
Subject: [merged] mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:11:54 -0700
Message-ID: <55ef24ea.dPVoS/xb0/CRL/HZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbIHSLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, hughd@google.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: don't leak new_vma if f_op->mremap() fails
has been removed from the -mm tree.  Its filename was
     mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mremap: don't leak new_vma if f_op->mremap() fails

move_vma() can't just return if f_op->mremap() fails, we should unmap the
new vma like we do if move_page_tables() fails.  To avoid the code
duplication this patch moves the "move entries back" under the new "if
(err)" branch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN mm/mremap.c~mremap-dont-leak-new_vma-if-f_op-mremap-fails mm/mremap.c
--- a/mm/mremap.c~mremap-dont-leak-new_vma-if-f_op-mremap-fails
+++ a/mm/mremap.c
@@ -276,6 +276,12 @@ static unsigned long move_vma(struct vm_
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len,
 				     need_rmap_locks);
 	if (moved_len < old_len) {
+		err = -ENOMEM;
+	} else if (vma->vm_file && vma->vm_file->f_op->mremap) {
+		err = vma->vm_file->f_op->mremap(vma->vm_file, new_vma);
+	}
+
+	if (unlikely(err)) {
 		/*
 		 * On error, move entries back from new area to old,
 		 * which will succeed since page tables still there,
@@ -286,16 +292,8 @@ static unsigned long move_vma(struct vm_
 		vma = new_vma;
 		old_len = new_len;
 		old_addr = new_addr;
-		new_addr = -ENOMEM;
+		new_addr = err;
 	} else {
-		if (vma->vm_file && vma->vm_file->f_op->mremap) {
-			err = vma->vm_file->f_op->mremap(vma->vm_file, new_vma);
-			if (err < 0) {
-				move_page_tables(new_vma, new_addr, vma,
-						 old_addr, moved_len, true);
-				return err;
-			}
-		}
 		arch_remap(mm, old_addr, old_addr + old_len,
 			   new_addr, new_addr + new_len);
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

