From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch removed from
 -mm tree
Date: Mon, 16 Dec 2013 12:39:20 -0800
Message-ID: <52af64f8.Eu5liRI79Pv2A2zx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3LPUjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 15:39:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, bp@alien8.de, n-horiguchi@ah.jp.nec.com

Subject: [merged] include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,bp@alien8.de,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 12:39:20 -0800


The patch titled
     Subject: include/linux/hugetlb.h: make isolate_huge_page() an inline
has been removed from the -mm tree.  Its filename was
     include-linux-hugetlbh-make-isolate_huge_page-an-inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: include/linux/hugetlb.h: make isolate_huge_page() an inline

With CONFIG_HUGETLBFS=n:

mm/migrate.c: In function `do_move_page_to_node_array':
include/linux/hugetlb.h:140:33: warning: statement with no effect [-Wunused-value]
 #define isolate_huge_page(p, l) false
                                 ^
mm/migrate.c:1170:4: note: in expansion of macro `isolate_huge_page'
    isolate_huge_page(page, &pagelist);


Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~include-linux-hugetlbh-make-isolate_huge_page-an-inline include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~include-linux-hugetlbh-make-isolate_huge_page-an-inline
+++ a/include/linux/hugetlb.h
@@ -142,7 +142,10 @@ static inline int dequeue_hwpoisoned_hug
 	return 0;
 }
 
-#define isolate_huge_page(p, l) false
+static inline bool isolate_huge_page(struct page *page, struct list_head *list)
+{
+	return false;
+}
 #define putback_active_hugepage(p)	do {} while (0)
 #define is_hugepage_active(x)	false
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-hwpoison-add-to-hwpoison_inject.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

