Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEF8ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiH0WJQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiH0WJP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:09:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D27133E32
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1089FB807E8
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7631C433D6;
        Sat, 27 Aug 2022 22:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661638150;
        bh=XM4YOeGACYoUg+8PUBtV3y/oZjAa0xaZ3rb0MNgxZ3k=;
        h=Date:To:From:Subject:From;
        b=XsHPYmGhMKVXHFCorYo2CZ17wS4YI0L3dDR9+ChMNBlSgjtCcTr65vDHfEIH0dB2w
         Zhnoc+JYTznVaOxQM64YW16X9bcEGdJaqlkSMQa1/qpADJcpSzWqSjRL7Uq6lGg3Aj
         DhjJ7IVDdA3jRDRhFEy8HyefQT1eG2j8KoMGyVNA=
Date:   Sat, 27 Aug 2022 15:09:10 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch added to mm-unstable branch
Message-Id: <20220827220910.B7631C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-null-ptr-deref-in-kswapd_is_running-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-null-ptr-deref-in-kswapd_is_running-fix
Date: Sat Aug 27 03:04:21 PM PDT 2022

add comments

Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    1 +
 mm/compaction.c                |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/include/linux/memory_hotplug.h~mm-fix-null-ptr-deref-in-kswapd_is_running-fix
+++ a/include/linux/memory_hotplug.h
@@ -215,6 +215,7 @@ void put_online_mems(void);
 void mem_hotplug_begin(void);
 void mem_hotplug_done(void);
 
+/* See kswapd_is_running() */
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat)
 {
 	mutex_lock(&pgdat->kswapd_lock);
--- a/mm/compaction.c~mm-fix-null-ptr-deref-in-kswapd_is_running-fix
+++ a/mm/compaction.c
@@ -1980,6 +1980,12 @@ static inline bool is_via_compact_memory
 	return order == -1;
 }
 
+/*
+ * Determine whether kswapd is (or recently was!) running on this node.
+ *
+ * pgdat_kswapd_lock() pins pgdat->kswapd, so a concurrent kswapd_stop() can't
+ * zero it.
+ */
 static bool kswapd_is_running(pg_data_t *pgdat)
 {
 	bool running;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

