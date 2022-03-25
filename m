Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49B4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243247AbiCYBf6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345845AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AD6C12C6
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC9CCB81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8E8C340ED;
        Fri, 25 Mar 2022 01:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171960;
        bh=2/eys9/bJH8i1o7Hggiq7dXLzaT4mc/hmLYHnCLxoQM=;
        h=Date:To:From:Subject:From;
        b=s4vdFRxsXDKYyX3wl4DlvxvXkuqOLhgUOobFZELQufsOXGzGegOIeXNS1kxdt/tH0
         iaUYuce56jpMltgiYqkIlpHXTuSCW4QydY4CJ9i0/JfmDg3qS3p2ePA2+oMrrVemHU
         g8pwdt9iykYAoqRpAqh2w0veqtNTHKaubhpFnXLA=
Date:   Thu, 24 Mar 2022 18:32:40 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org, osalvador@suse.de,
        mhocko@suse.com, gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch removed from -mm tree
Message-Id: <20220325013240.AB8E8C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: add memory block to memory group after registration succeeded
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory: add memory block to memory group after registration succeeded

If register_memory() fails, we freed the memory block but already added
the memory block to the group list, not good.  Let's defer adding the
block to the memory group to after registering the memory block device.

We do handle it properly during unregister_memory(), but that's not
called when the registration fails.

Link: https://lkml.kernel.org/r/20220128144540.153902-1-david@redhat.com
Fixes: 028fc57a1c36 ("drivers/base/memory: introduce "memory groups" to logically group memory blocks")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded
+++ a/drivers/base/memory.c
@@ -665,14 +665,16 @@ static int init_memory_block(unsigned lo
 	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 	INIT_LIST_HEAD(&mem->group_next);
 
+	ret = register_memory(mem);
+	if (ret)
+		return ret;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);
 	}
 
-	ret = register_memory(mem);
-
-	return ret;
+	return 0;
 }
 
 static int add_memory_block(unsigned long base_section_nr)
_

Patches currently in -mm which might be from david@redhat.com are

mm-optimize-do_wp_page-for-exclusive-pages-in-the-swapcache.patch
mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
mm-streamline-cow-logic-in-do_swap_page.patch
mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch
mm-khugepaged-remove-reuse_swap_page-usage.patch
mm-swapfile-remove-stale-reuse_swap_page.patch
mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch

