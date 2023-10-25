Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F32AC25B71
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjJYXtf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjJYXss (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC849194
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6820DC433C8;
        Wed, 25 Oct 2023 23:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277725;
        bh=/LA9JOPZJ3XaHyRFNn2rvMg+41MyNQAMwEMLSFGoW6Y=;
        h=Date:To:From:Subject:From;
        b=NBiPC6t4Bvv9T2pJHayP8UbxSCU93tE4fkjLOTzsS5uU+lX3r3kb+fy20cffBiof+
         kLjqhNUlEM74eoyVFvJ/N98oFjn0YWR7mH6eUA80KG0v6JbMK+m4MqQVx9x5Jm7bnK
         dnhUT/W2JvOS0dTQs236v46hIIxNvdtmJZc/H7vI=
Date:   Wed, 25 Oct 2023 16:48:44 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch removed from -mm tree
Message-Id: <20231025234845.6820DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: use folio_xchg_last_cpupid() in folio_migrate_flags()
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: migrate: use folio_xchg_last_cpupid() in folio_migrate_flags()
Date: Wed, 18 Oct 2023 22:08:01 +0800

Convert to use folio_xchg_last_cpupid() in folio_migrate_flags(), also
directly use folio_nid() instead of page_to_nid(&folio->page).

Link: https://lkml.kernel.org/r/20231018140806.2783514-15-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags
+++ a/mm/migrate.c
@@ -588,20 +588,20 @@ void folio_migrate_flags(struct folio *n
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.
 	 */
-	cpupid = page_cpupid_xchg_last(&folio->page, -1);
+	cpupid = folio_xchg_last_cpupid(folio, -1);
 	/*
 	 * For memory tiering mode, when migrate between slow and fast
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
 	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) {
-		bool f_toptier = node_is_toptier(page_to_nid(&folio->page));
-		bool t_toptier = node_is_toptier(page_to_nid(&newfolio->page));
+		bool f_toptier = node_is_toptier(folio_nid(folio));
+		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
 		if (f_toptier != t_toptier)
 			cpupid = -1;
 	}
-	page_cpupid_xchg_last(&newfolio->page, cpupid);
+	folio_xchg_last_cpupid(newfolio, cpupid);
 
 	folio_migrate_ksm(newfolio, folio);
 	/*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


