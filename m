From: akpm@linux-foundation.org
Subject: [patch 065/127] fs/proc/task_mmu.c: make the task_mmu
 walk_page_range() limit in clear_refs_write() obvious
Date: Fri, 07 Oct 2016 17:00:06 -0700
Message-ID: <57f83706.0Wkqp0mF+BBD3s3C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39211 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756775AbcJHAAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, james.morse@arm.com, n-horiguchi@ah.jp.nec.com

From: James Morse <james.morse@arm.com>
Subject: fs/proc/task_mmu.c: make the task_mmu walk_page_range() limit in clear_refs_write() obvious

Trying to walk all of virtual memory requires architecture specific
knowledge.  On x86_64, addresses must be sign extended from bit 48,
whereas on arm64 the top VA_BITS of address space have their own set of
page tables.

clear_refs_write() calls walk_page_range() on the range 0 to ~0UL, it
provides a test_walk() callback that only expects to be walking over VMAs.
Currently walk_pmd_range() will skip memory regions that don't have a
VMA, reporting them as a hole.

As this call only expects to walk user address space, make it walk 0 to
'highest_vm_end'.

Link: http://lkml.kernel.org/r/1472655792-22439-1-git-send-email-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious
+++ a/fs/proc/task_mmu.c
@@ -1070,7 +1070,7 @@ static ssize_t clear_refs_write(struct f
 			}
 			mmu_notifier_invalidate_range_start(mm, 0, -1);
 		}
-		walk_page_range(0, ~0UL, &clear_refs_walk);
+		walk_page_range(0, mm->highest_vm_end, &clear_refs_walk);
 		if (type == CLEAR_REFS_SOFT_DIRTY)
 			mmu_notifier_invalidate_range_end(mm, 0, -1);
 		flush_tlb_mm(mm);
_
