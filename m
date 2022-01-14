Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9128AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiANWIA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiANWH7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6519FC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:07:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7486CE24A5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B9FC36AE9;
        Fri, 14 Jan 2022 22:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198076;
        bh=8H8KZ2Pu6BX3OqoLt3oCpnmieTMWW/dKlmrxjQ9dGGw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OnvMBu9oQJHghHu5CooY7kO9z/0ZGJwjUF/qxJkqPhHl6tNgc41G4ELuawoPQMsUA
         bBhtsPfG0HlvmQvMhySWtbp7GgFfU+ripy7XuB02maTntNsYFI8YH7ztBozSrdJb92
         4nUtSgltgFI14fdYoQ9Qh3pklA6Vftuks3N65Rig=
Date:   Fri, 14 Jan 2022 14:07:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, saravanand@fb.com,
        torvalds@linux-foundation.org, yang.yang29@zte.com.cn,
        ying.huang@intel.com
Subject:  [patch 090/146] mm/vmstat: add events for THP max_ptes_*
 exceeds
Message-ID: <20220114220755.QzewFdx6k%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/vmstat: add events for THP max_ptes_* exceeds

There are interfaces to adjust max_ptes_none, max_ptes_swap,
max_ptes_shared values, see
/sys/kernel/mm/transparent_hugepage/khugepaged/.

But system administrator maynot know which value is the best.  So Add
those events to support adjusting max_ptes_* to suitable values.

For example, if default max_ptes_swap value causes too much failures, and
system uses zram whose IO is fast, administrator could increase
max_ptes_swap until THP_SCAN_EXCEED_SWAP_PTE not increase anymore.

Link: https://lkml.kernel.org/r/20211225094036.574157-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Saravanan D <saravanand@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    3 +++
 mm/khugepaged.c               |    7 +++++++
 mm/vmstat.c                   |    3 +++
 3 files changed, 13 insertions(+)

--- a/include/linux/vm_event_item.h~mm-vmstat-add-events-for-thp-max_ptes_-exceeds
+++ a/include/linux/vm_event_item.h
@@ -98,6 +98,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_SPLIT_PAGE_FAILED,
 		THP_DEFERRED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
+		THP_SCAN_EXCEED_NONE_PTE,
+		THP_SCAN_EXCEED_SWAP_PTE,
+		THP_SCAN_EXCEED_SHARED_PTE,
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 		THP_SPLIT_PUD,
 #endif
--- a/mm/khugepaged.c~mm-vmstat-add-events-for-thp-max_ptes_-exceeds
+++ a/mm/khugepaged.c
@@ -618,6 +618,7 @@ static int __collapse_huge_page_isolate(
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
+				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out;
 			}
 		}
@@ -636,6 +637,7 @@ static int __collapse_huge_page_isolate(
 		if (page_mapcount(page) > 1 &&
 				++shared > khugepaged_max_ptes_shared) {
 			result = SCAN_EXCEED_SHARED_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 			goto out;
 		}
 
@@ -1253,6 +1255,7 @@ static int khugepaged_scan_pmd(struct mm
 				continue;
 			} else {
 				result = SCAN_EXCEED_SWAP_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				goto out_unmap;
 			}
 		}
@@ -1262,6 +1265,7 @@ static int khugepaged_scan_pmd(struct mm
 				continue;
 			} else {
 				result = SCAN_EXCEED_NONE_PTE;
+				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out_unmap;
 			}
 		}
@@ -1290,6 +1294,7 @@ static int khugepaged_scan_pmd(struct mm
 		if (page_mapcount(page) > 1 &&
 				++shared > khugepaged_max_ptes_shared) {
 			result = SCAN_EXCEED_SHARED_PTE;
+			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 			goto out_unmap;
 		}
 
@@ -2000,6 +2005,7 @@ static void khugepaged_scan_file(struct
 		if (xa_is_value(page)) {
 			if (++swap > khugepaged_max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
+				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
 			}
 			continue;
@@ -2046,6 +2052,7 @@ static void khugepaged_scan_file(struct
 	if (result == SCAN_SUCCEED) {
 		if (present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
 			result = SCAN_EXCEED_NONE_PTE;
+			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
 			node = khugepaged_find_target_node();
 			collapse_file(mm, file, start, hpage, node);
--- a/mm/vmstat.c~mm-vmstat-add-events-for-thp-max_ptes_-exceeds
+++ a/mm/vmstat.c
@@ -1353,6 +1353,9 @@ const char * const vmstat_text[] = {
 	"thp_split_page_failed",
 	"thp_deferred_split_page",
 	"thp_split_pmd",
+	"thp_scan_exceed_none_pte",
+	"thp_scan_exceed_swap_pte",
+	"thp_scan_exceed_share_pte",
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 	"thp_split_pud",
 #endif
_
