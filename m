Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF2C217709
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188428; cv=none; b=I9VecMz2S1Bj103mX8YwZMb9TPsiSQJOu1cVJolc6sJGF7J+4U5zAyScdJzrkuPpqSf+BOTnuyBJ5JU3XdaAWvGfN4/8/WEVnj/jrAYk+rKq5BND6jwfzn8XQybYOmuE1Ky3mIahv18cN3ExfH9qdf5P8+1+QwXFoebKfH1lzJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188428; c=relaxed/simple;
	bh=JHoHNI6YmT9Y1cwf85mAkjS7v8EQI1Wh5x213vyIVCs=;
	h=Date:To:From:Subject:Message-Id; b=jA22SO8u5ITcZYvnuJEZMI3bfbkLCtxZnJ07FThTUqO3BDGS1RFNqE9gtPmBuDiR0JvysCsp7zu+te9lUqQhDjSKjMt0XrtKOQ1ZH8uIwyUloE+u6KLrYh3DbBTz50QqWC9yUFJOhKRbmdkGBoccx4BSAUgiISTmgcIRxaw94LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=frsfRQmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="frsfRQmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63CAC4CEEC;
	Mon, 17 Mar 2025 05:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188427;
	bh=JHoHNI6YmT9Y1cwf85mAkjS7v8EQI1Wh5x213vyIVCs=;
	h=Date:To:From:Subject:From;
	b=frsfRQmcJc1rzQMwjujWJ5M/bdvEdPLTNjvlkeGbdR2wyCVO8TL9CETX3Q72wbpoS
	 zL9gvip+d/Qc/V4nHCxHH8MyeZhh4c6lFgw+YJ1Dy/KAYTAJVOyceEKeIWq9/zNTeA
	 WgnPMI9q0Jm8eCu5xl5OxbwKyp3xgKC1H7QSuRus=
Date: Sun, 16 Mar 2025 22:13:47 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-introduce-new-object-mapping-api.patch removed from -mm tree
Message-Id: <20250317051347.D63CAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: introduce new object mapping API
has been removed from the -mm tree.  Its filename was
     zsmalloc-introduce-new-object-mapping-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: introduce new object mapping API
Date: Mon, 3 Mar 2025 11:03:23 +0900

Current object mapping API is a little cumbersome.  First, it's
inconsistent, sometimes it returns with page-faults disabled and sometimes
with page-faults enabled.  Second, and most importantly, it enforces
atomicity restrictions on its users.  zs_map_object() has to return a
liner object address which is not always possible because some objects
span multiple physical (non-contiguous) pages.  For such objects zsmalloc
uses a per-CPU buffer to which object's data is copied before a pointer to
that per-CPU buffer is returned back to the caller.  This leads to
another, final, issue - extra memcpy().  Since the caller gets a pointer
to per-CPU buffer it can memcpy() data only to that buffer, and during
zs_unmap_object() zsmalloc will memcpy() from that per-CPU buffer to
physical pages that object in question spans across.

New API splits functions by access mode:
- zs_obj_read_begin(handle, local_copy)
  Returns a pointer to handle memory.  For objects that span two
  physical pages a local_copy buffer is used to store object's
  data before the address is returned to the caller.  Otherwise
  the object's page is kmap_local mapped directly.

- zs_obj_read_end(handle, buf)
  Unmaps the page if it was kmap_local mapped by zs_obj_read_begin().

- zs_obj_write(handle, buf, len)
  Copies len-bytes from compression buffer to handle memory
  (takes care of objects that span two pages).  This does not
  need any additional (e.g. per-CPU) buffers and writes the data
  directly to zsmalloc pool pages.

In terms of performance, on a synthetic and completely reproducible
test that allocates fixed number of objects of fixed sizes and
iterates over those objects, first mapping in RO then in RW mode:

OLD API
=======

3 first results out of 10

  369,205,778      instructions        #    0.80  insn per cycle
   40,467,926      branches            #  113.732 M/sec

  369,002,122      instructions        #    0.62  insn per cycle
   40,426,145      branches            #  189.361 M/sec

  369,036,706      instructions        #    0.63  insn per cycle
   40,430,860      branches            #  204.105 M/sec

[..]

NEW API
=======

3 first results out of 10

  265,799,293      instructions        #    0.51  insn per cycle
   29,834,567      branches            #  170.281 M/sec

  265,765,970      instructions        #    0.55  insn per cycle
   29,829,019      branches            #  161.602 M/sec

  265,764,702      instructions        #    0.51  insn per cycle
   29,828,015      branches            #  189.677 M/sec

[..]

T-test on all 10 runs
=====================

Difference at 95.0% confidence
   -1.03219e+08 +/- 55308.7
   -27.9705% +/- 0.0149878%
   (Student's t, pooled s = 58864.4)

The old API will stay around until the remaining users switch to the new
one.  After that we'll also remove zsmalloc per-CPU buffer and CPU hotplug
handling.

The split of map(RO) and map(WO) into read_{begin/end}/write is suggested
by Yosry Ahmed.

Link: https://lkml.kernel.org/r/20250303022425.285971-15-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    8 ++
 mm/zsmalloc.c            |  125 +++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)

--- a/include/linux/zsmalloc.h~zsmalloc-introduce-new-object-mapping-api
+++ a/include/linux/zsmalloc.h
@@ -58,4 +58,12 @@ unsigned long zs_compact(struct zs_pool
 unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
+
+void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
+			void *local_copy);
+void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
+		     void *handle_mem);
+void zs_obj_write(struct zs_pool *pool, unsigned long handle,
+		  void *handle_mem, size_t mem_len);
+
 #endif
--- a/mm/zsmalloc.c~zsmalloc-introduce-new-object-mapping-api
+++ a/mm/zsmalloc.c
@@ -1362,6 +1362,131 @@ void zs_unmap_object(struct zs_pool *poo
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
+void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
+			void *local_copy)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj, off;
+	unsigned int obj_idx;
+	struct size_class *class;
+	void *addr;
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
+	if (off + class->size <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		addr = kmap_local_zpdesc(zpdesc);
+		addr += off;
+	} else {
+		size_t sizes[2];
+
+		/* this object spans two pages */
+		sizes[0] = PAGE_SIZE - off;
+		sizes[1] = class->size - sizes[0];
+		addr = local_copy;
+
+		memcpy_from_page(addr, zpdesc_page(zpdesc),
+				 off, sizes[0]);
+		zpdesc = get_next_zpdesc(zpdesc);
+		memcpy_from_page(addr + sizes[0],
+				 zpdesc_page(zpdesc),
+				 0, sizes[1]);
+	}
+
+	if (!ZsHugePage(zspage))
+		addr += ZS_HANDLE_SIZE;
+
+	return addr;
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_begin);
+
+void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
+		     void *handle_mem)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj, off;
+	unsigned int obj_idx;
+	struct size_class *class;
+
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+	class = zspage_class(pool, zspage);
+	off = offset_in_page(class->size * obj_idx);
+
+	if (off + class->size <= PAGE_SIZE) {
+		if (!ZsHugePage(zspage))
+			off += ZS_HANDLE_SIZE;
+		handle_mem -= off;
+		kunmap_local(handle_mem);
+	}
+
+	zspage_read_unlock(zspage);
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_end);
+
+void zs_obj_write(struct zs_pool *pool, unsigned long handle,
+		  void *handle_mem, size_t mem_len)
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
+	if (off + class->size <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		void *dst = kmap_local_zpdesc(zpdesc);
+
+		if (!ZsHugePage(zspage))
+			off += ZS_HANDLE_SIZE;
+		memcpy(dst + off, handle_mem, mem_len);
+		kunmap_local(dst);
+	} else {
+		/* this object spans two pages */
+		size_t sizes[2];
+
+		off += ZS_HANDLE_SIZE;
+		sizes[0] = PAGE_SIZE - off;
+		sizes[1] = mem_len - sizes[0];
+
+		memcpy_to_page(zpdesc_page(zpdesc), off,
+			       handle_mem, sizes[0]);
+		zpdesc = get_next_zpdesc(zpdesc);
+		memcpy_to_page(zpdesc_page(zpdesc), 0,
+			       handle_mem + sizes[0], sizes[1]);
+	}
+
+	zspage_read_unlock(zspage);
+}
+EXPORT_SYMBOL_GPL(zs_obj_write);
+
 /**
  * zs_huge_class_size() - Returns the size (in bytes) of the first huge
  *                        zsmalloc &size_class.
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


