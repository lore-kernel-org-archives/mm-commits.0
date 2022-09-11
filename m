Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB98FECAAD3
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIKXUp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIKXUo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:20:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CFF24F11
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D742B80B10
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23259C433D7;
        Sun, 11 Sep 2022 23:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938441;
        bh=bJUnPePrFqHXyvqw+5/pB0YtAcD5Di6tnDszo4cdutY=;
        h=Date:To:From:Subject:From;
        b=kWCMTS6yN7V04csBN3MvRACDU35qi0oUFRz8VFVZq3NfWdf55K4ljL20qmhzNRNnR
         mGKeRw51jGvDJUlTvhSplBRN0AWN3wafXw2fTj7/T4vG2A2kCI/IA6Bm11W7xhNBED
         l4w/x1D0yEH7wlploHkIcEbVZ3uE+1o9LcPwX8u0=
Date:   Sun, 11 Sep 2022 16:20:40 -0700
To:     mm-commits@vger.kernel.org, quic_pdaly@quicinc.com,
        mhocko@suse.com, mgorman@techsingularity.net, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch removed from -mm tree
Message-Id: <20220911232041.23259C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch

This patch was dropped because it was folded into mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix
Date: Wed Aug 24 10:26:44 AM PDT 2022

make zonelist_update_seq static

Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Patrick Daly <quic_pdaly@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix
+++ a/mm/page_alloc.c
@@ -4714,7 +4714,7 @@ EXPORT_SYMBOL_GPL(fs_reclaim_release);
  * retries the allocation if zonelist changes. Writer side is protected by the
  * embedded spin_lock.
  */
-DEFINE_SEQLOCK(zonelist_update_seq);
+static DEFINE_SEQLOCK(zonelist_update_seq);
 
 static unsigned int zonelist_iter_begin(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation.patch
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
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
fs-uninline-inode_maybe_inc_iversion.patch

