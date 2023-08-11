Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13333C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbjHKXA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbjHKXAB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B0735A2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8042465772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE18C433C7;
        Fri, 11 Aug 2023 22:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794787;
        bh=21/0aVhCsK7POztqV6i5moqLgSS/2Ydp2f1LgAaM16c=;
        h=Date:To:From:Subject:From;
        b=wVSoio3X1arxxzleVU4iQk+LAR2eJjR4y4cl0mE2N2dnK02u59sjLszfEUqc+d0Vl
         hkbeVwoAWe4eacgCIKdnYGQrKGIDLwSUDJ2LEe2nDlz4/3DjgshCNI/cL7cx9XzNQQ
         N/fZ1DZRtvNRMYxE1scC9Q8LkhnanhiiBONmEIGo=
Date:   Fri, 11 Aug 2023 15:59:46 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch removed from -mm tree
Message-Id: <20230811225946.DAE18C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: minor cleanup for MEM_CGROUP_ID_MAX
has been removed from the -mm tree.  Its filename was
     mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memcg: minor cleanup for MEM_CGROUP_ID_MAX
Date: Sat, 8 Jul 2023 10:33:04 +0800

MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured.  So remove
unneeded !CONFIG_MEMCG variant.  Also it's only used in
mem_cgroup_alloc(), so move it from memcontrol.h to memcontrol.c.  And
further define it as:

  #define MEM_CGROUP_ID_MAX ((1UL << MEM_CGROUP_ID_SHIFT) - 1)

so if someone changes MEM_CGROUP_ID_SHIFT in the future, then
MEM_CGROUP_ID_MAX will be updated accordingly, as suggested by Muchun.

Link: https://lkml.kernel.org/r/20230708023304.1184111-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 mm/memcontrol.c            |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-minor-cleanup-for-mem_cgroup_id_max
+++ a/include/linux/memcontrol.h
@@ -61,7 +61,6 @@ struct mem_cgroup_reclaim_cookie {
 #ifdef CONFIG_MEMCG
 
 #define MEM_CGROUP_ID_SHIFT	16
-#define MEM_CGROUP_ID_MAX	USHRT_MAX
 
 struct mem_cgroup_id {
 	int id;
@@ -1158,7 +1157,6 @@ unsigned long mem_cgroup_soft_limit_recl
 #else /* CONFIG_MEMCG */
 
 #define MEM_CGROUP_ID_SHIFT	0
-#define MEM_CGROUP_ID_MAX	0
 
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
--- a/mm/memcontrol.c~mm-memcg-minor-cleanup-for-mem_cgroup_id_max
+++ a/mm/memcontrol.c
@@ -5155,6 +5155,7 @@ static struct cftype mem_cgroup_legacy_f
  * those references are manageable from userspace.
  */
 
+#define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
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

