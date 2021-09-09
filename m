Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0892FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E555A61186
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348026AbhIIVDy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348224AbhIIVDO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EECD611B0;
        Thu,  9 Sep 2021 21:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221324;
        bh=dlkIuHyX/KR38ywhIwXi/mBJcylrymAMD5qhjDDn2dk=;
        h=Date:From:To:Subject:From;
        b=x4zJ0GNRaA+P9m95KJeYoXd36PwbBiYf+MFwGYtmxgTv/3wtTfft+UuULH9llVfor
         Nz8HqVCCms3A1uE0GmsO+hmcpM5BVxH8h8YaDNgxPyl2aNmjeNT9L0lVvw3dRYkcan
         LlGkShCApZ0fw6z8xVs9N1R/x8+2RWlISQTUILeU=
Date:   Thu, 09 Sep 2021 14:02:04 -0700
From:   akpm@linux-foundation.org
To:     cgoldswo@codeaurora.org, david@redhat.com, linmiaohe@huawei.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de
Subject:  [merged]
 mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
 removed from -mm tree
Message-ID: <20210909210204.8g1255fCl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: use helper zone_is_zone_device() to simplify the code
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: use helper zone_is_zone_device() to simplify the code

Patch series "Cleanup and fixups for memory hotplug".

This series contains cleanup to use helper function to simplify the code. 
Also we fix some potential bugs.  More details can be found in the
respective changelogs.


This patch (of 3):

Use helper zone_is_zone_device() to simplify the code and remove some
explicit CONFIG_ZONE_DEVICE codes.

Link: https://lkml.kernel.org/r/20210821094246.10149-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210821094246.10149-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code
+++ a/mm/memory_hotplug.c
@@ -477,15 +477,13 @@ void __ref remove_pfn_range_from_zone(st
 				 sizeof(struct page) * cur_nr_pages);
 	}
 
-#ifdef CONFIG_ZONE_DEVICE
 	/*
 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
 	 * we will not try to shrink the zones - which is okay as
 	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
 	 */
-	if (zone_idx(zone) == ZONE_DEVICE)
+	if (zone_is_zone_device(zone))
 		return;
-#endif
 
 	clear_zone_contiguous(zone);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

