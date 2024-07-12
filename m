Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59FF1CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824855; cv=none; b=N5NcyobOUgr7BbhQW21l8lCy41dPNTERHyrNRnBYnqaERR4g8csl4YJgXGmJAGfJ3rlM95t4kPDugXcUKTbYMIf0kaoBj3gS+jA/Z/05z1KYCF/ycmYyfprvleMj8kc3ioGLX1tSWTnvMnFbXqQYGQZoIIT4xte1rDZFdwbu/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824855; c=relaxed/simple;
	bh=sGjKrEF8iKoc8XRQgNlvgujNkIqtuqNU5LsOiOlJTsE=;
	h=Date:To:From:Subject:Message-Id; b=JfbGVUUGnh7U7Tvq4G53UlXUBNKUP6uumwCpfeTvCWSb4eEJbUoSSWjDjcbDlwNJoMDtSQT7hAt0PDNn5OFEy4gSnohfBwEnOLcMp0M0fsSqjea6e7J6chjnCrmOsA25QdP8tkIahvSd37IgWC+YWucKxhkTqQb/4bT1PapnIkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k4rIs3BM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k4rIs3BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DFEC32782;
	Fri, 12 Jul 2024 22:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824855;
	bh=sGjKrEF8iKoc8XRQgNlvgujNkIqtuqNU5LsOiOlJTsE=;
	h=Date:To:From:Subject:From;
	b=k4rIs3BMf5N4AGSFzAX/QkYrilRqcJuKXZU8b79MoGKd+/Hbr21ZmvMV2ogIB8ksQ
	 qmo88fbFGC2K08Lc68vbbtYONOEWKWcbPRauomRf4BsuZvV66nw31jV2h0rMIqbk/J
	 H3RpuX4oLtQPbezbLQS7Valw9EfgBR5WcOg8I/Ss=
Date: Fri, 12 Jul 2024 15:54:15 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-move-record_obj-into-obj_malloc.patch removed from -mm tree
Message-Id: <20240712225415.92DFEC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: move record_obj() into obj_malloc()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-move-record_obj-into-obj_malloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zsmalloc: move record_obj() into obj_malloc()
Date: Thu, 27 Jun 2024 15:59:59 +0800

We always record_obj() to make handle points to object after obj_malloc(),
so simplify the code by moving record_obj() into obj_malloc().  There
should be no functional change.

Link: https://lkml.kernel.org/r/20240627075959.611783-2-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-move-record_obj-into-obj_malloc
+++ a/mm/zsmalloc.c
@@ -1306,7 +1306,6 @@ static unsigned long obj_malloc(struct z
 	void *vaddr;
 
 	class = pool->size_class[zspage->class];
-	handle |= OBJ_ALLOCATED_TAG;
 	obj = get_freeobj(zspage);
 
 	offset = obj * class->size;
@@ -1322,15 +1321,16 @@ static unsigned long obj_malloc(struct z
 	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
 	if (likely(!ZsHugePage(zspage)))
 		/* record handle in the header of allocated chunk */
-		link->handle = handle;
+		link->handle = handle | OBJ_ALLOCATED_TAG;
 	else
 		/* record handle to page->index */
-		zspage->first_page->index = handle;
+		zspage->first_page->index = handle | OBJ_ALLOCATED_TAG;
 
 	kunmap_atomic(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
 	obj = location_to_obj(m_page, obj);
+	record_obj(handle, obj);
 
 	return obj;
 }
@@ -1348,7 +1348,7 @@ static unsigned long obj_malloc(struct z
  */
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp)
 {
-	unsigned long handle, obj;
+	unsigned long handle;
 	struct size_class *class;
 	int newfg;
 	struct zspage *zspage;
@@ -1371,10 +1371,9 @@ unsigned long zs_malloc(struct zs_pool *
 	spin_lock(&class->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
-		obj = obj_malloc(pool, zspage, handle);
+		obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
-		record_obj(handle, obj);
 		class_stat_inc(class, ZS_OBJS_INUSE, 1);
 
 		goto out;
@@ -1389,10 +1388,9 @@ unsigned long zs_malloc(struct zs_pool *
 	}
 
 	spin_lock(&class->lock);
-	obj = obj_malloc(pool, zspage, handle);
+	obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
-	record_obj(handle, obj);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
 	class_stat_inc(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	class_stat_inc(class, ZS_OBJS_INUSE, 1);
@@ -1591,7 +1589,6 @@ static void migrate_zspage(struct zs_poo
 		free_obj = obj_malloc(pool, dst_zspage, handle);
 		zs_object_copy(class, free_obj, used_obj);
 		obj_idx++;
-		record_obj(handle, free_obj);
 		obj_free(class->size, used_obj);
 
 		/* Stop if there is no more space */
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are


