Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF0FC636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39907613D7
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 18:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbhGOS5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 14:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240871AbhGOS4x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9AED613DA;
        Thu, 15 Jul 2021 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626375239;
        bh=sGEIbcWqKG5K6CxG3qKa7krDczYBTNyamsRWfKnzIoE=;
        h=Date:From:To:Subject:From;
        b=NLQEvFKLp95VHMH6a1uHUSaGgbbsc0JkOKuCxhSdNL4CXQOh2V345qZmtqFBzTo4D
         mCcr2d0fozaRksGpP+HxsCXa2qH7bxi/w3kcCSqDtACCb11wulYP0gsRqSxw1D0F91
         BSrmAB9w40AScty40GtevZM7tiqIuuHHmIQdn/h0=
Date:   Thu, 15 Jul 2021 11:53:59 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-vmstat-simplify-the-array-size-calculation.patch
 added to -mm tree
Message-ID: <20210715185359.wfkpK3XFa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: simplify the array size calculation
has been added to the -mm tree.  Its filename is
     mm-vmstat-simplify-the-array-size-calculation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-simplify-the-array-size-calculation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-simplify-the-array-size-calculation.patch

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
Subject: mm/vmstat: simplify the array size calculation

We can replace the array_num * sizeof(array[0]) with sizeof(array) to
simplify the code.

Link: https://lkml.kernel.org/r/20210715122911.15700-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-simplify-the-array-size-calculation
+++ a/mm/vmstat.c
@@ -1889,17 +1889,15 @@ static bool need_update(int cpu)
 		/*
 		 * The fast way of checking if there are any vmstat diffs.
 		 */
-		if (memchr_inv(pzstats->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS *
-			       sizeof(pzstats->vm_stat_diff[0])))
+		if (memchr_inv(pzstats->vm_stat_diff, 0, sizeof(pzstats->vm_stat_diff)))
 			return true;
 
 		if (last_pgdat == zone->zone_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
 		n = per_cpu_ptr(zone->zone_pgdat->per_cpu_nodestats, cpu);
-		if (memchr_inv(n->vm_node_stat_diff, 0, NR_VM_NODE_STAT_ITEMS *
-			       sizeof(n->vm_node_stat_diff[0])))
-		    return true;
+		if (memchr_inv(n->vm_node_stat_diff, 0, sizeof(n->vm_node_stat_diff)))
+			return true;
 	}
 	return false;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

