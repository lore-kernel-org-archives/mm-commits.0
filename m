Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7F613A244
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 04:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782621371; cv=none; b=FF4J2zahlz/msYYHq8NDB3xOWUR1ZFMqirTdAtgW4s/8laS4V9Q+metA4xJC9/S3qCEYsSWotX0zmRbgNws4+U9Vo15ggQrbKOVrywMMr3bgtlGCNoXdraXEnbaH15++1v9ffurBmEWBLk2KhIsQ27x+d9L95ctGL2TnpLdNGQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782621371; c=relaxed/simple;
	bh=gVUOyeU46h94eAZ7SxSWZrerPvaCI7I/mEUcCjgveeg=;
	h=Date:To:From:Subject:Message-Id; b=R30KLVmejaFnbPVi2fdBnIsTWMM1toCGsjVQvir4XENcFxMJu4RyAob4TfodPMALBbZCoVjv7MYA3NgBHzvEpL1slnU0kJw9qyCxB2cDusjEWu5mOcj+JByhAJPaqKlYKbW1iAG34qbNSZy69mP1uEhi2Z4HSVGONHzKKXAdxrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F7/TF3CA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F7/TF3CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F211F000E9;
	Sun, 28 Jun 2026 04:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782621370;
	bh=nEQNSupX6NGlRM5Drfp9CcvQzbkKRTCJVmd0VWH5uXs=;
	h=Date:To:From:Subject;
	b=F7/TF3CALxu7tUIgN5KATMSiD0sxdFVKYHKIWxdAgKm0EwFfoKnK3QpNUmF0VKPrS
	 PWtSLK4t7tlMF+fHD06Tb2GSzwKWPxa3MD1hyl7LMYpKLNE4WYJj/sjoVox24mw5vj
	 ui7vLDlkH001x+Lv30f0uo7ESbxj/3p6kbpyJrYY=
Date: Sat, 27 Jun 2026 21:36:09 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,baohua@kernel.org,haowenchao@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch added to mm-new branch
Message-Id: <20260628043609.E2F211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
has been added to the -mm mm-new branch.  Its filename is
     mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Wenchao Hao <haowenchao@xiaomi.com>
Subject: mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
Date: Fri, 26 Jun 2026 09:50:01 +0800

With class_idx encoded in obj, zs_free() can locate the size_class without
holding pool->lock on 64-bit systems.  Page migration also takes
class->lock and only rewrites the PFN field of obj, so:

  1. read obj locklessly,
  2. lock the size_class derived from obj's class_idx,
  3. re-read obj under class->lock to get a stable PFN.

This eliminates the rwlock read-side cacheline bouncing between zs_free()
and migration/compaction on multi-core systems.

Annotate handle_to_obj()/record_obj() with READ_ONCE()/WRITE_ONCE() to
prevent load/store tearing on the lockless read path and silence KCSAN
data race reports.

When ZS_OBJ_CLASS_BITS == 0 (32-bit, or 64-bit with obj too narrow to hold
class_idx), zs_free() keeps pool->lock.

Link: https://lore.kernel.org/20260626015003.2965881-3-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   75 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 60 insertions(+), 15 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems
+++ a/mm/zsmalloc.c
@@ -21,6 +21,10 @@
  *	pool->lock
  *	class->lock
  *	zspage->lock
+ *
+ * When ZS_OBJ_CLASS_BITS > 0, zs_free() skips pool->lock; it picks
+ * the size_class from obj's encoded class_idx and serializes against
+ * page migration via class->lock.
  */
 
 #include <linux/module.h>
@@ -463,10 +467,13 @@ static void cache_free_zspage(struct zsp
 	kmem_cache_free(zspage_cachep, zspage);
 }
 
-/* class->lock(which owns the handle) synchronizes races */
+/*
+ * Pairs with READ_ONCE() in handle_to_obj(): zs_free() may read the
+ * handle locklessly, so prevent store tearing here.
+ */
 static void record_obj(unsigned long handle, unsigned long obj)
 {
-	*(unsigned long *)handle = obj;
+	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
 static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
@@ -822,7 +829,7 @@ static unsigned long location_to_obj(str
 
 static unsigned long handle_to_obj(unsigned long handle)
 {
-	return *(unsigned long *)handle;
+	return READ_ONCE(*(unsigned long *)handle);
 }
 
 static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
@@ -1456,10 +1463,58 @@ static void obj_free(int class_size, uns
 	mod_zspage_inuse(zspage, -1);
 }
 
+/*
+ * Resolve @handle to its zspage / size_class and acquire class->lock.
+ *
+ * When class_idx is encoded in obj (ZS_OBJ_CLASS_BITS > 0), it is
+ * invariant under page migration, so the handle can be read locklessly
+ * to pick the size_class.  Once class->lock is held migration is
+ * blocked and the handle is re-read to obtain a stable PFN.
+ *
+ * Otherwise (32-bit, or 64-bit fallback paths like UML where the
+ * encoding is disabled), fall back to pool->lock for the lookup.
+ */
+#if ZS_OBJ_CLASS_BITS > 0
+static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
+					 unsigned long *objp, struct zspage **zspagep,
+					 struct size_class **classp)
+	__acquires(&(*classp)->lock)
+{
+	struct zpdesc *f_zpdesc;
+	unsigned long obj;
+
+	obj = handle_to_obj(handle);
+	*classp = pool->size_class[obj_to_class_idx(obj)];
+	spin_lock(&(*classp)->lock);
+	/* Re-read under class->lock: PFN is now stable vs migration. */
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	*zspagep = get_zspage(f_zpdesc);
+	*objp = obj;
+}
+#else
+static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
+					 unsigned long *objp, struct zspage **zspagep,
+					 struct size_class **classp)
+	__acquires(&(*classp)->lock)
+{
+	struct zpdesc *f_zpdesc;
+	unsigned long obj;
+
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	*zspagep = get_zspage(f_zpdesc);
+	*classp = zspage_class(pool, *zspagep);
+	spin_lock(&(*classp)->lock);
+	read_unlock(&pool->lock);
+	*objp = obj;
+}
+#endif
+
 void zs_free(struct zs_pool *pool, unsigned long handle)
 {
 	struct zspage *zspage;
-	struct zpdesc *f_zpdesc;
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
@@ -1467,17 +1522,7 @@ void zs_free(struct zs_pool *pool, unsig
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
 
-	/*
-	 * The pool->lock protects the race with zpage's migration
-	 * so it's safe to get the page from handle.
-	 */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_zpdesc(obj, &f_zpdesc);
-	zspage = get_zspage(f_zpdesc);
-	class = zspage_class(pool, zspage);
-	spin_lock(&class->lock);
-	read_unlock(&pool->lock);
+	obj_class_get_and_lock(pool, handle, &obj, &zspage, &class);
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
_

Patches currently in -mm which might be from haowenchao@xiaomi.com are

mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch
mm-zsmalloc-document-free_zspage-helper-variants.patch

