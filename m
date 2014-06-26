From: akpm@linux-foundation.org
Subject: + mm-zpool-update-zswap-to-use-zpool-fix.patch added to -mm tree
Date: Thu, 26 Jun 2014 12:27:46 -0700
Message-ID: <53ac7432.KHMPySLme0ZHT68P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaFZT1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 15:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: zbud_zpool_destroy() can be static
has been added to the -mm tree.  Its filename is
     mm-zpool-update-zswap-to-use-zpool-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-update-zswap-to-use-zpool-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-update-zswap-to-use-zpool-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-zpool-update-zswap-to-use-zpool-fix.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
add-lib-globc-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
linux-next.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

