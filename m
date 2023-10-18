Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B3BCDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjJRVfO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJRVfM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9DBD67
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:34:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F264DC433CA;
        Wed, 18 Oct 2023 21:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664888;
        bh=B254Gfn1ulgELEDgIAR2onPUDsKeAcaJQbdgKHOo/ws=;
        h=Date:To:From:Subject:From;
        b=xj2Mk9cW1c2uRuPa/bMwZE+sSG6QkQeVatBdFQ0tL7U3oj/n9mBtvLqhpIRUr9i1P
         4koxswDTjm5tOAvQrCBMQefIHvJA1hRquNgKm0oef1xB7u0rcWjnXyboJYqRPd3ukz
         WCghM9CN1adESMTlM1foO/9g2+z+a8K9oFTFK/KI=
Date:   Wed, 18 Oct 2023 14:34:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, song.bao.hua@hisilicon.com,
        rientjes@google.com, osalvador@suse.de, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com, joao.m.martins@oracle.com,
        duanxiongchun@bytedance.com, david@redhat.com,
        anshuman.khandual@arm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-check-for-hugetlb-folio-before-vmemmap_restore.patch removed from -mm tree
Message-Id: <20231018213447.F264DC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: check for hugetlb folio before vmemmap_restore
has been removed from the -mm tree.  Its filename was
     hugetlb-check-for-hugetlb-folio-before-vmemmap_restore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: check for hugetlb folio before vmemmap_restore
Date: Mon, 16 Oct 2023 19:55:49 -0700

In commit d8f5f7e445f0 ("hugetlb: set hugetlb page flag before
optimizing vmemmap") checks were added to print a warning if
hugetlb_vmemmap_restore was called on a non-hugetlb page.

This was mostly due to ordering issues in the hugetlb page set up and tear
down sequencees.  One place missed was the routine
dissolve_free_huge_page.

Naoya Horiguchi noted: "I saw that VM_WARN_ON_ONCE() in
hugetlb_vmemmap_restore is triggered when memory_failure() is called on a
free hugetlb page with vmemmap optimization disabled (the warning is not
triggered if vmemmap optimization is enabled).  I think that we need check
folio_test_hugetlb() before dissolve_free_huge_page() calls
hugetlb_vmemmap_restore_folio()."

Perform the check as suggested by Naoya.

Link: https://lkml.kernel.org/r/20231017032140.GA3680@monkey
Fixes: d8f5f7e445f0 ("hugetlb: set hugetlb page flag before optimizing vmemmap")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Tested-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb-check-for-hugetlb-folio-before-vmemmap_restore
+++ a/mm/hugetlb.c
@@ -2322,17 +2322,23 @@ retry:
 		 * need to adjust max_huge_pages if the page is not freed.
 		 * Attempt to allocate vmemmmap here so that we can take
 		 * appropriate action on failure.
+		 *
+		 * The folio_test_hugetlb check here is because
+		 * remove_hugetlb_folio will clear hugetlb folio flag for
+		 * non-vmemmap optimized hugetlb folios.
 		 */
-		rc = hugetlb_vmemmap_restore(h, &folio->page);
-		if (!rc) {
-			update_and_free_hugetlb_folio(h, folio, false);
-		} else {
-			spin_lock_irq(&hugetlb_lock);
-			add_hugetlb_folio(h, folio, false);
-			h->max_huge_pages++;
-			spin_unlock_irq(&hugetlb_lock);
-		}
+		if (folio_test_hugetlb(folio)) {
+			rc = hugetlb_vmemmap_restore(h, &folio->page);
+			if (rc) {
+				spin_lock_irq(&hugetlb_lock);
+				add_hugetlb_folio(h, folio, false);
+				h->max_huge_pages++;
+				goto out;
+			}
+		} else
+			rc = 0;
 
+		update_and_free_hugetlb_folio(h, folio, false);
 		return rc;
 	}
 out:
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch
hugetlb-restructure-pool-allocations.patch
hugetlb-perform-vmemmap-optimization-on-a-list-of-pages.patch
hugetlb-perform-vmemmap-restoration-on-a-list-of-pages.patch
hugetlb-batch-freeing-of-vmemmap-pages.patch
hugetlb-batch-tlb-flushes-when-restoring-vmemmap.patch

