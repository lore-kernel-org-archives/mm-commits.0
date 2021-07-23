Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F03C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 882E960F25
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 20:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhGWThd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGWThd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 15:37:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E546160ED7;
        Fri, 23 Jul 2021 20:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627071486;
        bh=OcBq9e9G0Z8x2FLb+Bx383WQ8jEVR/IXF9JuIdVJzgc=;
        h=Date:From:To:Subject:From;
        b=b6LRnl98JX2vDREa836sRJ4fiVewsyHanPcZXzHyiZdWepvtnyrxfvN82u5AwdOBr
         59T+lKqEhVOzx7iX8TxrSqKFn1R2QuyvFaxVzMuHWj0/SsRpn8W/ZfsSX+LUmjdmxY
         v/hAwqj3FMFMCPsVeWKOX3DcO87VRLdoQ2BPF2Q4=
Date:   Fri, 23 Jul 2021 13:18:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        minchan@kernel.org, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org,
        david@redhat.com, ying.huang@intel.com
Subject:  + mmshmem-fix-a-typo-in-shmem_swapin_page.patch added to
 -mm tree
Message-ID: <20210723201804.3htPA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,shmem: Fix a typo in shmem_swapin_page()
has been added to the -mm tree.  Its filename is
     mmshmem-fix-a-typo-in-shmem_swapin_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmshmem-fix-a-typo-in-shmem_swapin_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmshmem-fix-a-typo-in-shmem_swapin_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm,shmem: Fix a typo in shmem_swapin_page()

"-" is missing before "EINVAL".

Link: https://lkml.kernel.org/r/20210723080000.93953-1-ying.huang@intel.com
Fixes: 2efa33fc7f6e ("mm/shmem: fix shmem_swapin() race with swapoff")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mmshmem-fix-a-typo-in-shmem_swapin_page
+++ a/mm/shmem.c
@@ -1708,7 +1708,7 @@ static int shmem_swapin_page(struct inod
 	/* Prevent swapoff from happening to us. */
 	si = get_swap_device(swap);
 	if (!si) {
-		error = EINVAL;
+		error = -EINVAL;
 		goto failed;
 	}
 	/* Look it up and read it in.. */
_

Patches currently in -mm which might be from ying.huang@intel.com are

mmshmem-fix-a-typo-in-shmem_swapin_page.patch
mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch
mm-migrate-add-sysfs-interface-to-enable-reclaim-migration.patch

