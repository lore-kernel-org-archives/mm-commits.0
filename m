From: akpm@linux-foundation.org
Subject: + mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch added to
 -mm tree
Date: Thu, 09 Jul 2015 15:26:26 -0700
Message-ID: <559ef512.v2YPhVjqPz0IoEo0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbbGIW01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:26:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, hughd@google.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: don't leak new_vma if f_op->mremap() fails
has been added to the -mm tree.  Its filename is
     mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch

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

mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
linux-next.patch

