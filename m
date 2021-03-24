Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9D4C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6622C61A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhCXWvr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234409AbhCXWv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8CCD619B8;
        Wed, 24 Mar 2021 22:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616626286;
        bh=FQ2FfKyuBRDXbmFr5aefyaxsud8NL4A1Ccr3Wlyx0Tg=;
        h=Date:From:To:Subject:From;
        b=yciExn/eo0cv18H8LTrmD4LuC3oOTbuo4YsLWN/fYt4far+qchwtc2OWfDRoHGH4M
         59Yj+ft4Jf8PZXZba+K/PcPLPiPVxON68cX1ABwfxRcGZlV2CF1FZF6NKJwsNQI8j7
         lUXYRb/Y5vJtNH5SkUG/43yVgQrzmTvDkyAzLOME=
Date:   Wed, 24 Mar 2021 15:51:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, minchan@kernel.org,
        mike.kravetz@oracle.com, mhocko@suse.com, david@redhat.com,
        osalvador@suse.de
Subject:  +
 mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch
 added to -mm tree
Message-ID: <20210324225126.cVuxQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix
has been added to the -mm tree.  Its filename is
     mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes-fix.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

