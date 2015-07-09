From: akpm@linux-foundation.org
Subject: + mremap-dont-do-mm_populatenew_addr-on-failure.patch added to
 -mm tree
Date: Thu, 09 Jul 2015 15:26:30 -0700
Message-ID: <559ef516.ZydYCpibiUdExo4n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbGIW0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, bcrl@kvack.org, hughd@google.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, rientjes@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: don't do mm_populate(new_addr) on failure
has been added to the -mm tree.  Its filename is
     mremap-dont-do-mm_populatenew_addr-on-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mremap-dont-do-mm_populatenew_addr-on-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mremap-dont-do-mm_populatenew_addr-on-failure.patch

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

mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
linux-next.patch

