Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996EF3195E6
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486688; cv=none; b=d/esGk7zs1b0OXAvCs/50mp9HuXYvKH9jgwvyUSFQhLVDRpP80hkiVZ+a14rW1hP6hzRfN1P5OiVUrWfoFdUJnyQn/++icNVLL16TvuW/+uemzNCJd6qZ8wxzJLD8nPiMvgWtD3IfqI7iEwMYYsYUN+K+V1DvNiH0Z5irQE5cFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486688; c=relaxed/simple;
	bh=roPRFM9GtBfC5F74Ypgm9EcEE7IGntLVxoSsvf5MkBk=;
	h=Date:To:From:Subject:Message-Id; b=Nd7OrTCdcolVLdwoh4de2mfnruCnDJg8qbhiJKX3IJcbVkIr2dF+csUi0bbzXoPrA1LY2/iVqTJ/suU2+kmB+VNkjVxUYQFROArDAnatOTGI4xXS7lgOdPBuhp9eB6KPBj213Dv+mwEXkCSPvS5WqyChtedhlPHdpbDi0mwIvyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gvwY1oWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gvwY1oWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A32C116D0;
	Tue, 27 Jan 2026 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486688;
	bh=roPRFM9GtBfC5F74Ypgm9EcEE7IGntLVxoSsvf5MkBk=;
	h=Date:To:From:Subject:From;
	b=gvwY1oWTZL5tCa3ekxQDTTlQqIeBe0CFCVOSBKytun89ZVAMcWKpdbtJYkuzGPadF
	 J0UH6XL8isL/tGejq8ZJfy0+K2dq5ibTE/ojPTKsyO34h4IuVfzULweExnXSkcrrCN
	 Vra76xADOPrB/1W7X1EV81no+l+1j6T6lcTqYOto=
Date: Mon, 26 Jan 2026 20:04:46 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,bgeffon@google.com,axboe@kernel.dk,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-simplify-read-begin-end-logic.patch removed from -mm tree
Message-Id: <20260127040448.71A32C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: simplify read begin/end logic
has been removed from the -mm tree.  Its filename was
     zsmalloc-simplify-read-begin-end-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: zsmalloc: simplify read begin/end logic
Date: Wed, 7 Jan 2026 14:21:45 +0900

zs_obj_read_begin() currently maps or copies the compressed object with
the prefix handle for !ZsHugePage case.  Make the logic clearer and
more efficient by moving the offset of the object in the page after the
prefix handle instead, only copying the actual object and avoiding the
need to adjust the returned address to account for the prefix.

Adjust the logic to detect spanning objects in zs_obj_read_end()
accordingly, slightly simplifying it by avoiding the need to account
for the handle in both the offset and the object size.

Link: https://lkml.kernel.org/r/20260107052145.3586917-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Co-developed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-simplify-read-begin-end-logic
+++ a/mm/zsmalloc.c
@@ -1088,7 +1088,7 @@ void *zs_obj_read_begin(struct zs_pool *
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
-		mem_len += ZS_HANDLE_SIZE;
+		off += ZS_HANDLE_SIZE;
 
 	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
@@ -1110,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *
 				 0, sizes[1]);
 	}
 
-	if (!ZsHugePage(zspage))
-		addr += ZS_HANDLE_SIZE;
-
 	return addr;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
@@ -1133,11 +1130,9 @@ void zs_obj_read_end(struct zs_pool *poo
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
-		mem_len += ZS_HANDLE_SIZE;
+		off += ZS_HANDLE_SIZE;
 
 	if (off + mem_len <= PAGE_SIZE) {
-		if (!ZsHugePage(zspage))
-			off += ZS_HANDLE_SIZE;
 		handle_mem -= off;
 		kunmap_local(handle_mem);
 	}
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

mm-zswap-use-sg-list-decompression-apis-from-zsmalloc.patch

