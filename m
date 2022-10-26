Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AE2C38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 03:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiJZDWu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 23:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiJZDWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 23:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F46A99DA
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 20:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E47A8B81EED
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 03:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7048FC433C1;
        Wed, 26 Oct 2022 03:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666754565;
        bh=6wgkbEx7RPTysg3qsFvPikIXrNS03+6pGjGprkuK3T4=;
        h=Date:To:From:Subject:From;
        b=1qfotcFEiYagRk7mnz8Kq47QgyQ4ZSVqU5TQJxAcjol85Tt5JX6ddbgrJwULQcQuH
         zyLIHEv/oLqupPwolCwmg6ecd+v7pZ4I0MiGLQvh7K9D6E3udccv+5OZXEHpTCZcNO
         F7MhQgZ+6olm1dmh+ljBIhEg0oocdkSgPp6eiLyo=
Date:   Tue, 25 Oct 2022 20:22:43 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jane.chu@oracle.com, david@redhat.com,
        naoya.horiguchi@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8.patch added to mm-unstable branch
Message-Id: <20221026032245.7048FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8
has been added to the -mm mm-unstable branch.  Its filename is
     mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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


--- a/include/linux/hugetlb.h~mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8
+++ a/include/linux/hugetlb.h
@@ -623,10 +623,6 @@ void folio_clear_hugetlb_##flname(struct
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
@@ -648,10 +644,6 @@ folio_clear_hugetlb_##flname(struct foli
 	{ }							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ }
-
-#define TESTCLEARHPAGEFLAG(uname, flname)			\
-static inline int TestClearHPage##uname(struct page *page)	\
-	{ return 0; }
 #endif
 
 #define HPAGEFLAG(uname, flname)				\
@@ -664,7 +656,6 @@ static inline int TestClearHPage##uname(
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

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage-v8.patch

