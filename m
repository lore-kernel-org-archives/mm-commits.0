Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD181C4743C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835AD61360
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFWErt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhFWErs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 00:47:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15CD960FDA;
        Wed, 23 Jun 2021 04:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624423531;
        bh=93s3rJ1E6PLc6s6iCQDrd/A8ib5qXdRSj7lROMT2sdg=;
        h=Date:From:To:Subject:From;
        b=TgAqtPz+4O9/SI4RLNtMBNTw+b3dnbFD4e4LTwdpVttsgVA2WRA13B3HymE6GNFZX
         92poDCs6I+woeKSPXfmUgIlqCArb4Pg+ZBxzunL16I1QMa55k08PuvPFEykZCzZHm/
         mYf6YGMRzkcFSGnGz9/7f9e6b92tsYO0Uy+Ip+WM=
Date:   Tue, 22 Jun 2021 21:45:30 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, jack@suse.cz, jannh@google.com,
        jhubbard@nvidia.com, kirill@shutemov.name, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        willy@infradead.org, youquan.song@intel.com
Subject:  + hugetlb-remove-prep_compound_huge_page-cleanup.patch
 added to -mm tree
Message-ID: <20210623044530.hhRLf-TWa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove prep_compound_huge_page cleanup
has been added to the -mm tree.  Its filename is
     hugetlb-remove-prep_compound_huge_page-cleanup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-remove-prep_compound_huge_page-cleanup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-remove-prep_compound_huge_page-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: remove prep_compound_huge_page cleanup

Patch series "Fix prep_compound_gigantic_page ref count adjustment".

These patches address the possible race between
prep_compound_gigantic_page and __page_cache_add_speculative as described
by Jann Horn in [1].

The first patch simply removes the unnecessary/obsolete helper routine
prep_compound_huge_page to make the actual fix a little simpler.

The second patch is the actual fix and has a detailed explanation in the
commit message.

This potential issue has existed for almost 10 years and I am unaware of
anyone actually hitting the race.  I did not cc stable, but would be happy
to squash the patches and send to stable if anyone thinks that is a good
idea.

[1] https://lore.kernel.org/linux-mm/CAG48ez23q0Jy9cuVnwAe7t_fdhMk2S7N5Hdi-GLcCeq5bsfLxw@mail.gmail.com/


This patch (of 2):

I could not think of a reliable way to recreate the issue for testing.
Rather, I 'simulated errors' to exercise all the error paths.

The routine prep_compound_huge_page is a simple wrapper to call either
prep_compound_gigantic_page or prep_compound_page.  However, it is only
called from gather_bootmem_prealloc which only processes gigantic pages. 
Eliminate the routine and call prep_compound_gigantic_page directly.

Link: https://lkml.kernel.org/r/20210622021423.154662-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20210622021423.154662-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Youquan Song <youquan.song@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-prep_compound_huge_page-cleanup
+++ a/mm/hugetlb.c
@@ -1320,8 +1320,6 @@ static struct page *alloc_gigantic_page(
 	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
 }
 
-static void prep_new_huge_page(struct hstate *h, struct page *page, int nid);
-static void prep_compound_gigantic_page(struct page *page, unsigned int order);
 #else /* !CONFIG_CONTIG_ALLOC */
 static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
 					int nid, nodemask_t *nodemask)
@@ -2759,16 +2757,10 @@ found:
 	return 1;
 }
 
-static void __init prep_compound_huge_page(struct page *page,
-		unsigned int order)
-{
-	if (unlikely(order > (MAX_ORDER - 1)))
-		prep_compound_gigantic_page(page, order);
-	else
-		prep_compound_page(page, order);
-}
-
-/* Put bootmem huge pages into the standard lists after mem_map is up */
+/*
+ * Put bootmem huge pages into the standard lists after mem_map is up.
+ * Note: This only applies to gigantic (order > MAX_ORDER) pages.
+ */
 static void __init gather_bootmem_prealloc(void)
 {
 	struct huge_bootmem_page *m;
@@ -2777,20 +2769,19 @@ static void __init gather_bootmem_preall
 		struct page *page = virt_to_page(m);
 		struct hstate *h = m->hstate;
 
+		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(page_count(page) != 1);
-		prep_compound_huge_page(page, huge_page_order(h));
+		prep_compound_gigantic_page(page, huge_page_order(h));
 		WARN_ON(PageReserved(page));
 		prep_new_huge_page(h, page, page_to_nid(page));
 		put_page(page); /* free it into the hugepage allocator */
 
 		/*
-		 * If we had gigantic hugepages allocated at boot time, we need
-		 * to restore the 'stolen' pages to totalram_pages in order to
-		 * fix confusing memory reports from free(1) and another
-		 * side-effects, like CommitLimit going negative.
+		 * We need to restore the 'stolen' pages to totalram_pages
+		 * in order to fix confusing memory reports from free(1) and
+		 * other side-effects, like CommitLimit going negative.
 		 */
-		if (hstate_is_gigantic(h))
-			adjust_managed_page_count(page, pages_per_huge_page(h));
+		adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
hugetlb-remove-prep_compound_huge_page-cleanup.patch
hugetlb-address-ref-count-racing-in-prep_compound_gigantic_page.patch

