Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF12C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiI0Cz5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiI0CzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF78436DFF
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85B78B81986
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DADDC433D7;
        Tue, 27 Sep 2022 02:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247012;
        bh=aHpNGPv0ZXZ+THp31pLksZ+hasBTSc3ecJmEDVP3LnY=;
        h=Date:To:From:Subject:From;
        b=sUj2wR16+HmAsLTDVJ4UCQ6A+9/inTRweJge0JDN4wxbpBOauBjAdoRIZ6pNVYIdu
         DAnryZN8xRKUU9mqQrpGtb9fnf0YQDENAvJQni4Ti/cmN90RDonEZe8N83zzRWVGm6
         bZsi8dz4W6bvxX7sG8V4LSAUcJcACnD9IWX4+yhI=
Date:   Mon, 26 Sep 2022 19:50:11 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, gerald.schaefer@linux.ibm.com,
        Felix.Kuehling@amd.com, david@redhat.com, apopple@nvidia.com,
        alex.sierra@amd.com, haiyue.wang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-the-handling-non-lru-pages-returned-by-follow_page.patch removed from -mm tree
Message-Id: <20220927025012.2DADDC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix the handling Non-LRU pages returned by follow_page
has been removed from the -mm tree.  Its filename was
     mm-fix-the-handling-non-lru-pages-returned-by-follow_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3001,7 +3001,7 @@ static int split_huge_pages_pid(int pid,
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
@@ -2322,11 +2325,13 @@ next_mm:
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
@@ -2341,6 +2346,7 @@ next_mm:
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


