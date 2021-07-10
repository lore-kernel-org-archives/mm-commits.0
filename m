Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED24C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA7BE613C9
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhGJAuQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 20:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhGJAuQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 20:50:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E136C61205;
        Sat, 10 Jul 2021 00:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625878051;
        bh=7GX1Xr7jPAEOO+sRHOf6w+mj1+8aQjtj7GcjvsLebUQ=;
        h=Date:From:To:Subject:From;
        b=UKvz3DORgfRsZAn3BWXgRS5Gn7q0r7dNUkLFctSiEB9vpO1r6v0Ui/1tlNTmRbRwr
         p79a9QLVXrks0+55G6HAKU+0/s88BkECefJSr+76DCeWY0mZrHFwYvl5uaEP25XbBJ
         4AgIN3+m4YekfZZf8aUThXO5ukh9vMy2b6bv0MY8=
Date:   Fri, 09 Jul 2021 17:47:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        almasrymina@google.com, mike.kravetz@oracle.com
Subject:  +
 hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
 added to -mm tree
Message-ID: <20210710004730.4V-cU%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: simplify prep_compound_gigantic_page ref count racing code
has been added to the -mm tree.  Its filename is
     hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch

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
Subject: hugetlb: simplify prep_compound_gigantic_page ref count racing code

Patch series "hugetlb: fix potential ref counting races".

When Muchun Song brought up a potential issue with hugetlb ref
counting[1], I started looking closer at the code.  hugetlbfs is the only
code with it's own specialized compound page destructor and taking special
action when ref counts drop to zero.  Potential races happen in this
unique handling of ref counts.  The following patches address these races
when creating and destroying hugetlb pages.

These potential races have likely existed since the creation of hugetlbfs.
They certainly have been around for more than 10 years.  However, I am
unaware of anyone actually hitting these races.  It is VERY unlikely than
anyone will actually hit these races, but they do exist.

I could not think of an easy (or difficult) way to force these races. 
Therefore, testing consisted of adding code to randomly increase ref
counts in strategic places.  In this way, I was able to exercise all the
race handling code paths.

[1] https://lore.kernel.org/linux-mm/CAMZfGtVMn3daKrJwZMaVOGOaJU+B4dS--x_oPmGQMD=c=QNGEg@mail.gmail.com/


This patch (of 3):

Code in prep_compound_gigantic_page waits for a rcu grace period if it
notices a temporarily inflated ref count on a tail page.  This was due to
the identified potential race with speculative page cache references which
could only last for a rcu grace period.  This is overly complicated as
this situation is VERY unlikely to ever happen.  Instead, just quickly
return an error.

Also, only print a warning in prep_compound_gigantic_page instead of
multiple callers.

Link: https://lkml.kernel.org/r/20210710002441.167759-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20210710002441.167759-2-mike.kravetz@oracle.com
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

 mm/hugetlb.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code
+++ a/mm/hugetlb.c
@@ -1657,16 +1657,12 @@ static bool prep_compound_gigantic_page(
 		 * cache adding could take a ref on a 'to be' tail page.
 		 * We need to respect any increased ref count, and only set
 		 * the ref count to zero if count is currently 1.  If count
-		 * is not 1, we call synchronize_rcu in the hope that a rcu
-		 * grace period will cause ref count to drop and then retry.
-		 * If count is still inflated on retry we return an error and
-		 * must discard the pages.
+		 * is not 1, we return an error and caller must discard the
+		 * pages.
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
@@ -1830,7 +1826,6 @@ retry:
 				retry = true;
 				goto retry;
 			}
-			pr_warn("HugeTLB page can not be used due to unexpected inflated ref count\n");
 			return NULL;
 		}
 	}
@@ -2828,8 +2823,8 @@ static void __init gather_bootmem_preall
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

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch

