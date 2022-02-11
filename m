Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A8FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 21:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbiBKVy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:54:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiBKVy3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 16:54:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD2EC6E
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 13:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4654C61180
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 21:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910A3C340E9;
        Fri, 11 Feb 2022 21:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644616465;
        bh=jUMwudmyKkpTC39Rew67L3QULFtjmFda5FfRbz87yYk=;
        h=Date:To:From:Subject:From;
        b=KVf5YUS/LlKbORXtcyv3Zuvjx26sARy07oBECiJSRXR58Zj0OaeZ9sz4c78Xtoqvt
         6g4fBClklKkoFpccr2s43m3jRFfslWwfZ0KBmgYRil4+Zvj9wKYJVEMhzkLU+L303S
         eLUWrqj1tL/eEKOBoW++nXsuyMfn3iHHAOjITJeA=
Date:   Fri, 11 Feb 2022 13:54:25 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch added to -mm tree
Message-Id: <20220211215425.910A3C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/internal: Implement no-op mlock_page_drain() for !CONFIG_MMU
has been added to the -mm tree.  Its filename is
     mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/internal: Implement no-op mlock_page_drain() for !CONFIG_MMU

Commit 4b3b8bd6c8287 ("mm/munlock: mlock_page() munlock_page() batch by
pagevec") in -mm tree[1] implements 'mlock_page_drain()' under CONFIG_MMU
only, but the function is used by 'lru_add_drain_cpu()', which defined
outside of CONFIG_MMU.  As a result, below build error occurs.

    /linux/mm/swap.c: In function 'lru_add_drain_cpu':
    /linux/mm/swap.c:637:2: error: implicit declaration of function 'mlock_page_drain' [-Werror=implicit-function-declaration]
      637 |  mlock_page_drain(cpu);
          |  ^~~~~~~~~~~~~~~~
    cc1: some warnings being treated as errors
    /linux/scripts/Makefile.build:289: recipe for target 'mm/swap.o' failed

This commit fixes it by implementing no-op 'mlock_page_drain()' for
!CONFIG_MMU case, similar to 'mlock_new_page()'.

[1] https://www.ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch

[hughd: add need_mlock_page_drain() stub too]
Link: https://lkml.kernel.org/r/8eae6026-098-befb-92d3-b9ad2ad57776@google.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/internal.h~mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2
+++ a/mm/internal.h
@@ -508,6 +508,8 @@ static inline void mlock_vma_page(struct
 static inline void munlock_vma_page(struct page *page,
 			struct vm_area_struct *vma, bool compound) { }
 static inline void mlock_new_page(struct page *page) { }
+static inline bool need_mlock_page_drain(int cpu) { return false; }
+static inline void mlock_page_drain(int cpu) { }
 static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-munlock-mlock_page-munlock_page-batch-by-pagevec-fix-2.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch

