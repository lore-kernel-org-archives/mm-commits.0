Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63A1C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87194206E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595551673;
	bh=1kRZ/lgw7Qg9JmHVgy1+bdEiFE0bDg4hgROqDsWCe7E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QjCn2gQQV9eRGON1BDG3abm8CC8fySGX4lC3kd52RpfYk98lZ4Th+5utjwRXY33ii
	 3uQMPyJnWVdbgYKaiL9cE1DgFczN0p+NLiy8w6OmguqJCMR6OrUXN4o/qPvAOqGnWE
	 WAtGzD9z1gId6bYUzRjNG41piEg2A3NhL84EgIhc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgGXArx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 20:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgGXArx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 20:47:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E431220737;
        Fri, 24 Jul 2020 00:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595551672;
        bh=1kRZ/lgw7Qg9JmHVgy1+bdEiFE0bDg4hgROqDsWCe7E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UbNRfAvDGFEQmOd9gcLXcwTPVmB93LlLN4eFnwW7ASzJYLmMvKKhTlLgXfiQyvddF
         Dk/U7JN7LU4WSLZXGH9FLYDD+F2fJKWIuskaZIMJ+PBnqSTOclmL4XIJz6+CMPla8D
         3ZtcmdmI/TA/skHUuE0e20UWXvWv/SguZ74la/VU=
Date:   Thu, 23 Jul 2020 17:47:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  +
 mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch added to
 -mm tree
Message-ID: <20200724004751.rZkaijgAk%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: restore active/inactive ratio for anonymous LRU
has been added to the -mm tree.  Its filename is
     mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/vmscan: restore active/inactive ratio for anonymous LRU

Now that workingset detection is implemented for anonymous LRU, we don't
need large inactive list to allow detecting frequently accessed pages
before they are reclaimed, anymore.  This effectively reverts the
temporary measure put in by commit "mm/vmscan: make active/inactive ratio
as 1:1 for anon lru".

Link: http://lkml.kernel.org/r/1595490560-15117-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru
+++ a/mm/vmscan.c
@@ -2207,7 +2207,7 @@ static bool inactive_is_low(struct lruve
 	active = lruvec_page_state(lruvec, NR_LRU_BASE + active_lru);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
-	if (gb && is_file_lru(inactive_lru))
+	if (gb)
 		inactive_ratio = int_sqrt(10 * gb);
 	else
 		inactive_ratio = 1;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmscan-make-active-inactive-ratio-as-1-1-for-anon-lru.patch
mm-vmscan-protect-the-workingset-on-anonymous-lru.patch
mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
mm-swapcache-support-to-handle-the-shadow-entries.patch
mm-swap-implement-workingset-detection-for-anonymous-lru.patch
mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

