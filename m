Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3882C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 00:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiEJAlW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 20:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiEJAlV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 20:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2928333C
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 17:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7CACB819FF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 00:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BD2C385C2;
        Tue, 10 May 2022 00:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652143043;
        bh=rEaFlbWFhzNo1L6dQ9PwjtUm49mrxfkO2m/rjYh9e30=;
        h=Date:To:From:Subject:From;
        b=D+2p50LgUHWHsH+fPtDZXPwpDns+HJzy5X6Xz9+Yuq4e9OlmGuS+hkzQ5ONUk6GoY
         jhyQtNEFUmHsUuNVN1Nk0yAXPteTc9YzeMfU/6Pk0XOaZaYvvB39zgUWewH+ExKkLh
         Nr6zwzZUzn/AVro40mKbn8kuhBudj6oPxloWbRX0=
Date:   Mon, 09 May 2022 17:37:22 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix.patch removed from -mm tree
Message-Id: <20220510003723.92BD2C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix.patch

This patch was dropped because it was folded into mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix

Link: https://lkml.kernel.org/r/ac725bcb-313a-4fff-250a-68ba9a8f85fb@redhat.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix
+++ a/mm/memory.c
@@ -3747,7 +3747,7 @@ vm_fault_t do_swap_page(struct vm_fault
 			 */
 			exclusive = true;
 		} else if (exclusive && PageWriteback(page) &&
-			   !(swp_swap_info(entry)->flags & SWP_STABLE_WRITES)) {
+			  (swp_swap_info(entry)->flags & SWP_STABLE_WRITES)) {
 			/*
 			 * This is tricky: not all swap backends support
 			 * concurrent page modifications while under writeback.
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

