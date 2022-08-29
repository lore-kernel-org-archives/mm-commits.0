Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D843CECAAD2
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 21:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiH2VBU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 17:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiH2VBS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 17:01:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA5579A6B
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 14:01:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA96C6105D
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 21:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1160FC433C1;
        Mon, 29 Aug 2022 21:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661806876;
        bh=/3BAF1lMzlkz/aEinfqyGq1N8hQhzzuLb6tPMLNOSls=;
        h=Date:To:From:Subject:From;
        b=nbRliAQaaDTkmq3TH88XI6wUoo0jLycVBkdBzS3n9wAmCGOtz4SIjxUU1eUdzGFgg
         /IfWNva2h/YcVL7x1FuzqpNaadZxaVn2B/rYBeeQ+zYyQO2s5HkxaxxB+jrCI581FU
         ByshVwu+JLwQDNQ0qY6xFL/G0r6rx84GrV/UqGPI=
Date:   Mon, 29 Aug 2022 14:01:15 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-expose-memory-tier-details-via-sysfs-fix.patch added to mm-unstable branch
Message-Id: <20220829210116.1160FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-demotion-expose-memory-tier-details-via-sysfs-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-expose-memory-tier-details-via-sysfs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-expose-memory-tier-details-via-sysfs-fix.patch

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
Subject: mm-demotion-expose-memory-tier-details-via-sysfs-fix
Date: Mon Aug 29 01:50:42 PM PDT 2022

switch to_memory_tier() from macro to static inline

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory-tiers.c~mm-demotion-expose-memory-tier-details-via-sysfs-fix
+++ a/mm/memory-tiers.c
@@ -38,7 +38,11 @@ static LIST_HEAD(memory_tiers);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 static struct memory_dev_type *default_dram_type;
 
-#define to_memory_tier(device) container_of(device, struct memory_tier, dev)
+static inline struct memory_tier *to_memory_tier(struct device *device)
+{
+	return container_of(device, struct memory_tier, dev);
+}
+
 static struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
 	.dev_name = "memory_tier",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-demotion-expose-memory-tier-details-via-sysfs-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

