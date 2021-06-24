Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3882C49EA6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E4FD613C7
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFXUyf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhFXUyf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4D09613C3;
        Thu, 24 Jun 2021 20:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624567934;
        bh=/vX2FndIec923gOkNhLMNn4aMiJBf6oaceEG4JJLV5o=;
        h=Date:From:To:Subject:From;
        b=vikM2DgGBbhEEJH9Z0c0cuftZSOowSBBq3HSS15ZIyoQUAjZIjqf35p3lR1btHlra
         Qqor/ksiAcGE+mLPCkYmXWCDHdcoL4u1NjUvkQdYhTBs/M7TXY1Ai2dhkjDpO0nHmd
         fllWHc/8RIVOshQNpw7uo7F42RNHpUzOPpCZWc9g=
Date:   Thu, 24 Jun 2021 13:52:14 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  + mm-workingset-define-macro-workingset_shift.patch added
 to -mm tree
Message-ID: <20210624205214.fuQf5Lw8E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: define macro WORKINGSET_SHIFT
has been added to the -mm tree.  Its filename is
     mm-workingset-define-macro-workingset_shift.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-define-macro-workingset_shift.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-define-macro-workingset_shift.patch

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
Subject: mm: workingset: define macro WORKINGSET_SHIFT

The magic number 1 is used in several places in workingset.c.  Define a
macro WORKINGSET_SHIFT for it to improve code readability.

Link: https://lkml.kernel.org/r/20210624122307.1759342-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/workingset.c~mm-workingset-define-macro-workingset_shift
+++ a/mm/workingset.c
@@ -168,8 +168,10 @@
  * refault distance will immediately activate the refaulting page.
  */
 
+#define WORKINGSET_SHIFT 1
 #define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
-			 1 + NODES_SHIFT + MEM_CGROUP_ID_SHIFT)
+			 WORKINGSET_SHIFT + NODES_SHIFT + \
+			 MEM_CGROUP_ID_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
 
 /*
@@ -189,7 +191,7 @@ static void *pack_shadow(int memcgid, pg
 	eviction &= EVICTION_MASK;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
-	eviction = (eviction << 1) | workingset;
+	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
 
 	return xa_mk_value(eviction);
 }
@@ -201,8 +203,8 @@ static void unpack_shadow(void *shadow,
 	int memcgid, nid;
 	bool workingset;
 
-	workingset = entry & 1;
-	entry >>= 1;
+	workingset = entry & ((1UL << WORKINGSET_SHIFT) - 1);
+	entry >>= WORKINGSET_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
 	entry >>= NODES_SHIFT;
 	memcgid = entry & ((1UL << MEM_CGROUP_ID_SHIFT) - 1);
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
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-workingset-define-macro-workingset_shift.patch
mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch
mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch
mm-z3fold-remove-magic-number-in-z3fold_create_pool.patch
mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch
mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool.patch
mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zbud-dont-export-any-zbud-api-fix.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch
mm-zsmallocc-remove-confusing-code-in-obj_free.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch
mm-zsmallocc-improve-readability-for-async_free_zspage.patch

