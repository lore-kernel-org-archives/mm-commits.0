Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E31B35CB6D
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966036; cv=none; b=LKVOvORAx3lpe1zMXE8YBAjHR+awTonuy1B+t/5ovVPEWtozLdGaoSaOna2sb35HtO0+wsl0iNzT6ZO3JnzJ1ZqjxAQ8u6F82jH8bgTy/IIXwBiFzJfZHNDSVkScB2qgJ3Hv44kzHTlsFY8U6EunQtppvBCgaom8AbI1tUAxCUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966036; c=relaxed/simple;
	bh=tmWYWTqEsMsReOH/lDVMPjxA7mG9B3bGxAO3GmQn5t8=;
	h=Date:To:From:Subject:Message-Id; b=StlKV4khEUVAuu/7q148Fe2mY4gOhLwI5coHpOgN8eLlustgmCUS1z2+Dt0mID5lL5HzhRcdSCD0oRNiTfmyXB0Zlef0X0xBZo/B34y9xV8UTjGDmWHFTCKM11oINOXXfwrYz8kkyBFGXEFQAsdl062I7Rxrzva6JDrE4Lp2L3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=omD6T2//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="omD6T2//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393F9C16AAE;
	Wed, 21 Jan 2026 03:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966035;
	bh=tmWYWTqEsMsReOH/lDVMPjxA7mG9B3bGxAO3GmQn5t8=;
	h=Date:To:From:Subject:From;
	b=omD6T2//1VZmAwl+rHpk9NQiJ3N2IAnV2Edd+9YWheYS6IAnyHbJsigymq6BzmW6L
	 fe57fPq29XX6DyYSWEDOQ+wxByrN6+N5pLopgq9deaojhjn69BY8WITk2EjhuASuLe
	 f25x5+dHNlEsEIVfYcDeysRu+/hdSL0MvYkbq0Pc=
Date: Tue, 20 Jan 2026 19:27:14 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,clm@meta.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-trivial-fix-of-recompress_slot-coding-styles.patch removed from -mm tree
Message-Id: <20260121032715.393F9C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: trivial fix of recompress_slot() coding styles
has been removed from the -mm tree.  Its filename was
     zram-trivial-fix-of-recompress_slot-coding-styles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: trivial fix of recompress_slot() coding styles
Date: Mon, 15 Dec 2025 14:47:13 +0900

A minor fixup of 80-cols breakage in recompress_slot() comment and
zs_malloc() call.

Link: https://lkml.kernel.org/r/ff3254847dbdc6fbd2e3fed53c572a261d60b7b6.1765775954.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Chris Mason <clm@meta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-trivial-fix-of-recompress_slot-coding-styles
+++ a/drivers/block/zram/zram_drv.c
@@ -2517,14 +2517,15 @@ static int recompress_slot(struct zram *
 	 * avoid direct reclaim.  Allocation error is not fatal since
 	 * we still have the old object in the mem_pool.
 	 *
-	 * XXX: technically, the node we really want here is the node that holds
-	 * the original compressed data. But that would require us to modify
-	 * zsmalloc API to return this information. For now, we will make do with
-	 * the node of the page allocated for recompression.
+	 * XXX: technically, the node we really want here is the node that
+	 * holds the original compressed data. But that would require us to
+	 * modify zsmalloc API to return this information. For now, we will
+	 * make do with the node of the page allocated for recompression.
 	 */
 	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
 			       GFP_NOIO | __GFP_NOWARN |
-			       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+			       __GFP_HIGHMEM | __GFP_MOVABLE,
+			       page_to_nid(page));
 	if (IS_ERR_VALUE(handle_new)) {
 		zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle_new);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

