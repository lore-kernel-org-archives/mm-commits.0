From: akpm@linux-foundation.org
Subject: + mm-pagemap-limit-scan-to-virtual-region-being-asked.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:15:03 -0800
Message-ID: <54b5b507.pJMllnx7QrNeSiUD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbANAPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:15:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shashim@codeaurora.org, gorcunov@openvz.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagemap_read: limit scan to virtual region being asked
has been added to the -mm tree.  Its filename is
     mm-pagemap-limit-scan-to-virtual-region-being-asked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagemap-limit-scan-to-virtual-region-being-asked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagemap-limit-scan-to-virtual-region-being-asked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shiraz Hashim <shashim@codeaurora.org>
Subject: mm: pagemap_read: limit scan to virtual region being asked

pagemap_read scans through the virtual address space of a task until it
prepares 'count' pagemaps or it reaches end of task.

This presents a problem when the page walk doesn't happen for a vma with
VM_PFNMAP set.  In this case the walk is silently skipped and no pagemap
is prepared, in turn making pagemap_read scan through to task end, even
crossing beyond 'count', landing into a different vma region.  This leads
to wrong presentation of mappings for that vma.

Fix this by limiting end_vaddr to the end of the virtual address region
being scanned.

Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-pagemap-limit-scan-to-virtual-region-being-asked fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagemap-limit-scan-to-virtual-region-being-asked
+++ a/fs/proc/task_mmu.c
@@ -1254,7 +1254,9 @@ static ssize_t pagemap_read(struct file
 	src = *ppos;
 	svpfn = src / PM_ENTRY_BYTES;
 	start_vaddr = svpfn << PAGE_SHIFT;
-	end_vaddr = TASK_SIZE_OF(task);
+	end_vaddr = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
+	if ((end_vaddr > TASK_SIZE_OF(task)) || (end_vaddr < start_vaddr))
+		end_vaddr = TASK_SIZE_OF(task);
 
 	/* watch out for wraparound */
 	if (svpfn > TASK_SIZE_OF(task) >> PAGE_SHIFT)
_

Patches currently in -mm which might be from shashim@codeaurora.org are

mm-pagemap-limit-scan-to-virtual-region-being-asked.patch

