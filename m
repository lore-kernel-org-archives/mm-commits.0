Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05064C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C336060EC0
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhHKBNF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Aug 2021 21:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhHKBNF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Aug 2021 21:13:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 733BB60EDF;
        Wed, 11 Aug 2021 01:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628644362;
        bh=2Uf+ggdp8yZWL70U1yPi3Z+f2IeVu7//w8p29zdc63g=;
        h=Date:From:To:Subject:From;
        b=bG1dv8grfJ3ixbvgd1AMF91S1N2ku3+f8PW2Cuftvd6hgkifZjGmvVgTKL0GQb9VZ
         XdGfhC+wAfdkF3BuWZXn+b+LM15fTSb+ht4wymvaseum+gfjxVJnmujeHnfrQcN4sF
         sJL91JEWHJFqXTgagV8Ik2xVVgOAOayrhoA8s0T0=
Date:   Tue, 10 Aug 2021 18:12:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        minchan@kernel.org, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org,
        david@redhat.com, ying.huang@intel.com
Subject:  [obsolete]
 shmem_swapin_page-fix-error-processing-for-get_swap_device.patch removed from
 -mm tree
Message-ID: <20210811011240.i1CSY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem_swapin_page(): fix error processing for get_swap_device()
has been removed from the -mm tree.  Its filename was
     shmem_swapin_page-fix-error-processing-for-get_swap_device.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: shmem_swapin_page(): fix error processing for get_swap_device()

If we hit this rare race, returning EINVAL (or even -EINVAL) would cause
the page fault to be handled as a SIGBUS.  This is not correct; the page
is not missing or unreadable, it has simply changed location.  Returning
-EEXIST here will cause the lookup to be retried by the caller.

[willy@infradead.org: changelog]
Link: https://lkml.kernel.org/r/20210723080000.93953-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/877dh354vc.fsf@yhuang6-desk2.ccr.corp.intel.com
Fixes: 2efa33fc7f6e ("mm/shmem: fix shmem_swapin() race with swapoff")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~shmem_swapin_page-fix-error-processing-for-get_swap_device
+++ a/mm/shmem.c
@@ -1708,8 +1708,8 @@ static int shmem_swapin_page(struct inod
 	/* Prevent swapoff from happening to us. */
 	si = get_swap_device(swap);
 	if (!si) {
-		error = EINVAL;
-		goto failed;
+		error = -EEXIST;
+		goto unlock;
 	}
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
_

Patches currently in -mm which might be from ying.huang@intel.com are

mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch
mm-migrate-add-sysfs-interface-to-enable-reclaim-migration.patch

