Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7384C43460
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D973610C9
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhEJEdK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhEJEdJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9683610F8;
        Mon, 10 May 2021 04:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621125;
        bh=ScQnEn07W5BkdOTu8Q8KhcInIOdo5KUEMbz1v31bhHE=;
        h=Date:From:To:Subject:From;
        b=xo/N+0LJOfsrJKpuLSpb9iyLrlvaVaRIC/CoErKZiOfKtjR6EEh3QvZteDe86UOZa
         v3xfBMHLRSGVftk7b9e9lEcC/lVhklVwpBrr1TsU/mQjgVsL+hmOgERrFiWsw/qv3M
         0OLonu8rKDreksHrZWr2viDsZ7IiMMPun40dYAiU=
Date:   Sun, 09 May 2021 21:32:04 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch added
 to -mm tree
Message-ID: <20210510043204.hE6CThWDB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: bail out early when !mm in get_mem_cgroup_from_mm
has been added to the -mm tree.  Its filename is
     mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch

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
Subject: mm: memcontrol: bail out early when !mm in get_mem_cgroup_from_mm

When mm is NULL, we do not need to hold rcu lock and call css_tryget for
the root memcg.  And we also do not need to check !mm in every loop of
while.  So bail out early when !mm.

Link: https://lkml.kernel.org/r/20210417043538.9793-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm
+++ a/mm/memcontrol.c
@@ -919,20 +919,23 @@ struct mem_cgroup *get_mem_cgroup_from_m
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	/*
+	 * Page cache insertions can happen without an
+	 * actual mm context, e.g. during disk probing
+	 * on boot, loopback IO, acct() writes etc.
+	 *
+	 * No need to css_get on root memcg as the reference
+	 * counting is disabled on the root level in the
+	 * cgroup core. See CSS_NO_REF.
+	 */
+	if (unlikely(!mm))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
 	do {
-		/*
-		 * Page cache insertions can happen without an
-		 * actual mm context, e.g. during disk probing
-		 * on boot, loopback IO, acct() writes etc.
-		 */
-		if (unlikely(!mm))
+		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+		if (unlikely(!memcg))
 			memcg = root_mem_cgroup;
-		else {
-			memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-			if (unlikely(!memcg))
-				memcg = root_mem_cgroup;
-		}
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
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

