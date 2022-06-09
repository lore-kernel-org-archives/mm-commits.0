Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE87C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 17:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiFIRWY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbiFIRWY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 13:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB8C254
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 10:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7458461AC4
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 17:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A38C34114;
        Thu,  9 Jun 2022 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654795341;
        bh=TAL5bc2XPD4sqcQx1TsK/cc9DkmFxBo9Pwu4lhEKAjY=;
        h=Date:To:From:Subject:From;
        b=vbfo5Ouzu6wq4o7gB4wnWUoA+hZ6+hVcgyBeGaUbYJQIzFm59xrD4AYx4hicIXPN6
         Ycg49wG7yIcaz8vHoVL5azMCJcmlA2G73wWwTBrR/StsdNI/JCiJLTUcvg5lqldsnh
         nvSQb2cwexkM22RZcqYQgF6qYbExZmiUuq8c19VY=
Date:   Thu, 09 Jun 2022 10:22:21 -0700
To:     mm-commits@vger.kernel.org, dan.j.williams@intel.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch added to mm-unstable branch
Message-Id: <20220609172221.C6A38C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap: fix memunmap_pages() race with get_dev_pagemap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch

