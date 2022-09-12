Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513A7C6FA90
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiILDgD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiILDdx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B3C2A40A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02F79B80C74
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2C1C433D6;
        Mon, 12 Sep 2022 03:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953450;
        bh=fGsJlwZPMRuCTJlFnX2a/BDGFl3LqbmFHypt45/RUfo=;
        h=Date:To:From:Subject:From;
        b=fxvSP4OYqbeDOU9De4tt3K+yZ4bOTul8wMWH1HeYfiyzkpOOMECXs9Efym4ozX6+o
         aY443giVOALlxZzWq+0PGT4+twSo6P1uWBpHqS0mYG+5gMeBk24od5oHR+gqp4G52Z
         rCy8TUH0q3clGJEJ+R+wMqhD+QzZLMK232XCfWHI=
Date:   Sun, 11 Sep 2022 20:30:49 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-meaningless-bug_onhuge_pte_none.patch removed from -mm tree
Message-Id: <20220912033050.9C2C1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: remove meaningless BUG_ON(huge_pte_none())
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-meaningless-bug_onhuge_pte_none.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb: remove meaningless BUG_ON(huge_pte_none())
Date: Thu, 1 Sep 2022 20:00:29 +0800

When code reaches here, invalid page would have been accessed if huge pte
is none. So this BUG_ON(huge_pte_none()) is meaningless. Remove it.

Link: https://lkml.kernel.org/r/20220901120030.63318-10-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-remove-meaningless-bug_onhuge_pte_none
+++ a/mm/hugetlb.c
@@ -5345,7 +5345,6 @@ retry_avoidcopy:
 			u32 hash;
 
 			put_page(old_page);
-			BUG_ON(huge_pte_none(pte));
 			/*
 			 * Drop hugetlb_fault_mutex and i_mmap_rwsem before
 			 * unmapping.  unmapping needs to hold i_mmap_rwsem
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

