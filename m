From: akpm@linux-foundation.org
Subject: [obsolete] do_shared_fault-check-that-mmap_sem-is-held.patch
 removed from -mm tree
Date: Tue, 05 Apr 2016 17:06:45 -0700
Message-ID: <57045315.jPVVDz/0uQ89avEu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcDFAGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 20:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, dave.hansen@linux.intel.com, kirill@shutemov.name, lliubbo@gmail.com, matthew.r.wilcox@intel.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: do_shared_fault(): check that mmap_sem is held
has been removed from the -mm tree.  Its filename was
     do_shared_fault-check-that-mmap_sem-is-held.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: do_shared_fault(): check that mmap_sem is held

mmap_sem() is required to protect the vma, which holds ->vm_file, which
pins fault_page->mapping.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory.c~do_shared_fault-check-that-mmap_sem-is-held mm/memory.c
--- a/mm/memory.c~do_shared_fault-check-that-mmap_sem-is-held
+++ a/mm/memory.c
@@ -3083,6 +3083,8 @@ static int do_shared_fault(struct mm_str
 	int dirtied = 0;
 	int ret, tmp;
 
+	WARN_ON_ONCE(!rwsem_is_locked(&mm->mmap_sem));
+
 	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

