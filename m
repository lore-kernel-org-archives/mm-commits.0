Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD97CC001DB
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 16:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjHGQPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjHGQPq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 12:15:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F3610F7
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 09:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2905A61EE1
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 16:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825B2C433C7;
        Mon,  7 Aug 2023 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691424941;
        bh=wW+dieCbxB1MeRBlKHWAoiU0dUvTZdlPU89YtAgFOJY=;
        h=Date:To:From:Subject:From;
        b=W1/VtHKgKcO5VOS2GEaRF+YKbPwVs8hTVnbTFKX3zvjL/2tJ1Z5/7zl+o/Pr7p+dq
         o0hFih3YfKhYSu2sFzYedH+YiWjxNVYouFkWrjYCk6rBoniMBQ1gf5pInc6Jv2UwO4
         vH/wzWL3cmXPTTGO0KaGcMJQP5tJ3EtMW/p4tJws=
Date:   Mon, 07 Aug 2023 09:15:40 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch added to mm-unstable branch
Message-Id: <20230807161541.825B2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init: use helper macro BITS_PER_LONG and BITS_PER_BYTE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mm_init: use helper macro BITS_PER_LONG and BITS_PER_BYTE
Date: Mon, 7 Aug 2023 10:35:28 +0800

It's more readable to use helper macro BITS_PER_LONG and BITS_PER_BYTE. 
No functional change intended.

Link: https://lkml.kernel.org/r/20230807023528.325191-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte
+++ a/mm/mm_init.c
@@ -79,7 +79,7 @@ void __init mminit_verify_pageflags_layo
 	int shift, width;
 	unsigned long or_mask, add_mask;
 
-	shift = 8 * sizeof(unsigned long);
+	shift = BITS_PER_LONG;
 	width = shift - SECTIONS_WIDTH - NODES_WIDTH - ZONES_WIDTH
 		- LAST_CPUPID_SHIFT - KASAN_TAG_WIDTH - LRU_GEN_WIDTH - LRU_REFS_WIDTH;
 	mminit_dprintk(MMINIT_TRACE, "pageflags_layout_widths",
@@ -1426,9 +1426,9 @@ static unsigned long __init usemap_size(
 	usemapsize = roundup(zonesize, pageblock_nr_pages);
 	usemapsize = usemapsize >> pageblock_order;
 	usemapsize *= NR_PAGEBLOCK_BITS;
-	usemapsize = roundup(usemapsize, 8 * sizeof(unsigned long));
+	usemapsize = roundup(usemapsize, BITS_PER_LONG);
 
-	return usemapsize / 8;
+	return usemapsize / BITS_PER_BYTE;
 }
 
 static void __ref setup_usemap(struct zone *zone)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch
mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch
mm-memory-failure-remove-unneeded-pagehuge-check.patch
mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch
mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch
mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch
mm-memory-failure-remove-unneeded-header-files.patch
mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch
mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch
mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch
mm-huge_memory-use-rmap_none-when-calling-page_add_anon_rmap.patch
mm-memcg-fix-obsolete-comment-above-mem_cgroup_max_reclaim_loops.patch
mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch
memory-tier-use-helper-macro-__attr_rw.patch
mm-fix-obsolete-function-name-above-debug_pagealloc_enabled_static.patch
mm-mprotect-fix-obsolete-function-name-in-change_pte_range.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

