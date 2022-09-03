Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF68ECAAD4
	for <mm-commits@archiver.kernel.org>; Sat,  3 Sep 2022 19:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiICTmk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 3 Sep 2022 15:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiICTmj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 3 Sep 2022 15:42:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4848F543CB
        for <mm-commits@vger.kernel.org>; Sat,  3 Sep 2022 12:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D3560DB4
        for <mm-commits@vger.kernel.org>; Sat,  3 Sep 2022 19:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE16C433D7;
        Sat,  3 Sep 2022 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662234157;
        bh=nZRcNgp6eK8LsGeJoE8jUkkY8iRQD4LSy+1Ty7NT6jw=;
        h=Date:To:From:Subject:From;
        b=0Emxydm9C0MWHfUlLqcyTW4WYEciV+UqN/94tQAhte+dn5qD9U08O9rA57l0/v/yu
         RJknBuHS2eAHuSPKuzxSq4YrW+sMZnhwaqwQTU1JnNJ2/dhB94ZKuBs+fxw1tB6JnP
         OZOj50z6fMyNyEbuAaMLtvZX7nq/qS6UFLxUk2vg=
Date:   Sat, 03 Sep 2022 12:42:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-add-swap_cache_get_folio-fix.patch added to mm-hotfixes-stable branch
Message-Id: <20220903194237.2EE16C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-swap_cache_get_folio-fix
has been added to the -mm mm-hotfixes-stable branch.  Its filename is
     swap-add-swap_cache_get_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-add-swap_cache_get_folio-fix.patch

This patch will later appear in the mm-hotfixes-stable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-add-swap_cache_get_folio-fix
Date: Sat Sep  3 12:35:09 PM PDT 2022

add CONFIG_SWAP=n stub for swap_cache_get_folio()

Reported-by: kernel test robot <lkp@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swap.h~swap-add-swap_cache_get_folio-fix
+++ a/mm/swap.h
@@ -101,6 +101,12 @@ static inline int swap_writepage(struct
 	return 0;
 }
 
+static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	return NULL;
+}
+
 static inline struct page *lookup_swap_cache(swp_entry_t swp,
 					     struct vm_area_struct *vma,
 					     unsigned long addr)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

