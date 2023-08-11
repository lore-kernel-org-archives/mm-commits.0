Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7989C04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbjHKXFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237109AbjHKXDj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17AC3A8D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 878B967B6E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1BCC433C8;
        Fri, 11 Aug 2023 23:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794909;
        bh=JT+H4TyfZMRt+93S5SS13NxflByXDmAmfarIDqydLo0=;
        h=Date:To:From:Subject:From;
        b=cxzCgyojp9E4fgRTvCsfuDgwnnEcN3Qav2vZGaLAi2bGRNK7XSOPCPBi27YxYO74/
         LnfPvZmFT7To3tpZiiCCPDljENooIuStdffge49pBXUl7eVcBYzoaV7pKCyrcebri/
         fiwmNnEbvnPFRfdIgh/jLXex9iRtsF2PBL+Ob9Bc=
Date:   Fri, 11 Aug 2023 16:01:48 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch removed from -mm tree
Message-Id: <20230811230148.DB1BCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: minor cleanup for mc_handle_present_pte()
has been removed from the -mm tree.  Its filename was
     mm-memcg-minor-cleanup-for-mc_handle_present_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

