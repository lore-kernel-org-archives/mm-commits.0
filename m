Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0947C3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 19:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbiHXTmX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 15:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHXTmV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 15:42:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE187697C
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 12:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 750BA617E6
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 19:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA277C433C1;
        Wed, 24 Aug 2022 19:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661370139;
        bh=bWkMmPMz5oHCPQKLegxdf6OtEpy0e+KDhXOp82oQUjY=;
        h=Date:To:From:Subject:From;
        b=eJrD2absef2mHpEJ//H1rgvy7nLXBH+BKNkV3v4Upg09fG6va+oGCqDVkmPVf5Rmg
         Cc+t8Z5qz34zzKlAxp2nvLA/MZEGKZ/aJDjCwir63JNubViluua5WN5Mlduc2dHkv/
         gEUvQ5MH+7QIQrDhI0oHs85MttZSb3ziooXq+O78=
Date:   Wed, 24 Aug 2022 12:42:18 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs.patch removed from -mm tree
Message-Id: <20220824194219.BA277C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: fix possible use-after-free in mf_dax_kill_procs()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: fix possible use-after-free in mf_dax_kill_procs()
Date: Thu, 18 Aug 2022 21:00:14 +0800

After kill_procs(), tk will be freed without being removed from the
to_kill list.  In the next iteration, the freed list entry in the to_kill
list will be accessed, thus leading to use-after-free issue.  Fix it by
reinitializing the to_kill list after unmap_and_kill().

Link: https://lkml.kernel.org/r/20220818130016.45313-5-linmiaohe@huawei.com
Fixes: c36e20249571 ("mm: introduce mf_dax_kill_procs() for fsdax case")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs
+++ a/mm/memory-failure.c
@@ -1658,6 +1658,8 @@ int mf_dax_kill_procs(struct address_spa
 		collect_procs_fsdax(page, mapping, index, &to_kill);
 		unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
 				index, mf_flags);
+		/* Reinitialize to_kill list for later resuing. */
+		INIT_LIST_HEAD(&to_kill);
 unlock:
 		dax_unlock_mapping_entry(mapping, index, cookie);
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch

