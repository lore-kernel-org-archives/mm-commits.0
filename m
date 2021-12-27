Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B955AC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Dec 2021 00:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhL0ACQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 19:02:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44274 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhL0ACQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 19:02:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E244560E17
        for <mm-commits@vger.kernel.org>; Mon, 27 Dec 2021 00:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F365DC36AE8;
        Mon, 27 Dec 2021 00:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640563335;
        bh=YGdLsTleAt3PYm7GrJOk3I27JF/HrivDZ7xKolNOviA=;
        h=Date:From:To:Subject:From;
        b=E+HBTkOdiB6cTEjBhDsAcLMJV5cMD/okJS7fBehwv6aeCna4EPcdPrhzxi0mYZbOG
         gG8x3RlW3joG7k8+9mgpgRfaH+VMvbtPqJ6WGkwbMySa2PjbmGxhA4mglPd4gpJW6M
         QZkgjW5z3h3x1ZQTDIST2G4sxvKrawCRZUGxQQN0=
Date:   Sun, 26 Dec 2021 16:02:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        saravanand@fb.com, minchan@kernel.org, mike.kravetz@oracle.com,
        dave.hansen@linux.intel.com, yang.yang29@zte.com.cn
Subject:  + mm-vmstat-add-events-for-thp-max_ptes_-exceeds.patch
 added to -mm tree
Message-ID: <20211227000214.muFVy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: add events for THP max_ptes_* exceeds
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-thp-max_ptes_-exceeds.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-thp-max_ptes_-exceeds.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-thp-max_ptes_-exceeds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-vmstat-add-events-for-thp-max_ptes_-exceeds.patch
delayacct-support-swapin-delay-accounting-for-swapping-without-blkio.patch
delayacct-fix-incomplete-disable-operation-when-switch-enable-to-disable.patch
delayacct-cleanup-flags-in-struct-task_delay_info-and-functions-use-it.patch

