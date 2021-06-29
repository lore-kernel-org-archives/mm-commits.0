Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F9AC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E644961CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhF2AX4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AXz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:23:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 936C961CED;
        Tue, 29 Jun 2021 00:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926088;
        bh=mVRT/5UhDKldwvCLFB7TU7YaqT9UqgElAadelHdv+Zc=;
        h=Date:From:To:Subject:From;
        b=koqJuT2H0nxyg8tT2NF3GJt6mdOYaYRYlJKmybdKasMzhAMuKe4XHkR+Ii+Xst8xK
         iwAy5hVUxZ4/aronkv2biG94y7o5Xf/CD436ycUWLLQ8iSznITs5KD8r/+76JICdh1
         OC2hKxlOqxRCPCXq7r8s753/RiBkpI5U957MRXwQ=
Date:   Mon, 28 Jun 2021 17:21:28 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
 removed from -mm tree
Message-ID: <20210629002128.YcGQmsbBQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: move scan_swap_map() under CONFIG_HIBERNATION
has been removed from the -mm tree.  Its filename was
     mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch

This patch was dropped because it was folded into mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: move scan_swap_map() under CONFIG_HIBERNATION

We should move scan_swap_map() under CONFIG_HIBERNATION since the only
caller of this function is get_swap_page_of_type() which is also under
CONFIG_HIBERNATION.  And this fixes the unused-function warning of
scan_swap_map().

Link: https://lkml.kernel.org/r/20210521070855.2015094-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix
+++ a/mm/swapfile.c
@@ -1037,21 +1037,6 @@ static void swap_free_cluster(struct swa
 	swap_range_free(si, offset, SWAPFILE_CLUSTER);
 }
 
-static unsigned long scan_swap_map(struct swap_info_struct *si,
-				   unsigned char usage)
-{
-	swp_entry_t entry;
-	int n_ret;
-
-	n_ret = scan_swap_map_slots(si, usage, 1, &entry);
-
-	if (n_ret)
-		return swp_offset(entry);
-	else
-		return 0;
-
-}
-
 int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
 {
 	unsigned long size = swap_entry_size(entry_size);
@@ -1789,6 +1774,21 @@ int free_swap_and_cache(swp_entry_t entr
 
 #ifdef CONFIG_HIBERNATION
 
+static unsigned long scan_swap_map(struct swap_info_struct *si,
+				   unsigned char usage)
+{
+	swp_entry_t entry;
+	int n_ret;
+
+	n_ret = scan_swap_map_slots(si, usage, 1, &entry);
+
+	if (n_ret)
+		return swp_offset(entry);
+	else
+		return 0;
+
+}
+
 swp_entry_t get_swap_page_of_type(int type)
 {
 	struct swap_info_struct *si = swap_type_to_swap_info(type);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
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

