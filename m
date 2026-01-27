Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC84315D51
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 03:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486276; cv=none; b=CEuK4xSF0tB21XhxojnmC3zcpjTOKMhE6P6nt2ft2EjRUdI/uiWX2JDYgXet2XFyf7au/Gv9wkCadD9FO43ySnnPHBQSMyaVWQSNuVPOO5kQpEYrXqduPc8BUhXKJNKGsSylj8wVf4Z5CWmIMiCyaVXwzdqDCQFuott8kQ8s+g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486276; c=relaxed/simple;
	bh=LJwH58ys7cdgawUNl+nSwJ3lBojX1G5Mh80i5yEyorM=;
	h=Date:To:From:Subject:Message-Id; b=ZJmFkGo0IqIXNbyITdZmHjD9JQ3hXBXUChiTylY2qrZNQQ6FGcZQ3FDWX9sQC91NiX3rrkD90ijI4OVN2XPAKLC899ZttiyOHa3r+lc0Vh5a3000fN0wYhKlAwpMLq9O8q4r8vKiNRfoR6LSlUo8OeGT53wCvR3wufTN3I7IVxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b7Gs5T5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b7Gs5T5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE78C116C6;
	Tue, 27 Jan 2026 03:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486276;
	bh=LJwH58ys7cdgawUNl+nSwJ3lBojX1G5Mh80i5yEyorM=;
	h=Date:To:From:Subject:From;
	b=b7Gs5T5J2UUkLJtQRr2jNDN9odnbMziMey6m7kjBXnW2tkg+/cTIxaZhoxGUdlGON
	 G6TqNRTBt9nGx6iqD1HG8HdUR7v69Af3RYbea9grwYGQdRRT0IXFzFPNK6MfkHeT7N
	 q2ZCaCUctb3yA5hiNDL0Wle6hDsfdyGKcWvKoXzI=
Date: Mon, 26 Jan 2026 19:57:55 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zsmalloc-introduce-sg-list-based-object-read-api-fix.patch removed from -mm tree
Message-Id: <20260127035756.0DE78C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: fixup zsmalloc-introduce-sg-list-based-object-read-api.patch
has been removed from the -mm tree.  Its filename was
     zsmalloc-introduce-sg-list-based-object-read-api-fix.patch

This patch was dropped because it was folded into zsmalloc-introduce-sg-list-based-object-read-api.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: fixup zsmalloc-introduce-sg-list-based-object-read-api.patch
Date: Sat, 17 Jan 2026 11:48:40 +0900

zs_obj_read_sg_begin() always returns 0, convert it to void (per Yosry).

Link: https://lkml.kernel.org/r/20260117024900.792237-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    4 ++--
 mm/zsmalloc.c            |    6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/zsmalloc.h~zsmalloc-introduce-sg-list-based-object-read-api-fix
+++ a/include/linux/zsmalloc.h
@@ -44,8 +44,8 @@ void *zs_obj_read_begin(struct zs_pool *
 			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 		     size_t mem_len, void *handle_mem);
-int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
-		   struct scatterlist *sg, size_t mem_len);
+void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
--- a/mm/zsmalloc.c~zsmalloc-introduce-sg-list-based-object-read-api-fix
+++ a/mm/zsmalloc.c
@@ -1142,8 +1142,8 @@ void zs_obj_read_end(struct zs_pool *poo
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_end);
 
-int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
-			 struct scatterlist *sg, size_t mem_len)
+void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			  struct scatterlist *sg, size_t mem_len)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1186,8 +1186,6 @@ int zs_obj_read_sg_begin(struct zs_pool
 
 		sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
 	}
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

