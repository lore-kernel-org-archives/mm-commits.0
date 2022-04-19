Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FE6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 18:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiDSSny (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239437AbiDSSnx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 14:43:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E9233E17
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 11:41:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1C28B81866
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 18:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36026C385A5;
        Tue, 19 Apr 2022 18:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650393665;
        bh=//nPqZLE0ABX47ip1HCdvDSjhnIm7f5SoN/BEnf/7nc=;
        h=Date:To:From:Subject:From;
        b=mkwTyQIsf5A4w8j3py9WetK3Xe+v4dUMtLlCqucW7tqLGF2Fqn2ApW8gKE1rb0RUW
         UAR/E4OdGwdZ/ykIatucH8nT9c7gW2DEw5iPFGg4ZKesEdGgRJobJtUB0Qc8r4/HcX
         VLI07YfsWZjfvUuW1TswGbKJH3Mfiq3M9yh0mzJo=
Date:   Tue, 19 Apr 2022 11:41:04 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-gup-triggered-unsharing-of-anonymous-pages-fix.patch added to -mm tree
Message-Id: <20220419184105.36026C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-gup-triggered-unsharing-of-anonymous-pages-fix
has been added to the -mm tree.  Its filename is
     mm-support-gup-triggered-unsharing-of-anonymous-pages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-support-gup-triggered-unsharing-of-anonymous-pages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-support-gup-triggered-unsharing-of-anonymous-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-support-gup-triggered-unsharing-of-anonymous-pages-fix

Link: https://lkml.kernel.org/r/c003964a-9fa1-b17c-158a-8ccbf4ff8656@redhat.com
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-support-gup-triggered-unsharing-of-anonymous-pages-fix
+++ a/mm/memory.c
@@ -3132,7 +3132,7 @@ static vm_fault_t wp_page_copy(struct vm
 			free_swap_cache(old_page);
 		put_page(old_page);
 	}
-	return page_copied && !unshare ? VM_FAULT_WRITE : 0;
+	return (page_copied && !unshare) ? VM_FAULT_WRITE : 0;
 oom_free_new:
 	put_page(new_page);
 oom:
@@ -4557,7 +4557,7 @@ static inline vm_fault_t wp_huge_pmd(str
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 
 	if (vma_is_anonymous(vmf->vma)) {
-		if (unlikely(unshare) &&
+		if (likely(!unshare) &&
 		    userfaultfd_huge_pmd_wp(vmf->vma, vmf->orig_pmd))
 			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf);
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
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages-fix.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

