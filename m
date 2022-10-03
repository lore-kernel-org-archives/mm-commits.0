Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D2DC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiJCVPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiJCVOH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45A72679
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46154B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33A2C433D6;
        Mon,  3 Oct 2022 21:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831375;
        bh=533v+bENYc0li8ihzWSOBbs/gQg1LhLln/pB6KxmW5s=;
        h=Date:To:From:Subject:From;
        b=uLlaeGFMbYVDTb8IPVKYHAVMnI3ChEswLvEhwhvLtEZglVdlvMF81NpTgJlv/dmoK
         DVRsnpuMRky84IoZOgACot/DBh4g7mCp4sK+ZvUrHGtcYeKip19q/NyUjNRO4CRt/L
         APgiw5wNkLWzf8r402ZqywjQoOPRjzhOa2PU58xw=
Date:   Mon, 03 Oct 2022 14:09:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch removed from -mm tree
Message-Id: <20221003210934.E33A2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: add missing is_migrate_isolate() check in set_page_guard()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: add missing is_migrate_isolate() check in set_page_guard()
Date: Fri, 16 Sep 2022 15:22:49 +0800

In MIGRATE_ISOLATE case, zone freepage state shouldn't be modified as
caller will take care of it.  Add missing is_migrate_isolate() here to
avoid possible unbalanced freepage state.  This would happen if someone
isolates the block, and then we face an MCE failure/soft-offline on a page
within that block.  __mod_zone_freepage_state() will be triggered via
below call trace which already had been triggered back when block was
isolated:

take_page_off_buddy
  break_down_buddy_pages
    set_page_guard

Link: https://lkml.kernel.org/r/20220916072257.9639-9-linmiaohe@huawei.com
Fixes: 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard
+++ a/mm/page_alloc.c
@@ -873,7 +873,8 @@ static inline bool set_page_guard(struct
 	INIT_LIST_HEAD(&page->buddy_list);
 	set_page_private(page, order);
 	/* Guard pages are not available for any usage */
-	__mod_zone_freepage_state(zone, -(1 << order), migratetype);
+	if (!is_migrate_isolate(migratetype))
+		__mod_zone_freepage_state(zone, -(1 << order), migratetype);
 
 	return true;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


