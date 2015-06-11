From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache.patch
 removed from -mm tree
Date: Thu, 11 Jun 2015 14:01:31 -0700
Message-ID: <5579f72b.5L6Sg7TAwZeFr69b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbFKVBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jun 2015 17:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix a null pointer dereference in destroy_handle_cache()
has been removed from the -mm tree.  Its filename was
     zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: fix a null pointer dereference in destroy_handle_cache()

If zs_create_pool()->create_handle_cache()->kmem_cache_create() or
pool->name allocation fails, zs_create_pool()->destroy_handle_cache()
will dereference the NULL pool->handle_cachep.

Modify destroy_handle_cache() to avoid this.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache
+++ a/mm/zsmalloc.c
@@ -289,7 +289,8 @@ static int create_handle_cache(struct zs
 
 static void destroy_handle_cache(struct zs_pool *pool)
 {
-	kmem_cache_destroy(pool->handle_cachep);
+	if (pool->handle_cachep)
+		kmem_cache_destroy(pool->handle_cachep);
 }
 
 static unsigned long alloc_handle(struct zs_pool *pool)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
zram-add-compact-sysfs-entry-to-documentation.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-reorganize-code-layout.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-cosmetic-zram_bvec_write-cleanup.patch
zram-cut-trailing-newline-in-algorithm-name.patch
zram-check-comp-algorithm-availability-earlier.patch
zram-check-comp-algorithm-availability-earlier-v2.patch
linux-next.patch

