Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26771ECAAD4
	for <mm-commits@archiver.kernel.org>; Tue, 30 Aug 2022 22:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiH3WXU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 18:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiH3WWu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 18:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E05939B95
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 15:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E72C86113D
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 22:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F4BC433D6;
        Tue, 30 Aug 2022 22:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661898057;
        bh=9TaYy3fapwDSON+jKUYYTfmYej2BBodfjavJzpuq3es=;
        h=Date:To:From:Subject:From;
        b=hNeNhGCx6Bl0CaqlLX8cqTmHFtZAP77iQfyKn+Gzl77m5qkQhITMKvBklOh8kTZ4d
         y++XuqLngcMYml4I8EVVdG6aD+woLZvyiZ3QEt0uQFQKuidT/XdJGShbOHzVaxHnrx
         tptW42Q4Y9XFITpJAU/l1jQ2idFZBY2dhMa3UjZY=
Date:   Tue, 30 Aug 2022 15:20:56 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com, lkp@intel.com,
        linmiaohe@huawei.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-expose-memory-tier-details-via-sysfs-fix-2.patch added to mm-unstable branch
Message-Id: <20220830222057.48F4BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-demotion-expose-memory-tier-details-via-sysfs-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-expose-memory-tier-details-via-sysfs-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-expose-memory-tier-details-via-sysfs-fix-2.patch

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
mm-demotion-expose-memory-tier-details-via-sysfs-fix-2.patch
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

