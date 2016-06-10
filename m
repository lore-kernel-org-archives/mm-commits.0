From: akpm@linux-foundation.org
Subject: [merged]
 revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch removed from
 -mm tree
Date: Fri, 10 Jun 2016 12:12:12 -0700
Message-ID: <575b110c.qQ1ioC7+Lzf712eh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbcFJTMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 15:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm: memcontrol: fix possible css ref leak on oom"
has been removed from the -mm tree.  Its filename was
     revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "mm: memcontrol: fix possible css ref leak on oom"

Revert 1383399d7be02 ("mm: memcontrol: fix possible css ref leak on oom").
Johannes points out "There is a task_in_memcg_oom() check before calling
mem_cgroup_oom()".

Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom mm/memcontrol.c
--- a/mm/memcontrol.c~revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom
+++ a/mm/memcontrol.c
@@ -1608,7 +1608,7 @@ static void memcg_oom_recover(struct mem
 
 static void mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 {
-	if (!current->memcg_may_oom || current->memcg_in_oom)
+	if (!current->memcg_may_oom)
 		return;
 	/*
 	 * We are in the middle of the charge context here, so we
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

