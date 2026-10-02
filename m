Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2634E3955DB
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 21:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975563; cv=none; b=u77gQerwaEukm6dHRm9IwWDlhjyJnekXpxt8gyQaslZax9ifK/e7GAZWZXLLYkldA+EXpsZlZPkyZFsd2vp168jv1iGQWdJoC6QlqcLq2r2ANlwj73ySlFSTyi0s7qvqVGD4k/Kcb7gN4XqXbGJgaoBF1sPBdszD8rpY26oQViE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975563; c=relaxed/simple;
	bh=6/Rp3y69cEXbDeocTxqqh7fwr7ZuUvtXNK7gPVyicwA=;
	h=Date:To:From:Subject:Message-Id; b=ePyXobstoNdjehYe5qGYX7dO6YHNzD8qx8TZp6vOl5RXB4TsWsTRcGfeOZW6QogAl45glLzVr6feZKXx728ErGAvYEXBYUA+LokTLFahUyhnk+UYgOH/ebgklfBV0x1xSiO/CMR8abmd+apJ6e3mVFaPzKi19yW+IruKLwVPDJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQO/l8AP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQO/l8AP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA591F000FF;
	Fri,  2 Oct 2026 21:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790975561;
	bh=5lvrSZi3lt+1zd1wzZlDG7ke/VcdURfaeZEqVWHHyhk=;
	h=Date:To:From:Subject;
	b=nQO/l8APri3+xjIprjU+ZqoqQ1BiX4RhnHsXI1TKHGmLJHH3Yz8x1coFqlteSjAK0
	 obDYrc7L+9p447eAviBsfZlorygaKcI7frnV7tZiew9zBW7MKOSFpi0F5yWjyEI1XW
	 o3PDRZFVdZ8C9a2ZxuHDHEt6NKAGUyIvFdKclYSc=
Date: Fri, 02 Oct 2026 14:12:41 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,dmytrokoziuk68@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-fix-ioremap-error-cleanup.patch added to mm-new branch
Message-Id: <20261002211241.ADA591F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: fix ioremap error cleanup
has been added to the -mm mm-new branch.  Its filename is
     mm-kmsan-fix-ioremap-error-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-fix-ioremap-error-cleanup.patch

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
From: Dima Koziuk <dmytrokoziuk68@gmail.com>
Subject: mm: kmsan: fix ioremap error cleanup
Date: Fri,  2 Oct 2026 23:05:08 +0300

Looking further at kmsan_ioremap_page_range(), I found three cases where
error cleanup leaks metadata blocks.

1. If the first iteration fails, clean is zero and cleanup is skipped,
   leaking any allocations that succeeded in that iteration.

2. If shadow mapping succeeds but origin mapping fails, the shadow
   pointer has already been cleared. Removing its mapping loses the
   backing block.

3. On failures after completed iterations, cleanup removes the earlier
   metadata mappings without freeing their backing blocks.

The cleanup needed here is the same as for iounmap, so it makes sense to
reuse kmsan_iounmap_pages().  Track the end of installed mappings with
mapped_end and advance it after each successful shadow mapping.  This
includes the current shadow block if origin mapping subsequently fails,
while the helper skips the missing origin mapping.

Run cleanup whenever err is non-zero.  Free allocations that have not been
mapped directly, and use the shared helper to unmap and free the installed
metadata, including blocks from completed iterations.

Link: https://lore.kernel.org/20261002200508.546-2-dmytrokoziuk68@gmail.com
Fixes: fdea03e12aa2 ("mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()")
Signed-off-by: Dima Koziuk <dmytrokoziuk68@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/kmsan/hooks.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

--- a/mm/kmsan/hooks.c~mm-kmsan-fix-ioremap-error-cleanup
+++ a/mm/kmsan/hooks.c
@@ -186,16 +186,17 @@ int kmsan_ioremap_page_range(unsigned lo
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_ZERO;
 	struct page *shadow, *origin;
 	unsigned long off = 0;
-	int nr, err = 0, clean = 0, mapped;
+	unsigned long mapped_end = start;
+	int nr, err = 0, mapped;
 
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
 	kmsan_enter_runtime();
-	for (int i = 0; i < nr; i++, off += PAGE_SIZE, clean = i) {
-		shadow = alloc_pages(gfp_mask, 1);
-		origin = alloc_pages(gfp_mask, 1);
+	for (int i = 0; i < nr; i++, off += PAGE_SIZE) {
+		shadow = alloc_pages(gfp_mask, KMSAN_IOREMAP_META_ORDER);
+		origin = alloc_pages(gfp_mask, KMSAN_IOREMAP_META_ORDER);
 		if (!shadow || !origin) {
 			err = -ENOMEM;
 			goto ret;
@@ -209,39 +210,27 @@ int kmsan_ioremap_page_range(unsigned lo
 			goto ret;
 		}
 		shadow = NULL;
+		mapped_end = start + off + PAGE_SIZE;
 		mapped = __vmap_pages_range_noflush(
 			vmalloc_origin(start + off),
 			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
 			PAGE_SHIFT);
 		if (mapped) {
-			__vunmap_range_noflush(
-				vmalloc_shadow(start + off),
-				vmalloc_shadow(start + off + PAGE_SIZE));
 			err = mapped;
 			goto ret;
 		}
 		origin = NULL;
 	}
-	/* Page mapping loop finished normally, nothing to clean up. */
-	clean = 0;
 
 ret:
-	if (clean > 0) {
-		/*
-		 * Something went wrong. Clean up shadow/origin pages allocated
-		 * on the last loop iteration, then delete mappings created
-		 * during the previous iterations.
-		 */
+	if (err) {
 		if (shadow)
-			__free_pages(shadow, 1);
+			__free_pages(shadow, KMSAN_IOREMAP_META_ORDER);
 		if (origin)
-			__free_pages(origin, 1);
-		__vunmap_range_noflush(
-			vmalloc_shadow(start),
-			vmalloc_shadow(start + clean * PAGE_SIZE));
-		__vunmap_range_noflush(
-			vmalloc_origin(start),
-			vmalloc_origin(start + clean * PAGE_SIZE));
+			__free_pages(origin, KMSAN_IOREMAP_META_ORDER);
+
+		if (mapped_end > start)
+			kmsan_iounmap_pages(start, mapped_end);
 	}
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
_

Patches currently in -mm which might be from dmytrokoziuk68@gmail.com are

mm-kmsan-fix-iounmap-metadata-teardown.patch
mm-kmsan-fix-ioremap-error-cleanup.patch

