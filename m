Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734E5C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiBGVA4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiBGVAd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7D3C0401DB
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA41C61565
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44160C340EE;
        Mon,  7 Feb 2022 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267626;
        bh=r44OfG/iUogeHpEWOwssGcr7UM2NgU8vXPUzwCMKIUQ=;
        h=Date:To:From:Subject:From;
        b=tvW2cJbe+AOgD94sMwhfbqcG20U4g+F72Lp2sKJsXFyFoKT2AIa11gQP8TwUoGPvg
         j/gAwyS7rPVmY4svBScYuO1oN/Hs6my9QqyMKRBuJTBvGM95BAlkUVHiF9sYtaDzU/
         6mZhCZFQ2dtmj2woZzUfJ+Q8iDkrgcWVDKEqcOJw=
Date:   Mon, 07 Feb 2022 13:00:25 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch added to -mm tree
Message-Id: <20220207210026.44160C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix misplaced comment in offline_pages
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch

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
Subject: mm/memory_hotplug: fix misplaced comment in offline_pages

It's misplaced since commit 7960509329c2 ("mm, memory_hotplug: print
reason for the offlining failure").  Move it to the right place.

Link: https://lkml.kernel.org/r/20220207133643.23427-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-misplaced-comment-in-offline_pages
+++ a/mm/memory_hotplug.c
@@ -1963,6 +1963,7 @@ int __ref offline_pages(unsigned long st
 	return 0;
 
 failed_removal_isolated:
+	/* pushback to free area */
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
@@ -1973,7 +1974,6 @@ failed_removal:
 		 (unsigned long long) start_pfn << PAGE_SHIFT,
 		 ((unsigned long long) end_pfn << PAGE_SHIFT) - 1,
 		 reason);
-	/* pushback to free area */
 	mem_hotplug_done();
 	return ret;
 }
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

