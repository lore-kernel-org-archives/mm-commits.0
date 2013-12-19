From: akpm@linux-foundation.org
Subject: + fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
 added to -mm tree
Date: Thu, 19 Dec 2013 13:56:45 -0800
Message-ID: <52b36b9d.ztC9ZAP3aSVYah2W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3LSV4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 16:56:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: + fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 13:56:45 -0800


The patch titled
     Subject: fs/proc/page.c: add PageAnon check to surely detect thp
has been added to the -mm tree.  Its filename is
     fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: fs/proc/page.c: add PageAnon check to surely detect thp

stable_page_flags() checks !PageHuge && PageTransCompound && PageLRU to
know that a specified page is thp or not.  But sometimes it's not enough
and we fail to detect thp when the thp is on pagevec.  This happens only
for a few seconds after LRU list operations, but it makes it difficult to
control our applications depending on this flag.

So this patch adds another check PageAnon to detect thps on pagevec.  It
might not give the future extensibility for thp pagecache, but it's OK at
least for now.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/proc/page.c~fs-proc-pagec-add-pageanon-check-to-surely-detect-thp fs/proc/page.c
--- a/fs/proc/page.c~fs-proc-pagec-add-pageanon-check-to-surely-detect-thp
+++ a/fs/proc/page.c
@@ -118,10 +118,12 @@ u64 stable_page_flags(struct page *page)
 	/*
 	 * PageTransCompound can be true for non-huge compound pages (slab
 	 * pages or pages allocated by drivers with __GFP_COMP) because it
-	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
-	 * sure a given page is a thp, not a non-huge compound page.
+	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
+	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
+	else if (PageTransCompound(page) &&
+		 (PageLRU(compound_trans_head(page)) ||
+		  PageAnon(compound_trans_head(page))))
 		u |= 1 << KPF_THP;
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-hwpoison-add-to-hwpoison_inject.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
fs-proc-pagec-add-pageanon-check-to-surely-detect-thp.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

