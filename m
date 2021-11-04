Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA8EC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 22:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD4A60EB4
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 22:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhKDWKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231329AbhKDWKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Nov 2021 18:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7E8E60EB4;
        Thu,  4 Nov 2021 22:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636063654;
        bh=HMMdV+VtyT4J3Tbro4vOhvnq1ZJIlICAHG+ZCyk+S5M=;
        h=Date:From:To:Subject:From;
        b=voG+vdOVyJb0yH98ZHdoAaujNI7G96+OUwJFkPSO187neWzFrHV8drggO7gohtX83
         k20gCH2lMVKOTaIlqjf2ptv3S8Z3HS/BF5VZPBIgtRxpolpRuRPuBcWnxkjr2Pgmy8
         wtQ3IFYIdhlaTJCgOot6E13U7+//2EuswDBkeLCY=
Date:   Thu, 04 Nov 2021 15:07:34 -0700
From:   akpm@linux-foundation.org
To:     cgoldswo@codeaurora.org, linmiaohe@huawei.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [nacked]
 mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
 removed from -mm tree
Message-ID: <20211104220734.kzD7p7iFy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: make HWPoisoned dirty swapcache pages unmovable
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: make HWPoisoned dirty swapcache pages unmovable

HWPoisoned dirty swapcache pages are kept for killing owner processes.  We
should not offline these pages or do_swap_page() would access the offline
pages and lead to bad ending.

Link: https://lkml.kernel.org/r/20210821094246.10149-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable
+++ a/mm/memory_hotplug.c
@@ -1656,6 +1656,12 @@ static int scan_movable_pages(unsigned l
 		 */
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
+		/*
+		 * HWPoisoned dirty swapcache pages are definitely unmovable
+		 * because they are kept for killing owner processes.
+		 */
+		if (PageHWPoison(page) && PageSwapCache(page))
+			return -EBUSY;
 
 		if (!PageHuge(page))
 			continue;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order.patch
mm-page_allocc-simplify-the-code-by-using-macro-k.patch
mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk.patch
mm-page_allocc-use-helper-function-zone_spans_pfn.patch
mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact.patch
mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch
mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

