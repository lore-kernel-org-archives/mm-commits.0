Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194B6C4338F
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 00:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC576608FB
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 00:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhHDAim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 20:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhHDAil (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 20:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A626360295;
        Wed,  4 Aug 2021 00:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628037509;
        bh=WMAapZVsJlULBzkPJEfRY/rvcR070DXhKR0BL77qZ4Y=;
        h=Date:From:To:Subject:From;
        b=B6Vu3XHup1l+/Xh/hE4LdrbZuV/iIH+8x3Co58Om9PGANVyGGOVb2/zEnKsLyeJ3W
         SduvLE44elWXvVVHjK1TZ2t5kUn1xjgS3TEDtsan5zT46HK5xlWjOli5iLk3rFo6QP
         vmD/42CcASlIZpUuAML/ipEH8hKLPZ5jbE6Wbx+w=
Date:   Tue, 03 Aug 2021 17:38:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        minchan@kernel.org, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hughd@google.com, hannes@cmpxchg.org,
        david@redhat.com, ying.huang@intel.com
Subject:  +
 shmem_swapin_page-fix-error-processing-for-get_swap_device.patch added to -mm
 tree
Message-ID: <20210804003829.rMoWh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem_swapin_page(): fix error processing for get_swap_device()
has been added to the -mm tree.  Its filename is
     shmem_swapin_page-fix-error-processing-for-get_swap_device.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/shmem_swapin_page-fix-error-processing-for-get_swap_device.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/shmem_swapin_page-fix-error-processing-for-get_swap_device.patch

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

shmem_swapin_page-fix-error-processing-for-get_swap_device.patch
mmdo_huge_pmd_numa_page-remove-unnecessary-tlb-flushing-code.patch
mm-migrate-add-sysfs-interface-to-enable-reclaim-migration.patch

