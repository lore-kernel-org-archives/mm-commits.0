Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AE5A59
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 00:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768349481; cv=none; b=ShL20oEbeaWzVOiQPunWLW9LBDg4wtKV6JqMi6qU5dpFho/6M0JY+9Z7CBnIidyoaxPyL36d1f2xSKW/Ybj9dhFDXXgHzeu3AaZAG71QUKH4ksjxMYgv6BQuqHqh77LnNomGGEWOjq0wpc31MpVw4K+4m4wpOp1BU0DVCGN9oXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768349481; c=relaxed/simple;
	bh=dJjBkVMian+SMCxdrGOfhdS8Ch4qmvE9m82B9x9J5X4=;
	h=Date:To:From:Subject:Message-Id; b=IUZCL0juOsOZIn2klQi9nbZO+J0SvbP/Kcr04yBnng20pRbaSAGzZ2xYqIAH+67OX2rcwydWiyMLD425gapsvZE6jd4KgFmFzraISV1rLzLgw8kddm4ZyRtAnt3cGd9VB1mEkSvgU8I2ffXhOhrvCQqSLtA1Rv3tNn6g796otvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pczU9IpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pczU9IpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6ADC19421;
	Wed, 14 Jan 2026 00:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768349481;
	bh=dJjBkVMian+SMCxdrGOfhdS8Ch4qmvE9m82B9x9J5X4=;
	h=Date:To:From:Subject:From;
	b=pczU9IpYqPHmtpm2DpQzmthZ0vL/E2x9p9kEBtSyWIIkFlBSdkyxX0UK/jYWyrn47
	 8ZhUGeiHOwbzC/03G2eUobfIfUNVqwkBfMTgbysmmpuxzGwL9JNZAQ2+PGsRNGKwif
	 undQCRnHdBdFDZx3UmQgbaGFW+nwKTOD5cKmt4mc=
Date: Tue, 13 Jan 2026 16:11:20 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-introduce-sg-list-based-object-read-api.patch added to mm-new branch
Message-Id: <20260114001121.5B6ADC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: introduce SG-list based object read API
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-introduce-sg-list-based-object-read-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-introduce-sg-list-based-object-read-api.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

Link: https://lkml.kernel.org/r/20260113034645.2729998-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    4 ++
 mm/zsmalloc.c            |   65 +++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

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
+int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+		   struct scatterlist *sg, size_t mem_len);
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
@@ -1141,6 +1142,70 @@ void zs_obj_read_end(struct zs_pool *poo
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_end);
 
+int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			 struct scatterlist *sg, size_t mem_len)
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
+
+	return 0;
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

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch
zram-use-u32-for-entry-ac_time-tracking.patch
zram-rename-internal-slot-api.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch

