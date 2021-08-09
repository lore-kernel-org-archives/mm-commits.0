Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1D4C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0045160C51
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhHITdC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhHITdA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 15:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FE060F6F;
        Mon,  9 Aug 2021 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628537559;
        bh=IA25x6xIDKgeBfvmNaiJvDZng9hEZxU8meirXug4O9w=;
        h=Date:From:To:Subject:From;
        b=J9eWnvsPoa7dMhLJ1WTviMpcRMScR6clklBQeB8yjM0lfjVUT+ukW8yQ2sclHoFg6
         pPIXgRcYflvlMkXPUIBvSnVBQWqQvt3E+3NelhavMW/XkzNEVPd31lAnL7eORlc/26
         Q3yLzutzU9wLIs42neMUvAaD6MlxzuPtvHq2mQmY=
Date:   Mon, 09 Aug 2021 12:32:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        almasrymina@google.com, mike.kravetz@oracle.com
Subject:  +
 hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch added
 to -mm tree
Message-ID: <20210809193239.EpVyR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: before freeing hugetlb page set dtor to appropriate value
has been added to the -mm tree.  Its filename is
     hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch

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
Subject: hugetlb: before freeing hugetlb page set dtor to appropriate value

When removing a hugetlb page from the pool the ref count is set to one (as
the free page has no ref count) and compound page destructor is set to
NULL_COMPOUND_DTOR.  Since a subsequent call to free the hugetlb page will
call __free_pages for non-gigantic pages and free_gigantic_page for
gigantic pages the destructor is not used.

However, consider the following race with code taking a speculative
reference on the page:

Thread 0				Thread 1
--------				--------
remove_hugetlb_page
  set_page_refcounted(page);
  set_compound_page_dtor(page,
           NULL_COMPOUND_DTOR);
					get_page_unless_zero(page)
__update_and_free_page
  __free_pages(page,
           huge_page_order(h));

		/* Note that __free_pages() will simply drop
		   the reference to the page. */

					put_page(page)
					  __put_compound_page()
					    destroy_compound_page
					      NULL_COMPOUND_DTOR
						BUG: kernel NULL pointer
						dereference, address:
						0000000000000000

To address this race, set the dtor to the normal compound page dtor for
non-gigantic pages.  The dtor for gigantic pages does not matter as
gigantic pages are changed from a compound page to 'just a group of pages'
before freeing.  Hence, the destructor is not used.

Link: https://lkml.kernel.org/r/20210809184832.18342-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value
+++ a/mm/hugetlb.c
@@ -1370,8 +1370,28 @@ static void remove_hugetlb_page(struct h
 		h->surplus_huge_pages_node[nid]--;
 	}
 
+	/*
+	 * Very subtle
+	 *
+	 * For non-gigantic pages set the destructor to the normal compound
+	 * page dtor.  This is needed in case someone takes an additional
+	 * temporary ref to the page, and freeing is delayed until they drop
+	 * their reference.
+	 *
+	 * For gigantic pages set the destructor to the null dtor.  This
+	 * destructor will never be called.  Before freeing the gigantic
+	 * page destroy_compound_gigantic_page will turn the compound page
+	 * into a simple group of pages.  After this the destructor does not
+	 * apply.
+	 *
+	 * This handles the case where more than one ref is held when and
+	 * after update_and_free_page is called.
+	 */
 	set_page_refcounted(page);
-	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
+	if (hstate_is_gigantic(h))
+		set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
+	else
+		set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[nid]--;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch

