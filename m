From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-shmem-__do_fault-requires-vm_fault_nopage.patch removed from
 -mm tree
Date: Fri, 10 Mar 2017 13:42:33 -0800
Message-ID: <58c31dc9.riPpqPvRrbKRzrk2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755050AbdCJVmf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:42:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dvyukov@google.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: __do_fault requires VM_FAULT_NOPAGE
has been removed from the -mm tree.  Its filename was
     userfaultfd-shmem-__do_fault-requires-vm_fault_nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: shmem: __do_fault requires VM_FAULT_NOPAGE

__do_fault assumes vmf->page has been initialized and is valid if
VM_FAULT_NOPAGE is not returned by vma->vm_ops->fault(vma, vmf).

handle_userfault() in turn should return VM_FAULT_NOPAGE if it doesn't
return VM_FAULT_SIGBUS or VM_FAULT_RETRY (the other two possibilities).

This VM_FAULT_NOPAGE case is only invoked when signal are pending and it
didn't matter for anonymous memory before.  It only started to matter
since shmem was introduced.  hugetlbfs also takes a different path and
doesn't exercise __do_fault.

Link: http://lkml.kernel.org/r/20170228154201.GH5816@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-shmem-__do_fault-requires-vm_fault_nopage fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-shmem-__do_fault-requires-vm_fault_nopage
+++ a/fs/userfaultfd.c
@@ -490,7 +490,7 @@ int handle_userfault(struct vm_fault *vm
 			 * in such case.
 			 */
 			down_read(&mm->mmap_sem);
-			ret = 0;
+			ret = VM_FAULT_NOPAGE;
 		}
 	}
 
_

Patches currently in -mm which might be from aarcange@redhat.com are


