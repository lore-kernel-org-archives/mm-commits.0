From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch added
 to -mm tree
Date: Fri, 27 Feb 2015 13:26:55 -0800
Message-ID: <54f0e11f.q1XFlrCq620ixwJk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbbB0V04 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:26:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, lcapitulino@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: close race when setting PageTail for gigantic pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: close race when setting PageTail for gigantic pages

Now that gigantic pages are dynamically allocatable, care must be taken to
ensure that p->first_page is valid before setting PageTail.

If this isn't done, then it is possible to race and have compound_head()
return NULL.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages
+++ a/mm/hugetlb.c
@@ -917,7 +917,6 @@ static void prep_compound_gigantic_page(
 	__SetPageHead(page);
 	__ClearPageReserved(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
-		__SetPageTail(p);
 		/*
 		 * For gigantic hugepages allocated through bootmem at
 		 * boot, it's safer to be consistent with the not-gigantic
@@ -933,6 +932,9 @@ static void prep_compound_gigantic_page(
 		__ClearPageReserved(p);
 		set_page_count(p, 0);
 		p->first_page = page;
+		/* Make sure p->first_page is always valid for PageTail() */
+		smp_wmb();
+		__SetPageTail(p);
 	}
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-page_alloc-revert-inadvertent-__gfp_fs-retry-behavior-change.patch
mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-utilc-add-kstrimdup.patch

