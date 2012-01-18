From: akpm@linux-foundation.org
Subject: + mm-add-rss-counters-consistency-check.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:21:59 -0800
Message-ID: <20120118232200.8D37E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62738 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2ARXWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:22:02 -0500
Received: by eaaf1 with SMTP id f1so109757eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:22:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: mm: add rss counters consistency check
has been added to the -mm tree.  Its filename is
     mm-add-rss-counters-consistency-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -514,6 +514,23 @@ static struct mm_struct *mm_init(struct 
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
@@ -541,9 +558,7 @@ void __mmdrop(struct mm_struct *mm)
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
Subject: Subject: mm: add rss counters consistency check

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-rss-count-leakage-during-migration.patch
mm-add-rss-counters-consistency-check.patch
mm-postpone-migrated-page-mapping-reset.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

