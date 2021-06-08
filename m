Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4107C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B52E26139A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 21:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhFHVjn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhFHVjm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 17:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 090986139A;
        Tue,  8 Jun 2021 21:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623188259;
        bh=hCacbjeXXrFHjZPUC6H52E3Ct42+fI0BNfIAiG3+ZcU=;
        h=Date:From:To:Subject:From;
        b=XxJGfFI0KMUmYn0A77+4AvEIyoK9Jy7Nnaq5tnIz/hq54xgaBn0Oy/rvnhiPZgLEr
         z6ULy2+0uEs7DwTNfj0JzPhMdwGkHn86fGlLyBPBO/wT9ZlWdV2L1B+pi+2OMTgyOb
         1OuaVvePHnCQ/+19Fv4LTp3YyYJuWzAZIQfvY7ro=
Date:   Tue, 08 Jun 2021 14:37:38 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, sjenning@redhat.com
Subject:  + mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
 added to -mm tree
Message-ID: <20210608213738.XOUQAxcEy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: reuse unbuddied[0] as buddied in zbud_pool
has been added to the -mm tree.  Its filename is
     mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zbud: reuse unbuddied[0] as buddied in zbud_pool

Patch series "Cleanups for zbud", v2.

This series contains just cleanups to save some possible memory in
zbud_pool and avoid exporting any unneeded zbud API.  More details can be
found in the respective changelogs


This patch (of 2):

Since commit 9d8c5b5284e4 ("mm: zbud: fix condition check on allocation
size"), zbud_pool.unbuddied[0] is always unused.  We can reuse it as
buddied field to save some possible memory.

Link: https://lkml.kernel.org/r/20210608114515.206992-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210608114515.206992-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/zbud.c~mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool
+++ a/mm/zbud.c
@@ -93,8 +93,14 @@
  */
 struct zbud_pool {
 	spinlock_t lock;
-	struct list_head unbuddied[NCHUNKS];
-	struct list_head buddied;
+	union {
+		/*
+		 * Reuse unbuddied[0] as buddied on the ground that
+		 * unbuddied[0] is unused.
+		 */
+		struct list_head buddied;
+		struct list_head unbuddied[NCHUNKS];
+	};
 	struct list_head lru;
 	u64 pages_nr;
 	const struct zbud_ops *ops;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

