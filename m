From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch added to
 -mm tree
Date: Tue, 07 Jul 2020 12:17:10 -0700
Message-ID: <20200707191710.QWjRgOH4q%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgGGTRM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:17:12 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com, josef@toxicpanda.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, will.deacon@arm.com, willy@infradead.org, xuyu@linux.alibaba.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/memory.c: avoid access flag update TLB flush for retried page fault
has been added to the -mm tree.  Its filename is
     mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/memory.c: avoid access flag update TLB flush for retried page fault

Recently we found regression when running will_it_scale/page_fault3 test
on ARM64.  Over 70% down for the multi processes cases and over 20% down
for the multi threads cases.  It turns out the regression is caused by
commit 89b15332af7c0 ("mm: drop mmap_sem before calling
balance_dirty_pages() in write fault").

The test mmaps a memory size file then write to the mapping, this would
make all memory dirty and trigger dirty pages throttle, that upstream
commit would release mmap_sem then retry the page fault.  The retried page
fault would see correct PTEs installed by the first try then update access
flags and flush TLBs.  The regression is caused by the excessive TLB
flush.  It is fine on x86 since x86 doesn't need flush TLB for access flag
update.

The page fault would be retried due to:
1. Waiting for page readahead
2. Waiting for page swapped in
3. Waiting for dirty pages throttling

The first two cases don't have PTEs set up at all, so the retried page
fault would install the PTEs, so they don't reach there.  But the #3 case
usually has PTEs installed, the retried page fault would reach the access
flag update.  But it seems not necessary to update access flags for #3
since retried page fault is not real "second access", so it sounds safe to
skip access flag update for retried page fault.

With this fix the test result get back to normal.

Link: http://lkml.kernel.org/r/1594148072-91273-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Xu Yu <xuyu@linux.alibaba.com>
Debugged-by: Xu Yu <xuyu@linux.alibaba.com>
Tested-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault
+++ a/mm/memory.c
@@ -4241,8 +4241,13 @@ static vm_fault_t handle_pte_fault(struc
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		if (!pte_write(entry))
 			return do_wp_page(vmf);
-		entry = pte_mkdirty(entry);
 	}
+
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vmf->flags & FAULT_FLAG_TRIED))
+		entry = pte_mkdirty(entry); 
+	else if (vmf->flags & FAULT_FLAG_TRIED)
+		goto unlock;
+
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
 				vmf->flags & FAULT_FLAG_WRITE)) {
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch
mm-filemap-clear-idle-flag-for-writes.patch
mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch
mm-thp-remove-debug_cow-switch.patch
