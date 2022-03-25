Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A9CC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357468AbiCYBg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357465AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0991AC12DA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8130760AD1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85CAC340EC;
        Fri, 25 Mar 2022 01:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171965;
        bh=XzpGHRoEmEAI0OhD2j912hLeLzQHvhP71fkR2NWWhec=;
        h=Date:To:From:Subject:From;
        b=WjrUPIUTuDmor8PMg4q74BTraJW+jSipu8hNhm/YicRW4oayKeL1wRpGKISfKyr3G
         c9y+UPokxe0ssEvI/hmdW/s/Umwi+UfZL+RSMaUcK7rm4SI2FCFRLTyjs0NWbbK2e0
         Bn/8Aez7kQdspX2I1R+rYuMDcFEDRupSZOxKV0PE=
Date:   Thu, 24 Mar 2022 18:32:45 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch removed from -mm tree
Message-Id: <20220325013245.D85CAC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix misplaced comment in offline_pages
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: fix misplaced comment in offline_pages

It's misplaced since commit 7960509329c2 ("mm, memory_hotplug: print
reason for the offlining failure").  Move it to the right place.

Link: https://lkml.kernel.org/r/20220207133643.23427-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
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

mm-huge_memory-make-is_transparent_hugepage-static.patch

