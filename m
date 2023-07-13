Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC13C001DF
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 21:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjGMVkc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 17:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjGMVka (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 17:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3912691;
        Thu, 13 Jul 2023 14:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 215C761B79;
        Thu, 13 Jul 2023 21:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BA1C433C8;
        Thu, 13 Jul 2023 21:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689284428;
        bh=kFcgQ8BD28xoK9hgBQWspmqvowV58PxRX9R2PNX84Zg=;
        h=Date:To:From:Subject:From;
        b=lrISmNhI1jDx783IK0AhtUiId+goQk+w5cEn1Kv2O8jiXpWzcGLAQxJyxeUdTjijC
         ZnHupBkTtgy08lX6SccnaqYt7cpRqhLkzRqpZCjEU9R1QkShnOnSnd4r2irBdRzVRB
         CJD1XRMtVB5NGQrcKhXouaA6jvcavtQZT8h4hHlc=
Date:   Thu, 13 Jul 2023 14:40:26 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com, jthoughton@google.com,
        jiaqiyan@google.com, axelrasmussen@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch removed from -mm tree
Message-Id: <20230713214028.75BA1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: optimize update_and_free_pages_bulk to avoid lock cycles
has been removed from the -mm tree.  Its filename was
     hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: optimize update_and_free_pages_bulk to avoid lock cycles
Date: Tue, 11 Jul 2023 15:09:42 -0700

update_and_free_pages_bulk is designed to free a list of hugetlb pages
back to their associated lower level allocators.  This may require
allocating vmemmap pages associated with each hugetlb page.  The hugetlb
page destructor must be changed before pages are freed to lower level
allocators.  However, the destructor must be changed under the hugetlb
lock.  This means there is potentially one lock cycle per page.

Minimize the number of lock cycles in update_and_free_pages_bulk by:
1) allocating necessary vmemmap for all hugetlb pages on the list
2) take hugetlb lock and clear destructor for all pages on the list
3) free all pages on list back to low level allocators

Link: https://lkml.kernel.org/r/20230711220942.43706-3-mike.kravetz@oracle.com
Fixes: ad2fa3717b74 ("mm: hugetlb: alloc the vmemmap pages associated with each HugeTLB page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-optimize-update_and_free_pages_bulk-to-avoid-lock-cycles
+++ a/mm/hugetlb.c
@@ -1855,11 +1855,44 @@ static void update_and_free_pages_bulk(s
 {
 	struct page *page, *t_page;
 	struct folio *folio;
+	bool clear_dtor = false;
 
+	/*
+	 * First allocate required vmemmmap for all pages on list.  If vmemmap
+	 * can not be allocated, we can not free page to lower level allocator,
+	 * so add back as hugetlb surplus page.
+	 */
+	list_for_each_entry_safe(page, t_page, list, lru) {
+		if (HPageVmemmapOptimized(page)) {
+			clear_dtor = true;
+			if (hugetlb_vmemmap_restore(h, page)) {
+				spin_lock_irq(&hugetlb_lock);
+				add_hugetlb_folio(h, folio, true);
+				spin_unlock_irq(&hugetlb_lock);
+			}
+			cond_resched();
+		}
+	}
+
+	/*
+	 * If vmemmmap allocation performed above, then take lock * to clear
+	 * destructor of all pages on list.
+	 */
+	if (clear_dtor) {
+		spin_lock_irq(&hugetlb_lock);
+		list_for_each_entry(page, list, lru)
+			__clear_hugetlb_destructor(h, page_folio(page));
+		spin_unlock_irq(&hugetlb_lock);
+	}
+
+	/*
+	 * Free pages back to low level allocators.  vmemmap and destructors
+	 * were taken care of above, so update_and_free_hugetlb_folio will
+	 * not need to take hugetlb lock.
+	 */
 	list_for_each_entry_safe(page, t_page, list, lru) {
 		folio = page_folio(page);
 		update_and_free_hugetlb_folio(h, folio, false);
-		cond_resched();
 	}
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-do-not-clear-hugetlb-dtor-until-allocating-vmemmap.patch

