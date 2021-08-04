Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9580C4320A
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 00:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84BBE60F94
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 00:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhHDAdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 20:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230140AbhHDAdl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 20:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD4060F56;
        Wed,  4 Aug 2021 00:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628037210;
        bh=vrhXKvRswtqEpcQk/JZkR6BCW/vbE4r9Wp6vfiAv8gw=;
        h=Date:From:To:Subject:From;
        b=2dWrZmWlA0/1hvfOOqs03MO6/1Yp7gdbAU7m7cW0aK8dcWRQqG0dIzxkG+SsCKMd7
         J62okhxO19+OdYqiC5I7vE8bK8t/QDAzS+hQk9gISkV4m/9NnB0lAdrCupfWTWWXn8
         PWqDKNbCoIg2HZCTjeLJ6j4NmWLDhlFC74j0iiBo=
Date:   Tue, 03 Aug 2021 17:33:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        minchan@kernel.org, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org,
        david@redhat.com, ying.huang@intel.com
Subject:  [alternative-merged]
 mmshmem-fix-a-typo-in-shmem_swapin_page.patch removed from -mm tree
Message-ID: <20210804003329.k1las%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,shmem: fix a typo in shmem_swapin_page()
has been removed from the -mm tree.  Its filename was
     mmshmem-fix-a-typo-in-shmem_swapin_page.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm,shmem: fix a typo in shmem_swapin_page()

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

mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch
mm-migrate-add-sysfs-interface-to-enable-reclaim-migration.patch

