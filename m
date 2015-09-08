From: akpm@linux-foundation.org
Subject: [merged] mremap-dont-do-mm_populatenew_addr-on-failure.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:12:00 -0700
Message-ID: <55ef24f0.NkiO3lPMLjTJCw3I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbIHSMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:12:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, hughd@google.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: don't do mm_populate(new_addr) on failure
has been removed from the -mm tree.  Its filename was
     mremap-dont-do-mm_populatenew_addr-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mremap: don't do mm_populate(new_addr) on failure

move_vma() sets *locked even if move_page_tables() or ->mremap() fails,
change sys_mremap() to check "ret & ~PAGE_MASK".

I think we should simply remove the VM_LOCKED code in move_vma(), that is
why this patch doesn't change move_vma().  But this needs more cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mremap.c~mremap-dont-do-mm_populatenew_addr-on-failure mm/mremap.c
--- a/mm/mremap.c~mremap-dont-do-mm_populatenew_addr-on-failure
+++ a/mm/mremap.c
@@ -578,8 +578,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		ret = move_vma(vma, addr, old_len, new_len, new_addr, &locked);
 	}
 out:
-	if (ret & ~PAGE_MASK)
+	if (ret & ~PAGE_MASK) {
 		vm_unacct_memory(charged);
+		locked = 0;
+	}
 	up_write(&current->mm->mmap_sem);
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

