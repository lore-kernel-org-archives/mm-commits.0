Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D64ECAAA1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiHaB2C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHaB2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:28:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C64A9CCCB
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07054618A8
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B31AC433C1;
        Wed, 31 Aug 2022 01:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661909280;
        bh=CLD2756Umm+7xBPPC64sJYCHlYfxdNfSQ4ULLaW8gk8=;
        h=Date:To:From:Subject:From;
        b=ZWU2psMvVTmbSIz336oQI9OvRd5uiueXptb/9Q8AXCcP4QhYRXh9dGYCVoAM4MHEF
         mQsZ9OeP+f1g3FBGGEeFnwVHza7PPzQ+iktm3vQJf5RjfQDvqf4nEJA3E0sKkaH18h
         0vrECYKTD43oUMg49NEmpwKyK92B27KuLMlBJGe0=
Date:   Tue, 30 Aug 2022 18:27:59 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com, lkp@intel.com,
        linmiaohe@huawei.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-demotion-expose-memory-tier-details-via-sysfs-fix-2.patch removed from -mm tree
Message-Id: <20220831012800.4B31AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-demotion-expose-memory-tier-details-via-sysfs-fix-2
has been removed from the -mm tree.  Its filename was
     mm-demotion-expose-memory-tier-details-via-sysfs-fix-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-demotion-expose-memory-tier-details-via-sysfs-fix-2
Date: Tue Aug 30 03:14:15 PM PDT 2022

temp build fix

Reported-by: kernel test robot <lkp@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/mm/memory-tiers.c~mm-demotion-expose-memory-tier-details-via-sysfs-fix-2
+++ a/mm/memory-tiers.c
@@ -108,7 +108,20 @@ static int top_tier_adistance;
  *
  */
 static struct demotion_nodes *node_demotion __read_mostly;
-#endif /* CONFIG_MIGRATION */
+
+/* I need a comment too */
+static inline bool i_need_a_name(struct memory_tier *memtier)
+{
+	return memtier->adistance_start >= top_tier_adistance;
+}
+
+#else	/* CONFIG_MIGRATION */
+
+static inline bool i_need_a_name(struct memory_tier *memtier)
+{
+	return false;
+}
+#endif	/* CONFIG_MIGRATION */
 
 static __always_inline nodemask_t get_memtier_nodemask(struct memory_tier *memtier)
 {
@@ -648,7 +661,7 @@ static ssize_t toptier_nodes_show(struct
 
 	mutex_lock(&memory_tier_lock);
 	list_for_each_entry(memtier, &memory_tiers, list) {
-		if (memtier->adistance_start >= top_tier_adistance)
+		if (i_need_a_name(memtier))
 			break;
 		nmask = get_memtier_nodemask(memtier);
 		nodes_or(top_tier_mask, top_tier_mask, nmask);
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

