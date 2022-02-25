Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556C9C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Feb 2022 07:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbiBYHMH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 02:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbiBYHMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 02:12:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC19E17E32
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 23:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A96D61AE0
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 07:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35CEC340E7;
        Fri, 25 Feb 2022 07:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645773093;
        bh=AJP6MctUXatumfQhKoD3L/rslGKrk6bbJhPNIY/RkCA=;
        h=Date:To:From:Subject:From;
        b=Atbp1LRU2ljP1gQFXx/E0n4sDYeA+fJ+2kz1i4ZOGiCpSvE/rdhxBOuB1W3OTDn78
         1pAZmVrmAGQugW0JHbx1ygcgt4dex+hu+Brw5OEhXepXq7QztQclZEMi2n8vO5TZjf
         1naMftTOY/0EcDBFrEOxT3rd9wKjfaj9FPOvQVEM=
Date:   Thu, 24 Feb 2022 23:11:33 -0800
To:     mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch added to -mm tree
Message-Id: <20220225071133.C35CEC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: remove unneeded is_memcg_oom check
has been added to the -mm tree.  Its filename is
     mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/oom_kill: remove unneeded is_memcg_oom check

oom_cpuset_eligible() is always called when !is_memcg_oom().  Remove this
unnecessary check.

Link: https://lkml.kernel.org/r/20220224115933.20154-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-remove-unneeded-is_memcg_oom-check
+++ a/mm/oom_kill.c
@@ -93,9 +93,6 @@ static bool oom_cpuset_eligible(struct t
 	bool ret = false;
 	const nodemask_t *mask = oc->nodemask;
 
-	if (is_memcg_oom(oc))
-		return true;
-
 	rcu_read_lock();
 	for_each_thread(start, tsk) {
 		if (mask) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-use-helper-function-range_in_vma.patch
mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch
mm-hugetlb-use-helper-macro-__attr_rw.patch
mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch
mm-ksm-use-helper-macro-__attr_rw.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch

