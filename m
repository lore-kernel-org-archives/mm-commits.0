Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABDCC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 887D360E52
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347421AbhIHC5E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347501AbhIHC5A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FEA061130;
        Wed,  8 Sep 2021 02:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069753;
        bh=ewXa0RanqjixjCBvH2IkyasRu5A3WH8TIhA/Swfc8cs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AOxBApxBGgO2m5Y180p70qDLM0f5kwJ2uDuP1qLOCdqD3A3exgEAhsm7bj0c8Xdi5
         30lkvInw5PSRSoRtu4tCtv9jU7eX+Oa8l+9YNsgBeg2V3W7/p5NfCInSGLxeLNZAVp
         SYIDKzjND+Cu8pC+2G79u7mwkWpGsbCX8+cAXm+Q=
Date:   Tue, 07 Sep 2021 19:55:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cgoldswo@codeaurora.org,
        david@redhat.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 051/147] mm/memory_hotplug: use helper
 zone_is_zone_device() to simplify the code
Message-ID: <20210908025552.bchKUhGGF%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
