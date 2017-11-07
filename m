From: akpm@linux-foundation.org
Subject: +
 mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr.patch added to -mm tree
Date: Mon, 06 Nov 2017 16:09:39 -0800
Message-ID: <5a00f9c3.T5g1QU+rByip7TZb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933395AbdKGAJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2017 19:09:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, fweisbec@gmail.com, mingo@elte.hu, peterz@infradead.org, vbabka@suse.cz, yang.s@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not rely on preempt_count in print_vma_addr
has been added to the -mm tree.  Its filename is
     mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: do not rely on preempt_count in print_vma_addr

The preempt count check on print_vma_addr has been added by e8bff74afbdb
("x86: fix "BUG: sleeping function called from invalid context" in
print_vma_addr()") and it relied on the elevated preempt count from
preempt_conditional_sti because preempt_count check doesn't work on non
preemptive kernels by default.  The code has evolved though and
d99e1bd175f4 ("x86/entry/traps: Refactor preemption and interrupt flag
handling") has replaced preempt_conditional_sti by an explicit
preempt_disable which is noop on !PREEMPT so the check in print_vma_addr
is broken.

Fix the issue by using trylock on mmap_sem rather than chacking the
preempt count.  The allocation we are relying on has to be GFP_NOWAIT as
well.  There is a chance that we won't dump the vma state if the lock is
contended or the memory short but this is acceptable outcome and much less
fragile than the not working preemption check or tricks around it.

Link: http://lkml.kernel.org/r/20171106134031.g6dbelg55mrbyc6i@dhcp22.suse.cz
Fixes: d99e1bd175f4 ("x86/entry/traps: Refactor preemption and interrupt flag handling")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr mm/memory.c
--- a/mm/memory.c~mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr
+++ a/mm/memory.c
@@ -4485,17 +4485,15 @@ void print_vma_addr(char *prefix, unsign
 	struct vm_area_struct *vma;
 
 	/*
-	 * Do not print if we are in atomic
-	 * contexts (in exception stacks, etc.):
+	 * we might be running from an atomic context so we cannot sleep
 	 */
-	if (preempt_count())
+	if (!down_read_trylock(&mm->mmap_sem))
 		return;
 
-	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, ip);
 	if (vma && vma->vm_file) {
 		struct file *f = vma->vm_file;
-		char *buf = (char *)__get_free_page(GFP_KERNEL);
+		char *buf = (char *)__get_free_page(GFP_NOWAIT);
 		if (buf) {
 			char *p;
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
mm-distinguish-cma-and-movable-isolation-in-has_unmovable_pages.patch
mm-page_alloc-fail-has_unmovable_pages-when-seeing-reserved-pages.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-arch-remove-empty_bad_page.patch
mm-sparse-do-not-swamp-log-with-huge-vmemmap-allocation-failures.patch
mm-do-not-rely-on-preempt_count-in-print_vma_addr-was-re-mm-use-in_atomic-in-print_vma_addr.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch

