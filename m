Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC1C8634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188549; cv=none; b=Ry4txWwC5DRI4CVUQUZobmSvmB4kjK5GaqKrxJct4hIcGYWQiRklnZtV8163K9ykPl3sZIKHemVVCA7Kp9+SbBX85tJcGv35Qxf3J6vK81aR6ZQ/T3c+N511EIvCMOuOxW6zvYGn8KNjxEE15uA4KNvc0pnrbHiQhP+CEeuV7qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188549; c=relaxed/simple;
	bh=UM3qsLg4NVSpDWCUWF2uk0X1L71lKkF8kPlKoMdANQg=;
	h=Date:To:From:Subject:Message-Id; b=Wjl5FsnMO+QN+C3qaFqi21NA/DzWMBUB/YBklhRcIpO2IpxVlCWOhCyRu/AHfwfZ8FCYNyS09nVdAZuMoXihFNIIDfJ//bYCU0FOEZCS2GsGED5CQRZFkDeuRLApKjia5m8WR4zbzsdGYq2eQtlJ6t04Z1U9YfLNiykgloAA4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wvr8+aAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wvr8+aAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E1AC4CEEC;
	Mon, 17 Mar 2025 05:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188548;
	bh=UM3qsLg4NVSpDWCUWF2uk0X1L71lKkF8kPlKoMdANQg=;
	h=Date:To:From:Subject:From;
	b=Wvr8+aAZo4o+26Fq8Zan+zPNXUtfcVD/17u3Eh7ycz5iAh84vtsmhxfFLHIbltcRu
	 RniC9IQIdhLXW4yCL5l95gqR5eBXp35kSkMxIt3zjGx4hkUiZGy/C4SP0+oh/KZKBN
	 eDKyayLCzkvRw12qQP3HqWfLTXavrHFYLVFybc78=
Date: Sun, 16 Mar 2025 22:15:48 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,senozhatsky@chromium.org,peterz@infradead.org,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zpool-add-interfaces-for-object-read-write-apis.patch removed from -mm tree
Message-Id: <20250317051548.D6E1AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zpool: add interfaces for object read/write APIs
has been removed from the -mm tree.  Its filename was
     mm-zpool-add-interfaces-for-object-read-write-apis.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


