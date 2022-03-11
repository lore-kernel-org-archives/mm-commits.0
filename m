Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EFEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 02:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiCKCSr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 21:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237868AbiCKCSr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 21:18:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0B23818D
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 18:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4964E61E7F
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 02:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7B1C340E8;
        Fri, 11 Mar 2022 02:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646965063;
        bh=wEDMg52d1xXFPIcaU/fBm8jdiLiQP1VDPKlgKrsCjeM=;
        h=Date:To:From:Subject:From;
        b=DI7sSDlwv9VZPbSJz9D3JoQMlMayFx0MZxzcBX6vu0J6bN6jU/FT9QPnUhFBRiO+h
         0usWmZ3pl6IsNUdBNCjdTIzhyI7QUv7x2+tFIVTkxdAyiQPGTHAB7eaUhXs0tGMxcn
         FatFiqqW4VmmYODTgRZpkMhSV6H14BizN+Jh9UR4=
Date:   Thu, 10 Mar 2022 18:17:42 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com,
        herbert.van.den.bergh@oracle.com, chris.mason@oracle.com,
        akpm@linux-foundation.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch added to -mm tree
Message-Id: <20220311021743.9D7B1C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: fix potential imbalanced rlimit ucounts adjustment
has been added to the -mm tree.  Its filename is
     mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch

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
Subject: mm/mlock: fix potential imbalanced rlimit ucounts adjustment

user_shm_lock forgets to set allowed to 0 when get_ucounts fails. So
the later user_shm_unlock might do the extra dec_rlimit_ucounts. Fix
this by resetting allowed to 0.

Link: https://lkml.kernel.org/r/20220310132417.41189-1-linmiaohe@huawei.com
Fixes: 5ed44a401ddf ("do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mlock.c~mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment
+++ a/mm/mlock.c
@@ -839,6 +839,7 @@ int user_shm_lock(size_t size, struct uc
 	}
 	if (!get_ucounts(ucounts)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
+		allowed = 0;
 		goto out;
 	}
 	allowed = 1;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch
mm-use-helper-function-range_in_vma.patch
mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch
mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch
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
mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch
mm-hugetlb-use-helper-macro-__attr_rw.patch
mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch
mm-ksm-use-helper-macro-__attr_rw.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch
mm-huge_memory-make-is_transparent_hugepage-static.patch

