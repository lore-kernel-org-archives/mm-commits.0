Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9371F76B5
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216363; cv=none; b=LjW8279z1udG2SoN6XRqaBVWaw8nzR7/jWs6i4cFnyChOW1KLpAKzMaWkiciziQ7ydpqYNxeiaPKiuv9032FuouGTeQCnBQ7k8ysmZSuZy85XdYaRMCryV4DHMB+m3MGGrAqts5tB8BXXKTLZVMgfLT/zmJKhBtlXzXVA6Lt/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216363; c=relaxed/simple;
	bh=KtHF7rFWagmYVBfmccajptwc3whj20GlUBRzJmuxIos=;
	h=Date:To:From:Subject:Message-Id; b=Mc3F+VrKi/dl/ZWJo3Fy4xU6ANIJRuALTvo0oh3uBL7spjr8O4OJNgxj6ibuHEguxm3GPEdL5C0qjRlvNhWBwVM2lFvVhny8VVAd96AEUlVMz39njYfxMIlQcaexi+QTrgPjZ8QqOMZmD496786QKWVNw0ZIaacJiS1Xj3pYAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eCxmXlr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eCxmXlr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34D1C4CEE0;
	Wed,  5 Mar 2025 23:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741216363;
	bh=KtHF7rFWagmYVBfmccajptwc3whj20GlUBRzJmuxIos=;
	h=Date:To:From:Subject:From;
	b=eCxmXlr4dQI3MAiO+QEXFNhpBWkBWHmUnMLWVK1hvV/NZef6rXQHw10A9FB+X924L
	 Yx/7sKjMmAGf5ZanrRNXjPjSo/TjqBiBZTqJ/2szioXoYApvduof9QTbiqmBDhjc3w
	 842aod8H3Btv5Oz6m6nKKll+8V5KzkGJ9sWaFd4Y=
Date: Wed, 05 Mar 2025 15:12:42 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zpool-add-interfaces-for-object-read-write-apis.patch added to mm-unstable branch
Message-Id: <20250305231242.E34D1C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zpool: add interfaces for object read/write APIs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zpool-add-interfaces-for-object-read-write-apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zpool-add-interfaces-for-object-read-write-apis.patch

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
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: zpool: add interfaces for object read/write APIs
Date: Wed, 5 Mar 2025 06:11:29 +0000

Patch series "Switch zswap to object read/write APIs".

This patch series updates zswap to use the new object read/write APIs
defined by zsmalloc in [1], and remove the old object mapping APIs and the
related code from zpool and zsmalloc.


This patch (of 5):

Zsmalloc introduced new APIs to read/write objects besides mapping them. 
Add the necessary zpool interfaces.

Link: https://lkml.kernel.org/r/20250305061134.4105762-1-yosry.ahmed@linux.dev
Link: https://lkml.kernel.org/r/20250305061134.4105762-2-yosry.ahmed@linux.dev
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zpool.h |   17 ++++++++++++++
 mm/zpool.c            |   48 ++++++++++++++++++++++++++++++++++++++++
 mm/zsmalloc.c         |   21 +++++++++++++++++
 3 files changed, 86 insertions(+)

--- a/include/linux/zpool.h~mm-zpool-add-interfaces-for-object-read-write-apis
+++ a/include/linux/zpool.h
@@ -52,6 +52,16 @@ void *zpool_map_handle(struct zpool *poo
 
 void zpool_unmap_handle(struct zpool *pool, unsigned long handle);
 
+
+void *zpool_obj_read_begin(struct zpool *zpool, unsigned long handle,
+			   void *local_copy);
+
+void zpool_obj_read_end(struct zpool *zpool, unsigned long handle,
+			void *handle_mem);
+
+void zpool_obj_write(struct zpool *zpool, unsigned long handle,
+		     void *handle_mem, size_t mem_len);
+
 u64 zpool_get_total_pages(struct zpool *pool);
 
 
@@ -90,6 +100,13 @@ struct zpool_driver {
 				enum zpool_mapmode mm);
 	void (*unmap)(void *pool, unsigned long handle);
 
+	void *(*obj_read_begin)(void *pool, unsigned long handle,
+				void *local_copy);
+	void (*obj_read_end)(void *pool, unsigned long handle,
+			     void *handle_mem);
+	void (*obj_write)(void *pool, unsigned long handle,
+			  void *handle_mem, size_t mem_len);
+
 	u64 (*total_pages)(void *pool);
 };
 
