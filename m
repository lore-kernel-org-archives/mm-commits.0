Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D772C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 399EE61181
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhDIFJ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233279AbhDIFJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:09:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96CCE61177;
        Fri,  9 Apr 2021 05:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944876;
        bh=OWr9c5dwJgrBXbhba0WkBSTwO6JyTsRUdShutsUXThA=;
        h=Date:From:To:Subject:From;
        b=LAecZ4r4bNEL81Ioi8kzqRrByr4A0EG7Xl9UT5GOvOk7ab+KrQQOK2zmRwL+0H1wt
         53hzzkyJgDY6dqlygqlYicWorbhNSlkcQ3YQm117pishIm0rlYAE59DWa90a696ugR
         6hMa2aX71QI9iXlYLEhpTB5qoBHeiCJo6hNdLmBY=
Date:   Thu, 08 Apr 2021 22:07:56 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  [to-be-updated]
 =?US-ASCII?Q?mmcompaction-let-isolate=5Fmigratepages=5Frangeblock-retu?=
 =?US-ASCII?Q?rn-error-codes-fix.patch?= removed from -mm tree
Message-ID: <20210409050756.50U8N04nT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix
has been removed from the -mm tree.  Its filename was
     mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix

fix missed place wrt. error handling

Link: https://lkml.kernel.org/r/20210323104858.GA7776@linux
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix
+++ a/mm/compaction.c
@@ -809,6 +809,7 @@ isolate_migratepages_block(struct compac
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
 	bool skip_updated = false;
+	int ret = 0;
 
 	cc->migrate_pfn = low_pfn;
 
@@ -877,8 +878,8 @@ isolate_migratepages_block(struct compac
 
 			if (fatal_signal_pending(current)) {
 				cc->contended = true;
+				ret = -EINTR;
 
-				low_pfn = 0;
 				goto fatal_pending;
 			}
 
@@ -1134,7 +1135,7 @@ fatal_pending:
 
 	cc->migrate_pfn = low_pfn;
 
-	return 0;
+	return ret;
 }
 
 /**
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

