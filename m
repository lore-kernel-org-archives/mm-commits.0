Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA478C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C04D1613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEHWsv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWsu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92DFD61402;
        Sat,  8 May 2021 22:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514068;
        bh=jofiNMwcDWsM7j1VDMIsbWjMPwhqsMYC4z9C4Y1XfPw=;
        h=Date:From:To:Subject:From;
        b=jeVy7NIVObr7L+BLe7JPLmFvE8Y8iqIDxv9UFJAoIjZjtl9qh55sGOwPGttQplC0k
         zwIlv4epQgAafs47ouacA6Ra+km1XZkYpIhLsUgqVqaiYPfZbnDxQ02t5N1MpwkGeN
         llbsxAkm6fYIU109vN8Tp6naGbZw9OJWVMtj1X1M=
Date:   Sat, 08 May 2021 15:47:48 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [merged]
 mmhugetlb-split-prep_new_huge_page-functionality.patch removed from -mm
 tree
Message-ID: <20210508224748.OkXJWR3-m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: split prep_new_huge_page functionality
has been removed from the -mm tree.  Its filename was
     mmhugetlb-split-prep_new_huge_page-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: split prep_new_huge_page functionality

Currently, prep_new_huge_page() performs two functions.  It sets the right
state for a new hugetlb, and increases the hstate's counters to account
for the new page.

Let us split its functionality into two separate functions, decoupling the
handling of the counters from initializing a hugepage.  The outcome is
having __prep_new_huge_page(), which only initializes the page , and
__prep_account_new_huge_page(), which adds the new page to the hstate's
counters.

This allows us to be able to set a hugetlb without having to worry about
the counter/locking.  It will prove useful in the next patch. 
prep_new_huge_page() still calls both functions.

Link: https://lkml.kernel.org/r/20210419075413.1064-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-split-prep_new_huge_page-functionality
+++ a/mm/hugetlb.c
@@ -1484,16 +1484,30 @@ void free_huge_page(struct page *page)
 	}
 }
 
-static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
+/*
+ * Must be called with the hugetlb lock held
+ */
+static void __prep_account_new_huge_page(struct hstate *h, int nid)
+{
+	lockdep_assert_held(&hugetlb_lock);
+	h->nr_huge_pages++;
+	h->nr_huge_pages_node[nid]++;
+}
+
+static void __prep_new_huge_page(struct page *page)
 {
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	hugetlb_set_page_subpool(page, NULL);
 	set_hugetlb_cgroup(page, NULL);
 	set_hugetlb_cgroup_rsvd(page, NULL);
+}
+
+static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
+{
+	__prep_new_huge_page(page);
 	spin_lock_irq(&hugetlb_lock);
-	h->nr_huge_pages++;
-	h->nr_huge_pages_node[nid]++;
+	__prep_account_new_huge_page(h, nid);
 	spin_unlock_irq(&hugetlb_lock);
 }
 
_

Patches currently in -mm which might be from osalvador@suse.de are


