Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B87FC433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A79461040
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhEJEdV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:33:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhEJEdV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B7961075;
        Mon, 10 May 2021 04:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621137;
        bh=GptW5Nnt4UO4r8VtcYVhWAcyY6yrivmR5L5eycfdhx0=;
        h=Date:From:To:Subject:From;
        b=S5dXrarydAClwE1TUm/9FVDnIvRG7cOCIu0rO3n4z6PXFbhrdk95k1sNJ2TD+k4yA
         NQjK27MEUOt69eLwOjwE4+w2a8TSmeqc7Ia/EOWQQyBe3Ae3HvWKX63gLDPbkQma0U
         42z/XbQoRe9jSVGrPMb78dGj4pRu/W8a9/3CZfG0=
Date:   Sun, 09 May 2021 21:32:16 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
 added to -mm tree
Message-ID: <20210510043216.Al4OvPIQP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: move obj_cgroup_uncharge_pages() out of css_set_lock
has been added to the -mm tree.  Its filename is
     mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: move obj_cgroup_uncharge_pages() out of css_set_lock

The css_set_lock is used to guard the list of inherited objcgs.  So there
is no need to uncharge kernel memory under css_set_lock.  Just move it out
of the lock.

Link: https://lkml.kernel.org/r/20210417043538.9793-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock
+++ a/mm/memcontrol.c
@@ -289,9 +289,10 @@ static void obj_cgroup_release(struct pe
 	WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
 	nr_pages = nr_bytes >> PAGE_SHIFT;
 
-	spin_lock_irqsave(&css_set_lock, flags);
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
+
+	spin_lock_irqsave(&css_set_lock, flags);
 	list_del(&objcg->list);
 	spin_unlock_irqrestore(&css_set_lock, flags);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memcontrol-fix-page-charging-in-page-replacement.patch
mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
mm-memcontrol-simplify-lruvec_holds_page_lru_lock.patch
mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg.patch
mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
mm-vmscan-remove-noinline_for_stack.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch

