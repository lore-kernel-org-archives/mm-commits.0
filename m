Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1894FC00140
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 18:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiHXSne (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239751AbiHXSnc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 14:43:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BC37AC1A
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 11:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E0EC61782
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 18:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EF6C433D6;
        Wed, 24 Aug 2022 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661366609;
        bh=Ukow5lyhj6iIaOeMwtkWo83iaCl9KX6msp6TO7EvhzA=;
        h=Date:To:From:Subject:From;
        b=zo1aNI6Yt4p7EWh5GV954eZ3WmneA3/3de4VwmShfJl9HD4ZeMt0rgG4iWoY3TLrS
         2aSxElqNfJj041S7/IPl+zDI9tWGOaB9Q6XdwnsM8Yi9uyAHAr8qlXMpshnIZyI1GK
         hNf9gmLjlkTt4lylKxGekiPtO7AbiYweX9rTMgNo=
Date:   Wed, 24 Aug 2022 11:43:28 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, gerald.schaefer@linux.ibm.com,
        Felix.Kuehling@amd.com, david@redhat.com, apopple@nvidia.com,
        alex.sierra@amd.com, haiyue.wang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-the-handling-non-lru-pages-returned-by-follow_page.patch added to mm-unstable branch
Message-Id: <20220824184329.60EF6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix the handling Non-LRU pages returned by follow_page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-the-handling-non-lru-pages-returned-by-follow_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-the-handling-non-lru-pages-returned-by-follow_page.patch

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
From: Haiyue Wang <haiyue.wang@intel.com>
Subject: mm: fix the handling Non-LRU pages returned by follow_page
Date: Tue, 23 Aug 2022 21:58:41 +0800

The handling Non-LRU pages returned by follow_page() jumps directly, it
doesn't call put_page() to handle the reference count, since 'FOLL_GET'
flag for follow_page() has get_page() called.  Fix the zone device page
check by handling the page reference count correctly before returning.

And as David reviewed, "device pages are never PageKsm pages".  Drop this
zone device page check for break_ksm().

Since the zone device page can't be a transparent huge page, so drop the
redundant zone device page check for split_huge_pages_pid().  (by Miaohe)

Link: https://lkml.kernel.org/r/20220823135841.934465-3-haiyue.wang@intel.com
Fixes: 3218f8712d6b ("mm: handling Non-LRU pages returned by vm_normal_pages")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/ksm.c         |   12 +++++++++---
 mm/migrate.c     |   19 ++++++++++++-------
 3 files changed, 22 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-fix-the-handling-non-lru-pages-returned-by-follow_page
+++ a/mm/huge_memory.c
@@ -2979,7 +2979,7 @@ static int split_huge_pages_pid(int pid,
 		/* FOLL_DUMP to ignore special (like zero) pages */
 		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
-		if (IS_ERR_OR_NULL(page) || is_zone_device_page(page))
+		if (IS_ERR_OR_NULL(page))
 			continue;
 
 		if (!is_transparent_hugepage(page))
--- a/mm/ksm.c~mm-fix-the-handling-non-lru-pages-returned-by-follow_page
+++ a/mm/ksm.c
@@ -475,7 +475,7 @@ static int break_ksm(struct vm_area_stru
 		cond_resched();
 		page = follow_page(vma, addr,
 				FOLL_GET | FOLL_MIGRATION | FOLL_REMOTE);
-		if (IS_ERR_OR_NULL(page) || is_zone_device_page(page))
+		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
 			ret = handle_mm_fault(vma, addr,
@@ -560,12 +560,15 @@ static struct page *get_mergeable_page(s
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
-	if (IS_ERR_OR_NULL(page) || is_zone_device_page(page))
+	if (IS_ERR_OR_NULL(page))
 		goto out;
+	if (is_zone_device_page(page))
+		goto out_putpage;
 	if (PageAnon(page)) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	} else {
+out_putpage:
 		put_page(page);
 out:
 		page = NULL;
@@ -2321,11 +2324,13 @@ next_mm:
 			if (ksm_test_exit(mm))
 				break;
 			*page = follow_page(vma, ksm_scan.address, FOLL_GET);
-			if (IS_ERR_OR_NULL(*page) || is_zone_device_page(*page)) {
+			if (IS_ERR_OR_NULL(*page)) {
 				ksm_scan.address += PAGE_SIZE;
 				cond_resched();
 				continue;
 			}
+			if (is_zone_device_page(*page))
+				goto next_page;
 			if (PageAnon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
@@ -2340,6 +2345,7 @@ next_mm:
 				mmap_read_unlock(mm);
 				return rmap_item;
 			}
+next_page:
 			put_page(*page);
 			ksm_scan.address += PAGE_SIZE;
 			cond_resched();
--- a/mm/migrate.c~mm-fix-the-handling-non-lru-pages-returned-by-follow_page
+++ a/mm/migrate.c
@@ -1691,9 +1691,12 @@ static int add_page_for_migration(struct
 		goto out;
 
 	err = -ENOENT;
-	if (!page || is_zone_device_page(page))
+	if (!page)
 		goto out;
 
+	if (is_zone_device_page(page))
+		goto out_putpage;
+
 	err = 0;
 	if (page_to_nid(page) == node)
 		goto out_putpage;
@@ -1891,13 +1894,15 @@ static void do_pages_stat_array(struct m
 		if (IS_ERR(page))
 			goto set_status;
 
-		if (page && !is_zone_device_page(page)) {
+		err = -ENOENT;
+		if (!page)
+			goto set_status;
+
+		if (!is_zone_device_page(page))
 			err = page_to_nid(page);
-			if (foll_flags & FOLL_GET)
-				put_page(page);
-		} else {
-			err = -ENOENT;
-		}
+
+		if (foll_flags & FOLL_GET)
+			put_page(page);
 set_status:
 		*status = err;
 
_

Patches currently in -mm which might be from haiyue.wang@intel.com are

mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch
mm-fix-the-handling-non-lru-pages-returned-by-follow_page.patch

