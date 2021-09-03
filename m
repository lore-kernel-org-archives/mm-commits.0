Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F13C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC2C0610C8
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350017AbhICVCn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350002AbhICVCn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E7AA60E8B;
        Fri,  3 Sep 2021 21:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702902;
        bh=qHKffjrkN9YnM50tHr8xlW3ZBYoPnqBwYofTR1haVZ8=;
        h=Date:From:To:Subject:From;
        b=wHL14C4axeAwqSViRejMU/DA22CuWPx0ky9QzW9f56eI/jCjT6mfsxN87BpMQLwey
         b3KdxFGVbvi86e5dFzHCK0sDtcuZYgCZb842R8R49c1RqwaenrM1Q46rUunlwKcJ3E
         tDN8qTdJ79eqajesjhcLWZmmyAEftE0vwGovRknE=
Date:   Fri, 03 Sep 2021 14:01:42 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] mm-vmstat-correct-some-wrong-comments.patch
 removed from -mm tree
Message-ID: <20210903210142.cqnTUUaEX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: correct some wrong comments
has been removed from the -mm tree.  Its filename was
     mm-vmstat-correct-some-wrong-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmstat: correct some wrong comments

Patch series "Cleanup for vmstat".

This series contains cleanups to remove unneeded return value, correct
wrong comment and simplify the array size calculation.  More details can
be found in the respective changelogs.


This patch (of 3):

Correct wrong fls(mem+1) to fls(mem)+1 and remove the duplicated comment
with quiet_vmstat().

Link: https://lkml.kernel.org/r/20210715122911.15700-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210715122911.15700-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-correct-some-wrong-comments
+++ a/mm/vmstat.c
@@ -204,7 +204,7 @@ int calculate_normal_threshold(struct zo
 	 *
 	 * Some sample thresholds:
 	 *
-	 * Threshold	Processors	(fls)	Zonesize	fls(mem+1)
+	 * Threshold	Processors	(fls)	Zonesize	fls(mem)+1
 	 * ------------------------------------------------------------------
 	 * 8		1		1	0.9-1 GB	4
 	 * 16		2		2	0.9-1 GB	4
@@ -1876,11 +1876,6 @@ static void vmstat_update(struct work_st
 }
 
 /*
- * Switch off vmstat processing and then fold all the remaining differentials
- * until the diffs stay at zero. The function is used by NOHZ and can only be
- * invoked when tick processing is not active.
- */
-/*
  * Check if the diffs for a certain cpu indicate that
  * an update is needed.
  */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

