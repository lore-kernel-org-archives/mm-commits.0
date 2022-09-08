Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDA1C6FA82
	for <mm-commits@archiver.kernel.org>; Thu,  8 Sep 2022 22:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiIHW02 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIHW01 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2022 18:26:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B069A9C0
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 15:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B80F61E3D
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 22:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A644AC433D6;
        Thu,  8 Sep 2022 22:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662675985;
        bh=hkrNbQTByw7MdNvP5L1nfDUQtUNAwIDgbZSXDQN9XqM=;
        h=Date:To:From:Subject:From;
        b=XXr+2mZrg+1uxvX1YuYyDMZPZuKxwBlb+iI1Ax6s/47kPPvI86aLtL2O0USoL7dUE
         /E+YtwPjYPe5mnXa+affutiiKGDe2r8QjJYFj68uUbgQs/qXiBDFCUvNdNkScvqgn9
         dxo8GCetGTYfhliCc1EbFQMOgt28YGKGAELQKIog=
Date:   Thu, 08 Sep 2022 15:26:24 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        osalvador@suse.de, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-tests-add-new-pageblock-related-macro.patch added to mm-unstable branch
Message-Id: <20220908222625.A644AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock tests: add new pageblock related macro
has been added to the -mm mm-unstable branch.  Its filename is
     memblock-tests-add-new-pageblock-related-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-tests-add-new-pageblock-related-macro.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: memblock tests: add new pageblock related macro
Date: Wed, 7 Sep 2022 16:26:43 +0800

Add new pageblock_start_pfn() and pageblock_align() macro which are needed
by memblock tests.

Link: https://lkml.kernel.org/r/20220907082643.186979-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/memblock/linux/mmzone.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/memblock/linux/mmzone.h~memblock-tests-add-new-pageblock-related-macro
+++ a/tools/testing/memblock/linux/mmzone.h
@@ -22,6 +22,8 @@ enum zone_type {
 
 #define pageblock_order		(MAX_ORDER - 1)
 #define pageblock_nr_pages	BIT(pageblock_order)
+#define pageblock_align(pfn)	ALIGN((pfn), pageblock_nr_pages)
+#define pageblock_start_pfn(pfn)	ALIGN_DOWN((pfn), pageblock_nr_pages)
 
 struct zone {
 	atomic_long_t		managed_pages;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch
mm-memory-failure-kill-__soft_offline_page-v2.patch
mm-kill-is_memblock_offlined.patch
mm-fix-null-ptr-deref-in-kswapd_is_running.patch
mm-remove-bug_on-in-__isolate_free_page.patch
mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

