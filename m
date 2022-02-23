Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BB2C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Feb 2022 04:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiBWEDk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 23:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiBWEDk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 23:03:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE2F6663E
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 20:03:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E669B81E6D
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 04:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC74BC340E7;
        Wed, 23 Feb 2022 04:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645588990;
        bh=yNWMYYS7lJR0L7GdpoK27tN9BzJ5vfljvHu9oG/m1vQ=;
        h=Date:To:From:Subject:From;
        b=ekwIrv5v3aHciHND3N6UCe+Sl74LplnIW1l95jEvlCupuTyWE4S3xvW9biAKg6WnO
         +geXwbmY3Nq9tGTs9Ab4skGon5miImyKb/GzuaT7y/hac48bsfKPqoKck9Wyk9gfuo
         yed5UPwEaYuh12xGMx+4K5r66bFeqce3Aq0EyUDw=
Date:   Tue, 22 Feb 2022 20:03:10 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-helper-macro-__attr_rw.patch added to -mm tree
Message-Id: <20220223040310.BC74BC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use helper macro __ATTR_RW
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-helper-macro-__attr_rw.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-helper-macro-__attr_rw.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-helper-macro-__attr_rw.patch

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
Subject: mm/hugetlb: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define HSTATE_ATTR to make code more clear. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20220222112731.33479-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-macro-__attr_rw
+++ a/mm/hugetlb.c
@@ -3499,8 +3499,7 @@ static int demote_pool_huge_page(struct
 	static struct kobj_attribute _name##_attr = __ATTR_WO(_name)
 
 #define HSTATE_ATTR(_name) \
-	static struct kobj_attribute _name##_attr = \
-		__ATTR(_name, 0644, _name##_show, _name##_store)
+	static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 static struct kobject *hugepages_kobj;
 static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-use-helper-function-range_in_vma.patch
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
mm-ksm-use-helper-macro-__attr_rw.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch

