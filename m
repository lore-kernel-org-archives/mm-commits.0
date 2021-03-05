Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3951C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9DF36500D
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCEBxl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhCEBxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 20:53:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CF8C64E68;
        Fri,  5 Mar 2021 01:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614909219;
        bh=Z9sEH7dhtRioXiE5+uOLrxv7x50q9xQ63zpAx2PnSCQ=;
        h=Date:From:To:Subject:From;
        b=mX77FXMWHNOf/rfIt2KcDvQpWX20bXDHcHk7rIx51xPgZvwnV6gKwy7BMoGgpY7Cg
         5c536SMc1WDsHPpV0nceWePgos8pxfgQzolIg5VPPIPLWjZHBPwZM/RItu77ojad2p
         CPiN70LsrPNEyDwL+kUnQQ9vx+MIkhmSIZig+Mb0=
Date:   Thu, 04 Mar 2021 17:53:38 -0800
From:   akpm@linux-foundation.org
To:     chenweilong@huawei.com, dingtianhong@huawei.com,
        guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        rui.xiang@huawei.com, shakeelb@google.com,
        wangkefeng.wang@huawei.com, zhouguanghui1@huawei.com,
        ziy@nvidia.com
Subject:  +
 mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch added
 to -mm tree
Message-ID: <20210305015338.JxQnY5Pil%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: rename mem_cgroup_split_huge_fixup to split_page_memcg
has been added to the -mm tree.  Its filename is
     mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Guanghui <zhouguanghui1@huawei.com>
Subject: mm/memcg: rename mem_cgroup_split_huge_fixup to split_page_memcg

Rename mem_cgroup_split_huge_fixup to split_page_memcg and explicitly pass
in page number argument.

In this way, the interface name is more common and can be used by
potential users.  In addition, the complete info(memcg and flag) of the
memcg needs to be set to the tail pages.

Link: https://lkml.kernel.org/r/20210304074053.65527-2-zhouguanghui1@huawei.com
Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Tianhong Ding <dingtianhong@huawei.com>
Cc: Weilong Chen <chenweilong@huawei.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++----
 mm/huge_memory.c           |    2 +-
 mm/memcontrol.c            |   15 ++++++---------
 3 files changed, 9 insertions(+), 14 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg
+++ a/include/linux/memcontrol.h
@@ -1061,9 +1061,7 @@ static inline void memcg_memory_event_mm
 	rcu_read_unlock();
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head);
-#endif
+void split_page_memcg(struct page *head, unsigned int nr);
 
 #else /* CONFIG_MEMCG */
 
@@ -1400,7 +1398,7 @@ unsigned long mem_cgroup_soft_limit_recl
 	return 0;
 }
 
-static inline void mem_cgroup_split_huge_fixup(struct page *head)
+static inline void split_page_memcg(struct page *head, unsigned int nr)
 {
 }
 
--- a/mm/huge_memory.c~mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg
+++ a/mm/huge_memory.c
@@ -2471,7 +2471,7 @@ static void __split_huge_page(struct pag
 	int i;
 
 	/* complete memcg works before add pages to LRU */
-	mem_cgroup_split_huge_fixup(head);
+	split_page_memcg(head, nr);
 
 	if (PageAnon(head) && PageSwapCache(head)) {
 		swp_entry_t entry = { .val = page_private(head) };
--- a/mm/memcontrol.c~mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg
+++ a/mm/memcontrol.c
@@ -3284,24 +3284,21 @@ void obj_cgroup_uncharge(struct obj_cgro
 
 #endif /* CONFIG_MEMCG_KMEM */
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * Because page_memcg(head) is not set on compound tails, set it now.
+ * Because page_memcg(head) is not set on tails, set it now.
  */
-void mem_cgroup_split_huge_fixup(struct page *head)
+void split_page_memcg(struct page *head, unsigned int nr)
 {
 	struct mem_cgroup *memcg = page_memcg(head);
 	int i;
 
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < HPAGE_PMD_NR; i++) {
-		css_get(&memcg->css);
-		head[i].memcg_data = (unsigned long)memcg;
-	}
+	for (i = 1; i < nr; i++)
+		head[i].memcg_data = head->memcg_data;
+	css_get_many(&memcg->css, nr - 1);
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_MEMCG_SWAP
 /**
_

Patches currently in -mm which might be from zhouguanghui1@huawei.com are

mm-memcg-rename-mem_cgroup_split_huge_fixup-to-split_page_memcg.patch
mm-memcg-set-memcg-when-split-page.patch

