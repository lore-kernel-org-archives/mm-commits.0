From: akpm@linux-foundation.org
Subject: +
 zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache.patch added to -mm tree
Date: Mon, 08 Jun 2015 13:55:42 -0700
Message-ID: <5576014e.XTPbNvTv2bJIJ1Z3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbbFHUzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 16:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix a null pointer dereference in destroy_handle_cache()
has been added to the -mm tree.  Its filename is
     zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: fix a null pointer dereference in destroy_handle_cache()

If zs_create_pool()->create_handle_cache()->kmem_cache_create() fails,
zs_create_pool()->destroy_handle_cache() will dereference the NULL
pool->handle_cachep.

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

zram-clear-disk-io-accounting-when-reset-zram-device.patch
zsmalloc-fix-a-null-pointer-dereference-in-destroy_handle_cache.patch
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

