Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3796B1339A4
	for <mm-commits@vger.kernel.org>; Sat, 15 Feb 2025 00:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578706; cv=none; b=mMttwsm6HIaMDfQf24gifS1NxWpjKmcgnZFmYMl4KOAHCI2syoOfDxSJN6hxixEU6nfn1oRnwy8fk5UYB//VXN8qu6qNVLGmnD1h8O8PjepXnyugt+22N2Jc3EC4kliWGKtFxXKbPNpOHqcFbxwQtwgLVVDhM3LbFvM1tOvygJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578706; c=relaxed/simple;
	bh=XfyFe7Wfgd3tB4ANP5U6w4L2Vr24MaCKQRXwV8QYuwE=;
	h=Date:To:From:Subject:Message-Id; b=TYUJ4nMty0vg3Ls7vtcINFw5lnMKFH8WuTZwBPLdwCqmamwBt/Kr1/ZRbwW4MRX9PRuE//3GmmGbm3p3H8cLdUpL6JDm5XJLUstHv6h9JAKJG7dSv72dAnso3wIevaEtNf5YqKKFq8VJaSd8NJ5KeXx454rEucgs4i2rs5AZv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bA4DS6YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bA4DS6YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EB3C4CED1;
	Sat, 15 Feb 2025 00:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739578705;
	bh=XfyFe7Wfgd3tB4ANP5U6w4L2Vr24MaCKQRXwV8QYuwE=;
	h=Date:To:From:Subject:From;
	b=bA4DS6YApO2YX/msx5XHkEsP/7Yk07yT+c6fgWJps1atf4QL+uFvQ/3QIKsRi89hz
	 K9tcn1ui7N3OQeD6UEZOJl+jS7OYAW+2JpaW9xdUHDhf0q0SL35JU7LG/y/Upn7mwD
	 TF2xaqJJdGy/T8yzUMGrmifTHsORQjbDXuAQijg4=
Date: Fri, 14 Feb 2025 16:18:25 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-switch-to-new-zsmalloc-object-mapping-api.patch added to mm-unstable branch
Message-Id: <20250215001825.90EB3C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: switch to new zsmalloc object mapping API
has been added to the -mm mm-unstable branch.  Its filename is
     zram-switch-to-new-zsmalloc-object-mapping-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-switch-to-new-zsmalloc-object-mapping-api.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: switch to new zsmalloc object mapping API
Date: Fri, 14 Feb 2025 13:50:25 +0900

Use new read/write zsmalloc object API.  For cases when RO mapped object
spans two physical pages (requires temp buffer) compression streams now
carry around one extra physical page.

Link: https://lkml.kernel.org/r/20250214045208.1388854-14-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    4 +++-
 drivers/block/zram/zcomp.h    |    2 ++
 drivers/block/zram/zram_drv.c |   28 ++++++++++------------------
 3 files changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-switch-to-new-zsmalloc-object-mapping-api
+++ a/drivers/block/zram/zcomp.c
@@ -45,6 +45,7 @@ static const struct zcomp_ops *backends[
 static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
 	comp->ops->destroy_ctx(&zstrm->ctx);
+	vfree(zstrm->local_copy);
 	vfree(zstrm->buffer);
 	zstrm->buffer = NULL;
 }
@@ -57,12 +58,13 @@ static int zcomp_strm_init(struct zcomp
 	if (ret)
 		return ret;
 
+	zstrm->local_copy = vzalloc(PAGE_SIZE);
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
 	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
-	if (!zstrm->buffer) {
+	if (!zstrm->buffer || !zstrm->local_copy) {
 		zcomp_strm_free(comp, zstrm);
 		return -ENOMEM;
 	}
--- a/drivers/block/zram/zcomp.h~zram-switch-to-new-zsmalloc-object-mapping-api
+++ a/drivers/block/zram/zcomp.h
@@ -34,6 +34,8 @@ struct zcomp_strm {
 	struct mutex lock;
 	/* compression buffer */
 	void *buffer;
+	/* local copy of handle memory */
+	void *local_copy;
 	struct zcomp_ctx ctx;
 };
 
--- a/drivers/block/zram/zram_drv.c~zram-switch-to-new-zsmalloc-object-mapping-api
+++ a/drivers/block/zram/zram_drv.c
@@ -1603,11 +1603,11 @@ static int read_incompressible_page(stru
 	void *src, *dst;
 
 	handle = zram_get_handle(zram, index);
-	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
 	kunmap_local(dst);
-	zs_unmap_object(zram->mem_pool, handle);
+	zs_obj_read_end(zram->mem_pool, handle, src);
 
 	return 0;
 }
@@ -1625,11 +1625,11 @@ static int read_compressed_page(struct z
 	prio = zram_get_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
-	zs_unmap_object(zram->mem_pool, handle);
+	zs_obj_read_end(zram->mem_pool, handle, src);
 	zcomp_stream_put(zstrm);
 
 	return ret;
@@ -1725,7 +1725,7 @@ static int write_incompressible_page(str
 				     u32 index)
 {
 	unsigned long handle;
-	void *src, *dst;
+	void *src;
 
 	/*
 	 * This function is called from preemptible context so we don't need
@@ -1742,11 +1742,9 @@ static int write_incompressible_page(str
 		return -ENOMEM;
 	}
 
-	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 	src = kmap_local_page(page);
-	memcpy(dst, src, PAGE_SIZE);
+	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
 	kunmap_local(src);
-	zs_unmap_object(zram->mem_pool, handle);
 
 	zram_slot_lock(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
@@ -1767,7 +1765,7 @@ static int zram_write_page(struct zram *
 	int ret = 0;
 	unsigned long handle;
 	unsigned int comp_len;
-	void *dst, *mem;
+	void *mem;
 	struct zcomp_strm *zstrm;
 	unsigned long element;
 	bool same_filled;
@@ -1813,11 +1811,8 @@ static int zram_write_page(struct zram *
 		return -ENOMEM;
 	}
 
-	dst = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
-
-	memcpy(dst, zstrm->buffer, comp_len);
+	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_stream_put(zstrm);
-	zs_unmap_object(zram->mem_pool, handle);
 
 	zram_slot_lock(zram, index);
 	zram_set_handle(zram, index, handle);
@@ -1929,7 +1924,7 @@ static int recompress_slot(struct zram *
 	unsigned int comp_len_new;
 	unsigned int class_index_old;
 	unsigned int class_index_new;
-	void *src, *dst;
+	void *src;
 	int ret = 0;
 
 	handle_old = zram_get_handle(zram, index);
@@ -2039,12 +2034,9 @@ static int recompress_slot(struct zram *
 		return PTR_ERR((void *)handle_new);
 	}
 
-	dst = zs_map_object(zram->mem_pool, handle_new, ZS_MM_WO);
-	memcpy(dst, zstrm->buffer, comp_len_new);
+	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zstrm);
 
-	zs_unmap_object(zram->mem_pool, handle_new);
-
 	zram_free_page(zram, index);
 	zram_set_handle(zram, index, handle_new);
 	zram_set_obj_size(zram, index, comp_len_new);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-two-staged-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch

