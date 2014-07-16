From: akpm@linux-foundation.org
Subject: [obsolete] mm-zpool-update-zswap-to-use-zpool-fix.patch removed
 from -mm tree
Date: Wed, 16 Jul 2014 14:50:39 -0700
Message-ID: <53c6f3af.wZ3pmc7DZnZyTKAu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:57437 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaGPVuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 17:50:40 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so457812ieb.4
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 14:50:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: zbud_zpool_destroy() can be static
has been removed from the -mm tree.  Its filename was
     mm-zpool-update-zswap-to-use-zpool-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: mm/zpool: zbud_zpool_destroy() can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/zbud.c~mm-zpool-update-zswap-to-use-zpool-fix mm/zbud.c
--- a/mm/zbud.c~mm-zpool-update-zswap-to-use-zpool-fix
+++ a/mm/zbud.c
@@ -134,21 +134,21 @@ static void *zbud_zpool_create(gfp_t gfp
 	return zbud_create_pool(gfp, &zbud_zpool_ops);
 }
 
-void zbud_zpool_destroy(void *pool)
+static void zbud_zpool_destroy(void *pool)
 {
 	zbud_destroy_pool(pool);
 }
 
-int zbud_zpool_malloc(void *pool, size_t size, unsigned long *handle)
+static int zbud_zpool_malloc(void *pool, size_t size, unsigned long *handle)
 {
 	return zbud_alloc(pool, size, handle);
 }
-void zbud_zpool_free(void *pool, unsigned long handle)
+static void zbud_zpool_free(void *pool, unsigned long handle)
 {
 	zbud_free(pool, handle);
 }
 
-int zbud_zpool_shrink(void *pool, unsigned int pages,
+static int zbud_zpool_shrink(void *pool, unsigned int pages,
 			unsigned int *reclaimed)
 {
 	unsigned int total = 0;
@@ -167,17 +167,17 @@ int zbud_zpool_shrink(void *pool, unsign
 	return ret;
 }
 
-void *zbud_zpool_map(void *pool, unsigned long handle,
+static void *zbud_zpool_map(void *pool, unsigned long handle,
 			enum zpool_mapmode mm)
 {
 	return zbud_map(pool, handle);
 }
-void zbud_zpool_unmap(void *pool, unsigned long handle)
+static void zbud_zpool_unmap(void *pool, unsigned long handle)
 {
 	zbud_unmap(pool, handle);
 }
 
-u64 zbud_zpool_total_size(void *pool)
+static u64 zbud_zpool_total_size(void *pool)
 {
 	return zbud_get_pool_size(pool) * PAGE_SIZE;
 }
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
sh-also-try-passing-m4-nofpu-for-sh2a-builds.patch
mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
add-lib-globc-fix.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

