From: akpm@linux-foundation.org
Subject: [merged] mm-add-rss-counters-consistency-check.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:31 -0700
Message-ID: <20120322201731.62A73A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60535 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507Ab2CVURc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:32 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so402093ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add rss counters consistency check
has been removed from the -mm tree.  Its filename was
     mm-add-rss-counters-consistency-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: add rss counters consistency check

Warn about non-zero rss counters at final mmdrop.

This check will prevent reoccurences of bugs such as that fixed in "mm:
fix rss count leakage during migration".

I didn't hide this check under CONFIG_VM_DEBUG because it rather small and
rss counters cover whole page-table management, so this is a good
invariant.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~mm-add-rss-counters-consistency-check kernel/fork.c
--- a/kernel/fork.c~mm-add-rss-counters-consistency-check
+++ a/kernel/fork.c
@@ -511,6 +511,23 @@ static struct mm_struct *mm_init(struct 
 	return NULL;
 }
 
+static void check_mm(struct mm_struct *mm)
+{
+	int i;
+
+	for (i = 0; i < NR_MM_COUNTERS; i++) {
+		long x = atomic_long_read(&mm->rss_stat.count[i]);
+
+		if (unlikely(x))
+			printk(KERN_ALERT "BUG: Bad rss-counter state "
+					  "mm:%p idx:%d val:%ld\n", mm, i, x);
+	}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	VM_BUG_ON(mm->pmd_huge_pte);
+#endif
+}
+
 /*
  * Allocate and initialize an mm_struct.
  */
@@ -538,9 +555,7 @@ void __mmdrop(struct mm_struct *mm)
 	mm_free_pgd(mm);
 	destroy_context(mm);
 	mmu_notifier_mm_destroy(mm);
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	VM_BUG_ON(mm->pmd_huge_pte);
-#endif
+	check_mm(mm);
 	free_mm(mm);
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch

