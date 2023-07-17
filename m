Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7A8C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjGQSP5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjGQSPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:15:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C211735
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F210611D1
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAD9C433C7;
        Mon, 17 Jul 2023 18:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689617683;
        bh=wvJp+EnQ9P3t6h9MDUt1Z3uDsdfUKY0WOPcvH06cEoM=;
        h=Date:To:From:Subject:From;
        b=utiF6LB6rmESS7KUZV7FUNR/H3vOKdu/5Bnzrp6sIteN+UgnbhfpucIvy8DRGNASa
         e6KfAdoFBGCWg9E7ellHiVk3g4o4n/gMpW7bjCJnvpVl0LWprojUeFO/L2s5GA0Fv2
         VVpx6zRUiN2FaF9Z4LxbHJ0cY2KgTqkd6Nk1+eEI=
Date:   Mon, 17 Jul 2023 11:14:42 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch added to mm-unstable branch
Message-Id: <20230717181443.7FAD9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: minor cleanup for mc_handle_present_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch

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
Subject: mm/memcg: minor cleanup for mc_handle_present_pte()
Date: Mon, 17 Jul 2023 19:36:44 +0800

When pagetable lock is held, the page will always be page_mapped().  So
remove unneeded page_mapped() check.  Also the page can't be freed from
under us in this case.  So use get_page() to get extra page reference to
simplify the code.  No functional change intended.

Link: https://lkml.kernel.org/r/20230717113644.3026478-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-minor-cleanup-for-mc_handle_present_pte
+++ a/mm/memcontrol.c
@@ -5639,7 +5639,7 @@ static struct page *mc_handle_present_pt
 {
 	struct page *page = vm_normal_page(vma, addr, ptent);
 
-	if (!page || !page_mapped(page))
+	if (!page)
 		return NULL;
 	if (PageAnon(page)) {
 		if (!(mc.flags & MOVE_ANON))
@@ -5648,8 +5648,7 @@ static struct page *mc_handle_present_pt
 		if (!(mc.flags & MOVE_FILE))
 			return NULL;
 	}
-	if (!get_page_unless_zero(page))
-		return NULL;
+	get_page(page);
 
 	return page;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch
mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch
mm-memory-failure-remove-unneeded-pagehuge-check.patch
mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch
mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch
mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch
mm-memory-failure-remove-unneeded-header-files.patch
mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch
mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch
mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch
mm-huge_memory-use-rmap_none-when-calling-page_add_anon_rmap.patch
mm-memcg-fix-obsolete-comment-above-mem_cgroup_max_reclaim_loops.patch
mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch

