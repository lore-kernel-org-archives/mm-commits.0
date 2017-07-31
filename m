From: akpm@linux-foundation.org
Subject: + mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch added to -mm tree
Date: Mon, 31 Jul 2017 16:14:06 -0700
Message-ID: <597fb9be.J3wrldg/sXdmaHvd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdGaXOH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jul 2017 19:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, dave.hansen@intel.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-enable-thp-migration-in-generic-path-fix-fix
has been added to the -mm tree.  Its filename is
     mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-enable-thp-migration-in-generic-path-fix-fix

fix x86_64 allnoconfig warning

mm/page_vma_mapped.c: In function 'page_vma_mapped_walk':
mm/page_vma_mapped.c:154:18: warning: unused variable 'entry' [-Wunused-variable

Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path-fix-fix include/linux/swapops.h
--- a/include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path-fix-fix
+++ a/include/linux/swapops.h
@@ -149,7 +149,11 @@ static inline int is_migration_entry(swp
 {
 	return 0;
 }
-#define migration_entry_to_page(swp) NULL
+static inline struct page *migration_entry_to_page(swp_entry_t entry)
+{
+	return NULL;
+}
+
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 					spinlock_t *ptl) { }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
fortify-use-warn-instead-of-bug-for-now-fix.patch
swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