--- a/mm/zpool.c~mm-zpool-add-interfaces-for-object-read-write-apis
+++ a/mm/zpool.c
@@ -321,6 +321,54 @@ void zpool_unmap_handle(struct zpool *zp
 }
 
 /**
+ * zpool_obj_read_begin() - Start reading from a previously allocated handle.
+ * @zpool:	The zpool that the handle was allocated from
+ * @handle:	The handle to read from
+ * @local_copy:	A local buffer to use if needed.
+ *
+ * This starts a read operation of a previously allocated handle. The passed
+ * @local_copy buffer may be used if needed by copying the memory into.
+ * zpool_obj_read_end() MUST be called after the read is completed to undo any
+ * actions taken (e.g. release locks).
+ *
+ * Returns: A pointer to the handle memory to be read, if @local_copy is used,
+ * the returned pointer is @local_copy.
+ */
+void *zpool_obj_read_begin(struct zpool *zpool, unsigned long handle,
+			   void *local_copy)
+{
+	return zpool->driver->obj_read_begin(zpool->pool, handle, local_copy);
+}
+
+/**
+ * zpool_obj_read_end() - Finish reading from a previously allocated handle.
+ * @zpool:	The zpool that the handle was allocated from
+ * @handle:	The handle to read from
+ * @handle_mem:	The pointer returned by zpool_obj_read_begin()
+ *
+ * Finishes a read operation previously started by zpool_obj_read_begin().
+ */
+void zpool_obj_read_end(struct zpool *zpool, unsigned long handle,
+			void *handle_mem)
+{
+	zpool->driver->obj_read_end(zpool->pool, handle, handle_mem);
+}
+
+/**
+ * zpool_obj_write() - Write to a previously allocated handle.
+ * @zpool:	The zpool that the handle was allocated from
+ * @handle:	The handle to read from
+ * @handle_mem:	The memory to copy from into the handle.
+ * @mem_len:	The length of memory to be written.
+ *
+ */
+void zpool_obj_write(struct zpool *zpool, unsigned long handle,
+		     void *handle_mem, size_t mem_len)
+{
+	zpool->driver->obj_write(zpool->pool, handle, handle_mem, mem_len);
+}
+
+/**
  * zpool_get_total_pages() - The total size of the pool
  * @zpool:	The zpool to check
  *
--- a/mm/zsmalloc.c~mm-zpool-add-interfaces-for-object-read-write-apis
+++ a/mm/zsmalloc.c
@@ -507,6 +507,24 @@ static void zs_zpool_unmap(void *pool, u
 	zs_unmap_object(pool, handle);
 }
 
+static void *zs_zpool_obj_read_begin(void *pool, unsigned long handle,
+				     void *local_copy)
+{
+	return zs_obj_read_begin(pool, handle, local_copy);
+}
+
+static void zs_zpool_obj_read_end(void *pool, unsigned long handle,
+				  void *handle_mem)
+{
+	zs_obj_read_end(pool, handle, handle_mem);
+}
+
+static void zs_zpool_obj_write(void *pool, unsigned long handle,
+			       void *handle_mem, size_t mem_len)
+{
+	zs_obj_write(pool, handle, handle_mem, mem_len);
+}
+
 static u64 zs_zpool_total_pages(void *pool)
 {
 	return zs_get_total_pages(pool);
@@ -522,6 +540,9 @@ static struct zpool_driver zs_zpool_driv
 	.free =			  zs_zpool_free,
 	.map =			  zs_zpool_map,
 	.unmap =		  zs_zpool_unmap,
+	.obj_read_begin =	  zs_zpool_obj_read_begin,
+	.obj_read_end  =	  zs_zpool_obj_read_end,
+	.obj_write =		  zs_zpool_obj_write,
 	.total_pages =		  zs_zpool_total_pages,
 };
 
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

mm-z3fold-remove-z3fold.patch
mm-zbud-remove-zbud.patch
mm-zpool-add-interfaces-for-object-read-write-apis.patch
mm-zswap-use-object-read-write-apis-instead-of-object-mapping-apis.patch
mm-zpool-remove-object-mapping-apis.patch
mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas.patch
mm-zsmalloc-remove-object-mapping-apis-and-per-cpu-map-areas-fix.patch
mm-zpool-remove-zpool_malloc_support_movable.patch

