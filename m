Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1BBC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F9C61131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350457AbhICVBJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350319AbhICVBG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1E226112E;
        Fri,  3 Sep 2021 21:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702805;
        bh=0qyrPR/dUEHeCDSMj6YR+ndNrU2Sz+kbRYMhk0FAFRM=;
        h=Date:From:To:Subject:From;
        b=v842vkx37ttGFFCYTh6Ncko6fzjPI02RwM1k4qvVWuXCszQF0uDc6B3e5iPZpj8MH
         dJqejGZ+JaD6yO3xid5SBZxQGWVEY7ixRqUTo4WVKHJhedhyqd2aEyhozvJoOJgOGV
         M+RLvHKumY2Mw76hcyMZUnmznIQzNO9DTCLxT3W0=
Date:   Fri, 03 Sep 2021 14:00:05 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, david@redhat.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, osalvador@suse.de,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  [merged]
 hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
 removed from -mm tree
Message-ID: <20210903210005.-yLc7ShaO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: simplify prep_compound_gigantic_page ref count racing code
has been removed from the -mm tree.  Its filename was
     hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: simplify prep_compound_gigantic_page ref count racing code

Code in prep_compound_gigantic_page waits for a rcu grace period if it
notices a temporarily inflated ref count on a tail page.  This was due to
the identified potential race with speculative page cache references which
could only last for a rcu grace period.  This is overly complicated as
this situation is VERY unlikely to ever happen.  Instead, just quickly
return an error.

Also, only print a warning in prep_compound_gigantic_page instead of
multiple callers.

Link: https://lkml.kernel.org/r/20210809184832.18342-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code
+++ a/mm/hugetlb.c
@@ -1657,16 +1657,14 @@ static bool prep_compound_gigantic_page(
 		 * cache adding could take a ref on a 'to be' tail page.
 		 * We need to respect any increased ref count, and only set
 		 * the ref count to zero if count is currently 1.  If count
-		 * is not 1, we call synchronize_rcu in the hope that a rcu
-		 * grace period will cause ref count to drop and then retry.
-		 * If count is still inflated on retry we return an error and
-		 * must discard the pages.
+		 * is not 1, we return an error.  An error return indicates
+		 * the set of pages can not be converted to a gigantic page.
+		 * The caller who allocated the pages should then discard the
+		 * pages using the appropriate free interface.
 		 */
 		if (!page_ref_freeze(p, 1)) {
-			pr_info("HugeTLB unexpected inflated ref count on freshly allocated page\n");
-			synchronize_rcu();
-			if (!page_ref_freeze(p, 1))
-				goto out_error;
+			pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
+			goto out_error;
 		}
 		set_page_count(p, 0);
 		set_compound_head(p, page);
@@ -1830,7 +1828,6 @@ retry:
 				retry = true;
 				goto retry;
 			}
-			pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
 			return NULL;
 		}
 	}
@@ -2828,8 +2825,8 @@ static void __init gather_bootmem_preall
 			prep_new_huge_page(h, page, page_to_nid(page));
 			put_page(page); /* add to the hugepage allocator */
 		} else {
+			/* VERY unlikely inflated ref count on a tail page */
 			free_gigantic_page(page, huge_page_order(h));
-			pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
 		}
 
 		/*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


