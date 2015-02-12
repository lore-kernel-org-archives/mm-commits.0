From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-pagemap-limit-scan-to-virtual-region-being-asked.patch removed from -mm
 tree
Date: Thu, 12 Feb 2015 12:33:35 -0800
Message-ID: <54dd0e1f.YV5lgAUPl0zrM7C8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbBLUdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 15:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shashim@codeaurora.org, gorcunov@openvz.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagemap_read: limit scan to virtual region being asked
has been removed from the -mm tree.  Its filename was
     mm-pagemap-limit-scan-to-virtual-region-being-asked.patch

This patch was dropped because it is obsolete

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
@@ -1259,7 +1259,9 @@ static ssize_t pagemap_read(struct file
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

origin.patch

