From: akpm@linux-foundation.org
Subject: +
 mmmadvise-bugfix-of-madvise-systemcall-infinite-loop-under-special-circumstances.patch added to -mm tree
Date: Mon, 27 Nov 2017 15:29:04 -0800
Message-ID: <5a1c9fc0.8iiVA/ewr5YaaKl7%akpm__1854.62325248427$1511825349$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdK0X3G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 18:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenjie6@huawei.com, aarcange@redhat.com, cotte@de.ibm.com, dan.j.williams@intel.com, guoxuenan@huawei.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, miaoxie@huawei.com, minchan@kernel.org, riel@redhat.com, rientjes@google.com, rppt@linux.vnet.ibm.com, shli@fb.com, stable@vger.kernel.org, yi.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise.c: fix madvise() infinite loop under special circumstances
has been added to the -mm tree.  Its filename is
     mmmadvise-bugfix-of-madvise-systemcall-infinite-loop-under-special-circumstances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmmadvise-bugfix-of-madvise-systemcall-infinite-loop-under-special-circumstances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmmadvise-bugfix-of-madvise-systemcall-infinite-loop-under-special-circumstances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chenjie <chenjie6@huawei.com>
Subject: mm/madvise.c: fix madvise() infinite loop under special circumstances

MADVISE_WILLNEED has always been a noop for DAX (formerly XIP) mappings. 
Unfortunatelly madvise_willneed() doesn't communicate this information
properly to the generic madvise syscall implementation.  The calling
convention is quite subtle there.  madvise_vma() is supposed to either
return an error or update &prev otherwise the main loop will never advance
to the next vma and it will keep looping for ever without a way to get out
of the kernel.

It seems this has been broken since introduction.  Nobody has noticed
because nobody seems to be using MADVISE_WILLNEED on these DAX mappings.

[mhocko@suse.com: rewrite changelog]
Link: http://lkml.kernel.org/r/20171127115318.911-1-guoxuenan@huawei.com
Fixes: fe77ba6f4f97 ("[PATCH] xip: madvice/fadvice: execute in place")
Signed-off-by: chenjie <chenjie6@huawei.com>
Signed-off-by: guoxuenan <guoxuenan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: zhangyi (F) <yi.zhang@huawei.com>
Cc: Miao Xie <miaoxie@huawei.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/madvise.c~mmmadvise-bugfix-of-madvise-systemcall-infinite-loop-under-special-circumstances mm/madvise.c
--- a/mm/madvise.c~mmmadvise-bugfix-of-madvise-systemcall-infinite-loop-under-special-circumstances
+++ a/mm/madvise.c
@@ -276,15 +276,14 @@ static long madvise_willneed(struct vm_a
 {
 	struct file *file = vma->vm_file;
 
+	*prev = vma;
 #ifdef CONFIG_SWAP
 	if (!file) {
-		*prev = vma;
 		force_swapin_readahead(vma, start, end);
 		return 0;
 	}
 
 	if (shmem_mapping(file->f_mapping)) {
-		*prev = vma;
 		force_shm_swapin_readahead(vma, start, end,
 					file->f_mapping);
 		return 0;
@@ -299,7 +298,6 @@ static long madvise_willneed(struct vm_a
 		return 0;
 	}
 
-	*prev = vma;
 	start = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	if (end > vma->vm_end)
 		end = vma->vm_end;
_

Patches currently in -mm which might be from chenjie6@huawei.com are

mmmadvise-bugfix-of-madvise-systemcall-infinite-loop-under-special-circumstances.patch

