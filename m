Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D88ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiILAmi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiILAmh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:42:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA7E27CE5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:42:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFC9361154
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D773C433D7;
        Mon, 12 Sep 2022 00:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943356;
        bh=qYhScUzydrgGfUwdsynjGoi5VErGFHJhD6KjjbUR7dw=;
        h=Date:To:From:Subject:From;
        b=kU+JebDUV6wKK+HzH+u9S36MBkyqVdpon5zWiaEw6J3Xj/u6gOLHyuqygvox3neu1
         xDWRBfZe/D0WS2BPRkykoGluHxBIJFlG45XT7aGGMvdBO1A+2USRFsgByx1tj04NiJ
         noTPSrJVUX+PEIX8d4oTsTYx5oQcOLdHuvpRmWGQ=
Date:   Sun, 11 Sep 2022 17:42:35 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-kill-__soft_offline_page-v2.patch removed from -mm tree
Message-Id: <20220912004236.0D773C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memory-failure-kill-__soft_offline_page-v2
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-kill-__soft_offline_page-v2.patch

This patch was dropped because it was folded into mm-memory-failure-kill-__soft_offline_page.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-memory-failure-kill-__soft_offline_page-v2
Date: Tue, 30 Aug 2022 18:46:54 +0800

update hpage when try_to_split_thp_page() succeeds

Link: https://lkml.kernel.org/r/20220830104654.28234-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-memory-failure-kill-__soft_offline_page-v2
+++ a/mm/memory-failure.c
@@ -2456,6 +2456,7 @@ static int soft_offline_in_use_page(stru
 			pr_info("soft offline: %#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
+		hpage = page;
 	}
 
 	lock_page(page);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch
mm-kill-is_memblock_offlined.patch
mm-fix-null-ptr-deref-in-kswapd_is_running.patch
mm-remove-bug_on-in-__isolate_free_page.patch
mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

