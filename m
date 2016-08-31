From: akpm@linux-foundation.org
Subject: +
 mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious.patch added to -mm tree
Date: Wed, 31 Aug 2016 13:28:11 -0700
Message-ID: <57c73ddb.ZfoBfL09ZNxrOfFX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48989 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932140AbcHaU2M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 16:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: make the task_mmu walk_page_range() limit in clear_refs_write() obvious
has been added to the -mm tree.  Its filename is
     mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious
+++ a/fs/proc/task_mmu.c
@@ -1068,7 +1068,7 @@ static ssize_t clear_refs_write(struct f
 			}
 			mmu_notifier_invalidate_range_start(mm, 0, -1);
 		}
-		walk_page_range(0, ~0UL, &clear_refs_walk);
+		walk_page_range(0, mm->highest_vm_end, &clear_refs_walk);
 		if (type == CLEAR_REFS_SOFT_DIRTY)
 			mmu_notifier_invalidate_range_end(mm, 0, -1);
 		flush_tlb_mm(mm);
_

Patches currently in -mm which might be from james.morse@arm.com are

mm-pagewalk-fix-the-comment-for-test_walk.patch
mm-proc-make-the-task_mmu-walk_page_range-limit-in-clear_refs_write-obvious.patch

