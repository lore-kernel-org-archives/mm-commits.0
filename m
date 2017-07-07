From: akpm@linux-foundation.org
Subject: [merged]
 fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch removed from
 -mm tree
Date: Fri, 07 Jul 2017 12:07:45 -0700
Message-ID: <20170707190745.zCduvUzvd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60694 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbdGGTHq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/file.c: replace alloc_fdmem() with kvmalloc() alternative
has been removed from the -mm tree.  Its filename was
     fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs/file.c: replace alloc_fdmem() with kvmalloc() alternative

There is no real reason to duplicate kvmalloc* helpers so drop alloc_fdmem
and replace it with the appropriate library function.

Link: http://lkml.kernel.org/r/20170531155145.17111-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN fs/file.c~fs-file-replace-alloc_fdmem-with-kvmalloc-alternative fs/file.c
--- a/fs/file.c~fs-file-replace-alloc_fdmem-with-kvmalloc-alternative
+++ a/fs/file.c
@@ -30,21 +30,6 @@ unsigned int sysctl_nr_open_min = BITS_P
 unsigned int sysctl_nr_open_max =
 	__const_min(INT_MAX, ~(size_t)0/sizeof(void *)) & -BITS_PER_LONG;
 
-static void *alloc_fdmem(size_t size)
-{
-	/*
-	 * Very large allocations can stress page reclaim, so fall back to
-	 * vmalloc() if the allocation size will be considered "large" by the VM.
-	 */
-	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *data = kmalloc(size, GFP_KERNEL_ACCOUNT |
-				     __GFP_NOWARN | __GFP_NORETRY);
-		if (data != NULL)
-			return data;
-	}
-	return __vmalloc(size, GFP_KERNEL_ACCOUNT, PAGE_KERNEL);
-}
-
 static void __free_fdtable(struct fdtable *fdt)
 {
 	kvfree(fdt->fd);
@@ -131,13 +116,14 @@ static struct fdtable * alloc_fdtable(un
 	if (!fdt)
 		goto out;
 	fdt->max_fds = nr;
-	data = alloc_fdmem(nr * sizeof(struct file *));
+	data = kvmalloc_array(nr, sizeof(struct file *), GFP_KERNEL_ACCOUNT);
 	if (!data)
 		goto out_fdt;
 	fdt->fd = data;
 
-	data = alloc_fdmem(max_t(size_t,
-				 2 * nr / BITS_PER_BYTE + BITBIT_SIZE(nr), L1_CACHE_BYTES));
+	data = kvmalloc(max_t(size_t,
+				 2 * nr / BITS_PER_BYTE + BITBIT_SIZE(nr), L1_CACHE_BYTES),
+				 GFP_KERNEL_ACCOUNT);
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = data;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-make-pr_set_thp_disable-immediately-active.patch
mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-unify-new_node_page-and-alloc_migrate_target.patch
mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit.patch
mm-hugetlb-unclutter-hugetlb-allocation-layers.patch
hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration.patch
mm-document-highmem_is_dirtyable-sysctl.patch
mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch
mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

