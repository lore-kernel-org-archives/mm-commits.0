Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDB2C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKIBbh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKIBbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:31:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555276034E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:31:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16864B81C38
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F07C433D6;
        Wed,  9 Nov 2022 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957493;
        bh=sWJCIQ2J0swhgemCY/0ruty0+ZFldA8q7dBPdWT+QCA=;
        h=Date:To:From:Subject:From;
        b=FGlbgVgMmEWwHBBER4+XomenfGdS7RBMZju6t47KlKrsaDiFZiLV7ZtqjRQf2JQ1J
         Gq3XxnYPcTk48NnGTtvwBM/BKF3dS5SE7gK/k2zU5F4VRduagdL12cJqg1J8SN8HfD
         VrjO23T0Fm0c+FQGMTpoYlzbJAnqZ8jxNYMRA+gg=
Date:   Tue, 08 Nov 2022 17:31:33 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8.patch removed from -mm tree
Message-Id: <20221109013133.B6F07C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8
has been removed from the -mm tree.  Its filename was
     mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8.patch

This patch was dropped because it was folded into mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Subject: mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8
Date: Tue, 25 Oct 2022 14:35:59 +0900

remove TestClearHPageMigratable and reduce to test and clear separately

Link: https://lkml.kernel.org/r/20221025053559.GA2104800@ik1-406-35019.vs.sakura.ne.jp
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    9 ---------
 mm/memory-failure.c     |    6 ++++--
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb.h~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8
+++ a/include/linux/hugetlb.h
@@ -616,10 +616,6 @@ void folio_clear_hugetlb_##flname(struct
 	}							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ clear_bit(HPG_##flname, &(page->private)); }
-
-#define TESTCLEARHPAGEFLAG(uname, flname)			\
-static inline int TestClearHPage##uname(struct page *page)	\
-	{ return test_and_clear_bit(HPG_##flname, &(page->private)); }
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
@@ -641,10 +637,6 @@ folio_clear_hugetlb_##flname(struct foli
 	{ }							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ }
-
-#define TESTCLEARHPAGEFLAG(uname, flname)			\
-static inline int TestClearHPage##uname(struct page *page)	\
-	{ return 0; }
 #endif
 
 #define HPAGEFLAG(uname, flname)				\
@@ -657,7 +649,6 @@ static inline int TestClearHPage##uname(
  */
 HPAGEFLAG(RestoreReserve, restore_reserve)
 HPAGEFLAG(Migratable, migratable)
-	TESTCLEARHPAGEFLAG(Migratable, migratable)
 HPAGEFLAG(Temporary, temporary)
 HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
--- a/mm/memory-failure.c~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8
+++ a/mm/memory-failure.c
@@ -1823,8 +1823,10 @@ int __get_huge_page_for_hwpoison(unsigne
 	 * Clearing HPageMigratable for hwpoisoned hugepages to prevent them
 	 * from being migrated by memory hotremove.
 	 */
-	if (count_increased)
-		*migratable_cleared = TestClearHPageMigratable(head);
+	if (count_increased && HPageMigratable(head)) {
+		ClearHPageMigratable(head);
+		*migratable_cleared = true;
+	}
 
 	return ret;
 out:
_

Patches currently in -mm which might be from naoya.horiguchi@linux.dev are

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch

