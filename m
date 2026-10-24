Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832449;
	b=DDnOtEXE5ZyWs7JrTizTNOPZndjUIzz/H3nRd6HyoY/PoeeOvKxztscfklKClKO+CryQ
	 SeGekOZ4hpERuWoq0uUiPLqvxKOeS4Rbap8SESKHqluGfbhcbQ9Utimpw5y0TmWaXwNbd
	 pNLJIaJiM1KAn+rG2o+unLX/rfNR5CNcHRaW9Ml+NxkcEsJLQ8SDO4617sKOVqBXo6kLz
	 6TbYSeRqlZ0Bc2+vrQaCbFeBYXvHpwuFcjF9bn13q0+IvLyCsihfwCTvtnrLSGrwb0RRs
	 VKR2xL1oR7U2/uNtE8DIeCtHW/G7qEEIsMsoZKXBfqhUTZwbCEWZHjbH7ZOjWzsfRMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832449;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=5sfge2dXnqz4W/VMlEEAuGvP5nfBahOgzZnHLXGKD9w=;
	b=NmK7zSqhGnNTVl8JwKY+DVZK1Jwp/OwfZI8yRqhvvo694EvxGkxf+NGz6LHpkfEeLPNf
	 2zawS/lCUyKfJ+UnvIE3fKiLsJphrIeOgWxoAzXjFAwdfFV/f1iIBlcY1J78a2JAhjjN0
	 4zdmy45pK3OyJKbWGtdskYaOH2FQRM5s2vplPQCd9YmE/s13O5lngP/VOSU4wnS07PyMe
	 hxiJN3UKEtIPfo+/lIqLC5lXfSugS5ItqJdj6Vscrq5yVccIik8F0WjVnt713qsX32vCm
	 9n2JCXNfcXHe5mb3+r9TYyu/98anuWfzSW1UrbTBo8Nl0lLJJvKBUEeyQ5A9oOzmynQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bMGBPFDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B449606A322
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bMGBPFDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AD21F01828;
	Sat, 24 Oct 2026 09:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832448;
	bh=5sfge2dXnqz4W/VMlEEAuGvP5nfBahOgzZnHLXGKD9w=;
	h=Date:To:From:Subject;
	b=bMGBPFDcWOU6Y9ZxIK4zNqzmRLEwgp0uZ92P1U/mXjBsPrviI9u9fBszqvkmisHR5
	 f2FOItGmu163sEmpSCZxshnqjSwNf+W/XWcDItibvij/4eFNoKtPazSdnV/7gOp/JO
	 /fnll/f0Gi6mbt7iTpDtusXn3KHsdAoKYT0eVw4g=
Date: Sat, 24 Oct 2026 02:00:48 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,dmytrokoziuk68@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmsan-fix-ioremap-error-cleanup.patch removed from -mm tree
Message-Id: <20261024090048.D4AD21F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: kmsan: fix ioremap error cleanup
has been removed from the -mm tree.  Its filename was
     mm-kmsan-fix-ioremap-error-cleanup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


