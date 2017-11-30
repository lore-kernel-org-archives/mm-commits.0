From: akpm@linux-foundation.org
Subject: [patch 02/28] mm, oom_reaper: gather each vma to prevent leaking
 TLB entry
Date: Wed, 29 Nov 2017 16:09:58 -0800
Message-ID: <5a1f4c56.p/nAHhT9UFhoNKtH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753506AbdK3AKA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, wangnan0@huawei.com, aarcange@redhat.com, guro@fb.com, khlebnikov@yandex-team.ru, liubo95@huawei.com, mhocko@suse.com, minchan@kernel.org, mingo@kernel.org, rientjes@google.com, stable@vger.kernel.org, will.deacon@arm.com

From: Wang Nan <wangnan0@huawei.com>
Subject: mm, oom_reaper: gather each vma to prevent leaking TLB entry

tlb_gather_mmu(&tlb, mm, 0, -1) means gathering the whole virtual memory
space.  In this case, tlb->fullmm is true.  Some archs like arm64 doesn't
flush TLB when tlb->fullmm is true:

  commit 5a7862e83000 ("arm64: tlbflush: avoid flushing when fullmm == 1").

Which causes leaking of tlb entries.

Will clarifies his patch:

: Basically, we tag each address space with an ASID (PCID on x86) which
: is resident in the TLB. This means we can elide TLB invalidation when
: pulling down a full mm because we won't ever assign that ASID to another mm
: without doing TLB invalidation elsewhere (which actually just nukes the
: whole TLB).
:
: I think that means that we could potentially not fault on a kernel uaccess,
: because we could hit in the TLB.

There could be a window between complete_signal() sending IPI to other
cores and all threads sharing this mm are really kicked off from cores. 
In this window, the oom reaper may calls tlb_flush_mmu_tlbonly() to flush
TLB then frees pages.  However, due to the above problem, the TLB entries
are not really flushed on arm64.  Other threads are possible to access
these pages through TLB entries.  Moreover, a copy_to_user() can also
write to these pages without generating page fault, causes use-after-free
bugs.

This patch gathers each vma instead of gathering full vm space.  In this
case tlb->fullmm is not true.  The behavior of oom reaper become similar
to munmapping before do_exit, which should be safe for all archs.

Link: http://lkml.kernel.org/r/20171107095453.179940-1-wangnan0@huawei.com
Fixes: aac453635549 ("mm, oom: introduce oom reaper")
Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Bob Liu <liubo95@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-gather-each-vma-to-prevent-leaking-tlb-entry mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-gather-each-vma-to-prevent-leaking-tlb-entry
+++ a/mm/oom_kill.c
@@ -550,7 +550,6 @@ static bool __oom_reap_task_mm(struct ta
 	 */
 	set_bit(MMF_UNSTABLE, &mm->flags);
 
-	tlb_gather_mmu(&tlb, mm, 0, -1);
 	for (vma = mm->mmap ; vma; vma = vma->vm_next) {
 		if (!can_madv_dontneed_vma(vma))
 			continue;
@@ -565,11 +564,13 @@ static bool __oom_reap_task_mm(struct ta
 		 * we do not want to block exit_mmap by keeping mm ref
 		 * count elevated without a good reason.
 		 */
-		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED))
+		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
+			tlb_gather_mmu(&tlb, mm, vma->vm_start, vma->vm_end);
 			unmap_page_range(&tlb, vma, vma->vm_start, vma->vm_end,
 					 NULL);
+			tlb_finish_mmu(&tlb, vma->vm_start, vma->vm_end);
+		}
 	}
-	tlb_finish_mmu(&tlb, 0, -1);
 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
 			task_pid_nr(tsk), tsk->comm,
 			K(get_mm_counter(mm, MM_ANONPAGES)),
_
