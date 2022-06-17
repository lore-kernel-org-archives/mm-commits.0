Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3669ACCA47E
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379816AbiFQCtt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379819AbiFQCtl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6246D6542D
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B4F61D23
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5570EC34114;
        Fri, 17 Jun 2022 02:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434177;
        bh=fz/XMzS4m9e62/9myuq/GXnBiRDBrm8vXOZayxicN8U=;
        h=Date:To:From:Subject:From;
        b=QXFBIkjTK7fZ3uRuMIxdHi3au1+hhm7iZAcf11/ZNJ41busd86B8RZljoBTTg6GaZ
         M1p1a+glKaDdleoblDqF9CKaHfFnFbbCHrHTc/8bXm4eDoO1fT5JamNXp761gNOrKk
         CYDnktXkTNlRBUaXIt0iRArdluAKB1dTuukeN0u0=
Date:   Thu, 16 Jun 2022 19:49:36 -0700
To:     mm-commits@vger.kernel.org, dan.j.williams@intel.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch removed from -mm tree
Message-Id: <20220617024937.5570EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memremap: fix memunmap_pages() race with get_dev_pagemap()
has been removed from the -mm tree.  Its filename was
     mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memremap: fix memunmap_pages() race with get_dev_pagemap()
Date: Thu, 9 Jun 2022 20:13:05 +0800

Think about the below scene:

 CPU1			CPU2
 memunmap_pages
   percpu_ref_exit
     __percpu_ref_exit
       free_percpu(percpu_count);
         /* percpu_count is freed here! */
			 get_dev_pagemap
			   xa_load(&pgmap_array, PHYS_PFN(phys))
			     /* pgmap still in the pgmap_array */
			   percpu_ref_tryget_live(&pgmap->ref)
			     if __ref_is_percpu
			       /* __PERCPU_REF_ATOMIC_DEAD not set yet */
			       this_cpu_inc(*percpu_count)
			         /* access freed percpu_count here! */
      ref->percpu_count_ptr = __PERCPU_REF_ATOMIC_DEAD;
        /* too late... */
   pageunmap_range

To fix the issue, do percpu_ref_exit() after pgmap_array is emptied. So
we won't do percpu_ref_tryget_live() against a being freed percpu_ref.

Link: https://lkml.kernel.org/r/20220609121305.2508-1-linmiaohe@huawei.com
Fixes: b7b3c01b1915 ("mm/memremap_pages: support multiple ranges per invocation")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memremap.c~mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap
+++ a/mm/memremap.c
@@ -141,10 +141,10 @@ void memunmap_pages(struct dev_pagemap *
 	for (i = 0; i < pgmap->nr_range; i++)
 		percpu_ref_put_many(&pgmap->ref, pfn_len(pgmap, i));
 	wait_for_completion(&pgmap->done);
-	percpu_ref_exit(&pgmap->ref);
 
 	for (i = 0; i < pgmap->nr_range; i++)
 		pageunmap_range(pgmap, i);
+	percpu_ref_exit(&pgmap->ref);
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
 	devmap_managed_enable_put(pgmap);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

