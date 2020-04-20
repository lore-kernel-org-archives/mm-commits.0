From: akpm@linux-foundation.org
Subject: +
 mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch added to
 -mm tree
Date: Mon, 20 Apr 2020 16:39:38 -0700
Message-ID: <20200420233938.Xh0Yx714f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTXjj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, willy@infradead.org


The patch titled
     Subject: mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix

s/EBUSY/ENOSPC/, per Michal

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix
+++ a/mm/memcontrol.c
@@ -2721,8 +2721,6 @@ static int memcg_alloc_cache_id(void)
 
 	id = ida_simple_get(&memcg_cache_ida,
 			    0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
-	if (id == -ENOSPC)
-		return -EBUSY;
 	if (id < 0)
 		return id;
 
@@ -5004,10 +5002,6 @@ static struct mem_cgroup *mem_cgroup_all
 	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
 				 1, MEM_CGROUP_ID_MAX,
 				 GFP_KERNEL);
-	if (memcg->id.id == -ENOSPC) {
-		error = -EBUSY;
-		goto fail;
-	}
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
 		goto fail;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
