Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ABA2940B
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747009619; cv=none; b=hRq5lbt47AZUshCJtFz4ch9sQGTjSfwkOTH3DBbAHcTkVMveoNvSz/MsnIbSV5GWgvKHlCXRTi4nQtv7VXo/ox+iv+ofuIYdgaEu6gfwvNrnWBnro7tiebq0obpGFd3FO7LIC3orBl1bc6X6dJGYAmhDCT+KeoZPeBbhRQlgJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747009619; c=relaxed/simple;
	bh=bCFeONf0GAXgiFL4xXoQ8pjOTyl95i2H8FqSJceBISY=;
	h=Date:To:From:Subject:Message-Id; b=hiI6yANFGtbXW0+2eyd7P9Y5KiblnGjgR+vI4jNOWgxL//D0/p/YSiPVfJHYQDUVqjQjH0arGMUuQB/zM2TvKeJOQjE3aP6atcSpTI6sP/AY7FJd+MoLQFweXCjjBzk/Oe8IHkET3VyRVsCDS21z3H5luY5xGz1ziKC5tbmQFTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rR0HKeLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rR0HKeLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA45C4CEED;
	Mon, 12 May 2025 00:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747009618;
	bh=bCFeONf0GAXgiFL4xXoQ8pjOTyl95i2H8FqSJceBISY=;
	h=Date:To:From:Subject:From;
	b=rR0HKeLaiMbVTy/RGyRwbOrcXgPazS/ORbZP5lC8JdNWcX2YCT+72C1CIAOKq1Ay0
	 ETVdzPx0hmRdDq8S/pfrMGwbyItP7qtR5g7aqIw01OC3jIvuq2N0micYndmta7iJc9
	 anlneKUiA4osTGDg0k70/4IgdvYgQYPXozySRsR0=
Date: Sun, 11 May 2025 17:26:58 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,igor.b@beldev.am,hannes@cmpxchg.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch removed from -mm tree
Message-Id: <20250512002658.DBA45C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: don't underflow size calculation in zs_obj_write()
has been removed from the -mm tree.  Its filename was
     zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: don't underflow size calculation in zs_obj_write()
Date: Wed, 7 May 2025 14:42:24 +0900

Do not mix class->size and object size during offsets/sizes calculation in
zs_obj_write().  Size classes can merge into clusters, based on
objects-per-zspage and pages-per-zspage characteristics, so some size
classes can store objects smaller than class->size.  This becomes
problematic when object size is much smaller than class->size.  zsmalloc
can falsely decide that object spans two physical pages, because a larger
class->size value is used for that check, while the actual object is much
smaller and fits the free space of the first physical page, so there is
nothing to write to the second page and memcpy() size calculation
underflows.

 Unable to handle kernel paging request at virtual address ffffc00081ff4000
 pc : __memcpy+0x10/0x24
 lr : zs_obj_write+0x1b0/0x1d0 [zsmalloc]
 Call trace:
  __memcpy+0x10/0x24 (P)
  zram_write_page+0x150/0x4fc [zram]
  zram_submit_bio+0x5e0/0x6a4 [zram]
  __submit_bio+0x168/0x220
  submit_bio_noacct_nocheck+0x128/0x2c8
  submit_bio_noacct+0x19c/0x2f8

This is mostly seen on system with larger page-sizes, because size class
cluters of such systems hold wider size ranges than on 4K PAGE_SIZE
systems.

Assume a 16K PAGE_SIZE system, a write of 820 bytes object to a 864-bytes
size class at offset 15560.  15560 + 864 is more than 16384 so zsmalloc
attempts to memcpy() it to two physical pages.  However, 16384 - 15560 =
824 which is more than 820, so the object in fact doesn't span two
physical pages, and there is no data to write to the second physical page.

We always know the exact size in bytes of the object that we are about to
write (store), so use it instead of class->size.

Link: https://lkml.kernel.org/r/20250507054312.4135983-1-senozhatsky@chromium.org
Fixes: 44f76413496e ("zsmalloc: introduce new object mapping API")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Igor Belousov <igor.b@beldev.am>
Tested-by: Igor Belousov <igor.b@beldev.am>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-dont-underflow-size-calculation-in-zs_obj_write
+++ a/mm/zsmalloc.c
@@ -1243,19 +1243,19 @@ void zs_obj_write(struct zs_pool *pool,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	if (!ZsHugePage(zspage))
+		off += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		void *dst = kmap_local_zpdesc(zpdesc);
 
-		if (!ZsHugePage(zspage))
-			off += ZS_HANDLE_SIZE;
 		memcpy(dst + off, handle_mem, mem_len);
 		kunmap_local(dst);
 	} else {
 		/* this object spans two pages */
 		size_t sizes[2];
 
-		off += ZS_HANDLE_SIZE;
 		sizes[0] = PAGE_SIZE - off;
 		sizes[1] = mem_len - sizes[0];
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-modernize-writeback-interface.patch
zsmalloc-cleanup-headers-includes.patch
documentation-zram-update-idle-pages-tracking-documentation.patch

