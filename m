Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54C7C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiBGVAi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiBGVA0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE348C043180
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42B8361565
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ECFC340EE;
        Mon,  7 Feb 2022 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267624;
        bh=1gcc7gMZC2CtSoOj5yPHSFsfiSSxGn2YlyqalcXIbpM=;
        h=Date:To:From:Subject:From;
        b=1B2LQqJQdED7uyiuSqCdJvmoKMt195laCbiU7B5uFEH1XX/zVCKbrr4c4I2lk3Rcs
         YMdrWkPoGjofP8hAk7bGgpCLbF/DLE+kwgc1Z2iudQ+9V+HFgd3oNEXv0mUZncnkHM
         EvUKx1+gjrrMdHd5qX99QOWQPnAHnIIriKnL0Y6k=
Date:   Mon, 07 Feb 2022 13:00:24 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch added to -mm tree
Message-Id: <20220207210024.96ECFC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: avoid calling zone_intersects() for ZONE_NORMAL
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch

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
Subject: mm/memory_hotplug: avoid calling zone_intersects() for ZONE_NORMAL

If zid reaches ZONE_NORMAL, the caller will always get the NORMAL zone no
matter what zone_intersects() returns.  So we can save some possible cpu
cycles by avoid calling zone_intersects() for ZONE_NORMAL.

Link: https://lkml.kernel.org/r/20220207133643.23427-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal
+++ a/mm/memory_hotplug.c
@@ -823,7 +823,7 @@ static struct zone *default_kernel_zone_
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	int zid;
 
-	for (zid = 0; zid <= ZONE_NORMAL; zid++) {
+	for (zid = 0; zid < ZONE_NORMAL; zid++) {
 		struct zone *zone = &pgdat->node_zones[zid];
 
 		if (zone_intersects(zone, start_pfn, nr_pages))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

