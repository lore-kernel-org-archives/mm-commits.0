Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE691E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486727; cv=none; b=nBPIEo+jVQ0agBNk7UcnhAUfF8PIhi4pJ0UX2/sqGPp9NWti5eDJ30QKvmVggSNtbsRuVwXJG3NlEN9m+k1UxYILPXXh/zlvrVppTD9yAquxpcPzgxqii7zbT9yt00Yj02W6SXbfc/4gVQ7vVeHffnyZBSjin1FrEyj6knEq1Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486727; c=relaxed/simple;
	bh=Y7HHI225b5uEwF31QFO36nWCwfW3TzEdnEsZnRLfwiA=;
	h=Date:To:From:Subject:Message-Id; b=Q8+k/FKqM93GAH4TzDQ6SB8e/xX1KPw9QF2XbjGTzggyCLB+MyGUTmC449jQ9lygNS3Yi20C6HU6SSVO8UfyATZkZp9AiswHPBiJLBSSxK6nw46OJgQfQGyR6M8+eK6VbF9XP2pC/GOs1iJCKj0AH6x6BCImoHMFiOBi+hR7QVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oSHOThDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oSHOThDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E33C116C6;
	Tue, 27 Jan 2026 04:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486726;
	bh=Y7HHI225b5uEwF31QFO36nWCwfW3TzEdnEsZnRLfwiA=;
	h=Date:To:From:Subject:From;
	b=oSHOThDuVt+Z+6Wg/x8aLTJn1yfr4jVARGP0B2gvyTolVcGlDU9Lw8iHu/WXzsiG1
	 +dD8EZ8WVVCo4aOINN8wBagmCbtwLQUgDA8sID/p3EVVenszRY815dduKBI1Ltj6jv
	 SBj3JUdNEbtMTkEKuWUf8pqW5iu/1m3O64eRoVTI=
Date: Mon, 26 Jan 2026 20:05:26 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-introduce-sg-list-based-object-read-api.patch removed from -mm tree
Message-Id: <20260127040526.D6E33C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: introduce SG-list based object read API
has been removed from the -mm tree.  Its filename was
     zsmalloc-introduce-sg-list-based-object-read-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: introduce SG-list based object read API
Date: Tue, 13 Jan 2026 12:46:45 +0900

Currently, zsmalloc performs address linearization on read (which
sometimes requires memcpy() to a local buffer).  Not all zsmalloc users
need a linear address.  For example, Crypto API supports SG-list,
performing linearization under the hood, if needed.  In addition, some
compressors can have native SG-list support, completely avoiding the
linearization step.

Provide an SG-list based zsmalloc read API:
- zs_obj_read_sg_begin()
- zs_obj_read_sg_end()

This API allows callers to obtain an SG representation of the object (one
entry for objects that are contained in a single page and two entries for
spanning objects), avoiding the need for a bounce buffer and memcpy.

[senozhatsky@chromium.org: make zs_obj_read_sg_begin() return void, per Yosry]
  Link: https://lkml.kernel.org/r/20260117024900.792237-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20260113034645.2729998-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    4 ++
 mm/zsmalloc.c            |   63 +++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

--- a/include/linux/zsmalloc.h~zsmalloc-introduce-sg-list-based-object-read-api
+++ a/include/linux/zsmalloc.h
@@ -22,6 +22,7 @@ struct zs_pool_stats {
 };
 
 struct zs_pool;
+struct scatterlist;
 
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
@@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *
 			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 		     size_t mem_len, void *handle_mem);
+void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			  struct scatterlist *sg, size_t mem_len);
+void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
 
--- a/mm/zsmalloc.c~zsmalloc-introduce-sg-list-based-object-read-api
+++ a/mm/zsmalloc.c
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/sprintf.h>
 #include <linux/shrinker.h>
@@ -1141,6 +1142,68 @@ void zs_obj_read_end(struct zs_pool *poo
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_end);
 
+void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			  struct scatterlist *sg, size_t mem_len)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj, off;
+	unsigned int obj_idx;
+	struct size_class *class;
+
+	/* Guarantee we can get zspage from handle safely */
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+
+	/* Make sure migration doesn't move any pages in this zspage */
+	zspage_read_lock(zspage);
+	read_unlock(&pool->lock);
+
+	class = zspage_class(pool, zspage);
+	off = offset_in_page(class->size * obj_idx);
+
+	if (!ZsHugePage(zspage))
+		off += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		sg_init_table(sg, 1);
+		sg_set_page(sg, zpdesc_page(zpdesc), mem_len, off);
+	} else {
+		size_t sizes[2];
+
+		/* this object spans two pages */
+		sizes[0] = PAGE_SIZE - off;
+		sizes[1] = mem_len - sizes[0];
+
+		sg_init_table(sg, 2);
+		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
+
+		zpdesc = get_next_zpdesc(zpdesc);
+		sg = sg_next(sg);
+
+		sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
+	}
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
+
+void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj;
+	unsigned int obj_idx;
+
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+
+	zspage_read_unlock(zspage);
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
+
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len)
 {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

