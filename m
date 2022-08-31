Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469ADECAAD5
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiHaBZJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiHaBZI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:25:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E833B86F
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C956B81E3B
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3860C433D6;
        Wed, 31 Aug 2022 01:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661909103;
        bh=5m09RI2Xmn6gjovagWbinoRqvJmQBkE1xq5htCqtkjg=;
        h=Date:To:From:Subject:From;
        b=oxjyn5t+3yLj5dMmfAVYfPpiig5iaZGQgLFF2oVsrybeuHnrbkARcQT7BEGk2hSpo
         OZAm91bd6NLO27/VCeJR+WE3c7SrBH0tSJBkFXc/qvnPcETVg7CQP7ehPQvVLYvTvF
         mjdeAB6yOnqb3/aXz50iAjia0ff+zKZQOBaugAzc=
Date:   Tue, 30 Aug 2022 18:25:02 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-kill-__soft_offline_page-v2.patch added to mm-unstable branch
Message-Id: <20220831012503.C3860C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-kill-__soft_offline_page-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-kill-__soft_offline_page-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-kill-__soft_offline_page-v2.patch

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
mm-memory-failure-kill-__soft_offline_page-v2.patch
mm-kill-is_memblock_offlined.patch
mm-fix-null-ptr-deref-in-kswapd_is_running.patch
kernel-exit-cleanup-release_thread.patch

