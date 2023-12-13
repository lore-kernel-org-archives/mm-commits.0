Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093001EB31
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n4Xbm5qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D05EC433C8;
	Wed, 13 Dec 2023 20:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702499658;
	bh=aILtlZD2Hn/6UQLzj78gMzHEa6NaSDhyKWWnVyiNdDc=;
	h=Date:To:From:Subject:From;
	b=n4Xbm5qG88TzzBCb6svWUbNqEgo35dRJUGG8E0JNB0hcgD4OdYMuY9mgBBgFCU7Q3
	 dUqwFwKxdHSTnIgG98/CYZYbxCtg4cr+Q9sFIZ+rZciRBa5mFLP4b0IqsDnS/fUs0x
	 MyQcLQv+kce/GOd/yKHylX+5c8592ycNl6JAtZ3g=
Date: Wed, 13 Dec 2023 12:34:17 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-reuse-dstmem-when-decompress.patch added to mm-unstable branch
Message-Id: <20231213203418.6D05EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: reuse dstmem when decompress
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-reuse-dstmem-when-decompress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-reuse-dstmem-when-decompress.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: reuse dstmem when decompress
Date: Wed, 13 Dec 2023 04:17:58 +0000

Patch series "mm/zswap: dstmem reuse optimizations and cleanups".

The problem this series tries to optimize is that zswap_load() and
zswap_writeback_entry() have to malloc a temporary memory to support
!zpool_can_sleep_mapped().  We can avoid it by reusing the percpu
crypto_acomp_ctx->dstmem, which is also used by zswap_store() and
protected by the same percpu crypto_acomp_ctx->mutex.


This patch (of 5):

In the !zpool_can_sleep_mapped() case such as zsmalloc, we need to first
copy the entry->handle memory to a temporary memory, which is allocated
using kmalloc.

Obviously we can reuse the per-compressor dstmem to avoid allocating every
time, since it's percpu-compressor and protected in mutex.

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v1-0-896763369d04@bytedance.com
Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v1-1-896763369d04@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chriscli@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/mm/zswap.c~mm-zswap-reuse-dstmem-when-decompress
+++ a/mm/zswap.c
@@ -1767,9 +1767,9 @@ bool zswap_load(struct folio *folio)
 	struct zswap_entry *entry;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	u8 *src, *dst, *tmp;
+	unsigned int dlen = PAGE_SIZE;
+	u8 *src, *dst;
 	struct zpool *zpool;
-	unsigned int dlen;
 	bool ret;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1791,27 +1791,18 @@ bool zswap_load(struct folio *folio)
 		goto stats;
 	}
 
-	zpool = zswap_find_zpool(entry);
-	if (!zpool_can_sleep_mapped(zpool)) {
-		tmp = kmalloc(entry->length, GFP_KERNEL);
-		if (!tmp) {
-			ret = false;
-			goto freeentry;
-		}
-	}
-
 	/* decompress */
-	dlen = PAGE_SIZE;
-	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(acomp_ctx->mutex);
 
+	zpool = zswap_find_zpool(entry);
+	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
 	if (!zpool_can_sleep_mapped(zpool)) {
-		memcpy(tmp, src, entry->length);
-		src = tmp;
+		memcpy(acomp_ctx->dstmem, src, entry->length);
+		src = acomp_ctx->dstmem;
 		zpool_unmap_handle(zpool, entry->handle);
 	}
 
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-	mutex_lock(acomp_ctx->mutex);
 	sg_init_one(&input, src, entry->length);
 	sg_init_table(&output, 1);
 	sg_set_page(&output, page, PAGE_SIZE, 0);
@@ -1822,15 +1813,13 @@ bool zswap_load(struct folio *folio)
 
 	if (zpool_can_sleep_mapped(zpool))
 		zpool_unmap_handle(zpool, entry->handle);
-	else
-		kfree(tmp);
 
 	ret = true;
 stats:
 	count_vm_event(ZSWPIN);
 	if (entry->objcg)
 		count_objcg_event(entry->objcg, ZSWPIN);
-freeentry:
+
 	spin_lock(&tree->lock);
 	if (ret && zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_reclaim_entry.patch

