Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DF6C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 17:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBFF6135A
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 17:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbhESRBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 May 2021 13:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhESRBl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 May 2021 13:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11B056124C;
        Wed, 19 May 2021 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621443621;
        bh=pUprnhrdPSmZcbKMaLU0LeBtsJnWAPOn+gSOTzCVR/U=;
        h=Date:From:To:Subject:From;
        b=Y40RL4Qiew//7jVa3XqCQpoSR8AnvAs0Q+No813BY33STXVty+W0iuZV8xAkLOgJq
         BjtTp/pIZbac5J20jAyjzo0UIinYoe4vDnkZCKBdfUrIbI4vj5odA8guN8Flk2EwQp
         oJ+vEVAwDiRJo/A9nllyLNR7JEStdUa9734LUwc4=
Date:   Wed, 19 May 2021 10:00:20 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        yukuai3@huawei.com
Subject:  +
 lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch added
 to -mm tree
Message-ID: <20210519170020.4HACAvAh9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-decompressors-remove-set-but-not-used-variabled-level-fix
has been added to the -mm tree.  Its filename is
     lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-decompressors-remove-set-but-not-used-variabled-level-fix

warning: value computed is not used

Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_unlzo.c~lib-decompressors-remove-set-but-not-used-variabled-level-fix
+++ a/lib/decompress_unlzo.c
@@ -64,7 +64,7 @@ STATIC inline long INIT parse_header(u8
 	version = get_unaligned_be16(parse);
 	parse += 7;
 	if (version >= 0x0940)
-		*parse++;
+		parse++;
 	if (get_unaligned_be32(parse) & HEADER_HAS_FILTER)
 		parse += 8; /* flags + filter info */
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

