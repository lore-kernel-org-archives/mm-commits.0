Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC64EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89950216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881384;
	bh=kdusT84lPstzKgBJQ9bXJc3czHaFmjzc08dBvaomZc8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RgcwWzNcyruA0LoDJ8EvBI9qxXk3Wj9PDj96xuneVf+iSjL2qZHrkVnf63/YhC9wD
	 pu1ianOiq3VC4eFo1SPoD6thll5DmIWxlwI5Mgm5wO60sveYEHiXj4BQlLcHb47502
	 bto5B0gpS5ByJE9yyYO1/6G50+NUy53wzcCb6qcU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392723AbgJPUto (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4F952145D;
        Fri, 16 Oct 2020 20:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881383;
        bh=kdusT84lPstzKgBJQ9bXJc3czHaFmjzc08dBvaomZc8=;
        h=Date:From:To:Subject:From;
        b=n5cldG2yjgpN129u9qZiSuAWoWZzWeRNzuRnxKEh8P1XXtWdXwDebf/YIUfvd0iqM
         ot9Dw55pCyAs4cZ3D5WARqsuoUQQbCXNafstWiCImUUy9BpIioMdJeYAnoFS74lCf4
         cZL6FZ7X+9+ZYoahJRAau06Y0KKTQJcIEKPUFqic=
Date:   Fri, 16 Oct 2020 13:49:42 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        aris@ruivo.org, cai@lca.pw, dave.hansen@intel.com,
        david@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  [merged]
 mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
 removed from -mm tree
Message-ID: <20201016204942.6oUs8Amgt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline
has been removed from the -mm tree.  Its filename was
     mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline

Currently, there is an inconsistency when calling soft-offline from
different paths on a page that is already poisoned.

1) madvise:

        madvise_inject_error skips any poisoned page and continues
        the loop.
        If that was the only page to madvise, it returns 0.

2) /sys/devices/system/memory/:

        When calling soft_offline_page_store()->soft_offline_page(),
        we return -EBUSY in case the page is already poisoned.
        This is inconsistent with a) the above example and b)
        memory_failure, where we return 0 if the page was poisoned.

Fix this by dropping the PageHWPoison() check in madvise_inject_error, and
let soft_offline_page return 0 if it finds the page already poisoned.

Please, note that this represents a user-api change, since now the return
error when calling soft_offline_page_store()->soft_offline_page() will be
different.

Link: https://lkml.kernel.org/r/20200922135650.1634-12-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c        |    5 -----
 mm/memory-failure.c |    4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/madvise.c
@@ -896,11 +896,6 @@ static int madvise_inject_error(int beha
 		 */
 		size = page_size(compound_head(page));
 
-		if (PageHWPoison(page)) {
-			put_page(page);
-			continue;
-		}
-
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
--- a/mm/memory-failure.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/memory-failure.c
@@ -1802,7 +1802,7 @@ static int __soft_offline_page(struct pa
 		unlock_page(page);
 		put_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		return 0;
 	}
 
 	if (!PageHuge(page))
@@ -1906,7 +1906,7 @@ int soft_offline_page(unsigned long pfn,
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(page);
-		return -EBUSY;
+		return 0;
 	}
 
 	get_online_mems();
_

Patches currently in -mm which might be from osalvador@suse.de are


