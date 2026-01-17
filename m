Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF571850A4
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768620498; cv=none; b=e1uEtvW9wvz1dEN6S4t+h4vUlMXPwJPOOvJziOQ/X/2I7avsKevWAPLV/pARReH608xXFV9DBfj4qDvylySW3oorTcRT4SnLjYoRNz0hh492UkxuUwHBTul7Rn72jKfS2p0bsZIPf6JKIi2rK1sWhN9JXYkdtltHzZABKWxH63U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768620498; c=relaxed/simple;
	bh=tuFTAzpGIwRl/bQGMiG+fntHNohMOJEt1s5JjTq/2i4=;
	h=Date:To:From:Subject:Message-Id; b=iR0xlFBsFLcpY1mlOpBjUKekBlVHLEZY15lNiAlUUIqcaFRvVhA+UqTKdNYdS8cNnsjusdW3lpJhKQRfRySXbCh1pyBdU8fFjmqSI1YmZ652S+QSk8ahXkWKyaPdh7cIq8uEgX7EqNQU4IBmbJHG2+xr8c6zG3xmst+38Hp0xys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sXMaUXb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sXMaUXb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCECC4CEF7;
	Sat, 17 Jan 2026 03:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768620497;
	bh=tuFTAzpGIwRl/bQGMiG+fntHNohMOJEt1s5JjTq/2i4=;
	h=Date:To:From:Subject:From;
	b=sXMaUXb5Uzw6NT2jQpw9zNF2ElXX75Me+Gzr++a+K7mFFY5q76b1p+o0THMHSE8R/
	 +QrAmu7m+tM9XNheM5nPXSmv80fND+X6OrHKKNnfCuRbCSCFspj+caa+Gg5SXVbSpe
	 XtOPXwagifwqdnZG2L+fHcEzQkKuu3+4OA4bKXsw=
Date: Fri, 16 Jan 2026 19:28:17 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,minchan@kernel.org,herbert@gondor.apana.org.au,hannes@cmpxchg.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-introduce-sg-list-based-object-read-api-fix.patch added to mm-unstable branch
Message-Id: <20260117032817.CFCECC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: fixup zsmalloc-introduce-sg-list-based-object-read-api.patch
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-introduce-sg-list-based-object-read-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-introduce-sg-list-based-object-read-api-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch
zram-use-u32-for-entry-ac_time-tracking.patch
zram-rename-internal-slot-api.patch
zram-rename-internal-slot-api-fix.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-fixup-read_block_state.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch

