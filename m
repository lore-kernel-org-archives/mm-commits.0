Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5FEEB64DD
	for <mm-commits@archiver.kernel.org>; Thu,  3 Aug 2023 17:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbjHCRRa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Aug 2023 13:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjHCRR2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2023 13:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753D62D49
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 10:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 106C561E4E
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 17:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB98C433CA;
        Thu,  3 Aug 2023 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691083046;
        bh=4jwnv2X7GWpECy6z1PkB5tWDy6lN2iFsKaJ5qh5FvME=;
        h=Date:To:From:Subject:From;
        b=LJ6bKn93QrqYpNefvR3bsU8zsTzqmLBnhI1rEEi6UMCVBIoWxpzdq//mTXy4qkdcM
         NJ51G/06JvULcRUSSVTPoyL56fzSgAJUdjwhzL1KMLQ9FL0BMhMFNvLTAGjFnDyUuq
         7EKacAIJmryMmCIcsKn8VrMBjds/KjhPb7cBxfhs=
Date:   Thu, 03 Aug 2023 10:17:25 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch added to mm-unstable branch
Message-Id: <20230803171726.5BB98C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: fix wrong function name above obj_cgroup_charge_zswap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch

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
Subject: mm/memcg: fix wrong function name above obj_cgroup_charge_zswap()
Date: Thu, 3 Aug 2023 20:00:21 +0800

The correct function name is obj_cgroup_may_zswap(). Correct the comment.

Link: https://lkml.kernel.org/r/20230803120021.762279-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap
+++ a/mm/memcontrol.c
@@ -7786,7 +7786,7 @@ bool obj_cgroup_may_zswap(struct obj_cgr
  * @objcg: the object cgroup
  * @size: size of compressed object
  *
- * This forces the charge after obj_cgroup_may_swap() allowed
+ * This forces the charge after obj_cgroup_may_zswap() allowed
  * compression and storage in zwap for this cgroup to go ahead.
  */
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-fix-wrong-swap-entry-type-for-hwpoisoned-swapcache-page.patch
mm-memory-failure-fix-potential-unexpected-return-value-from-unpoison_memory.patch
mm-memory-failure-avoid-false-hwpoison-page-mapped-error-info.patch
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

