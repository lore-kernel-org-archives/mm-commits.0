From: akpm@linux-foundation.org
Subject: + fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
 added to -mm tree
Date: Wed, 31 May 2017 12:09:06 -0700
Message-ID: <592f14d2.+6Vu/7M39eddLf4S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaTJH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 15:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/file.c: replace alloc_fdmem() with kvmalloc() alternative
has been added to the -mm tree.  Its filename is
     fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-linux-gfph-fix-___gfp_nolockdep-value.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch
fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

