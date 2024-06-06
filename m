Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012C717BA2;
	Thu,  6 Jun 2024 02:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640414; cv=none; b=BmDImZulQNO1lhJWKvMATFYW4M57xgtFhGGwx+EEm/Sm5grzu8iB5/BW5uCkW/etulfL49/5S02+GUqXNVaJEgxZWSSlVpPwSdbtAWKmroofAW4PLQquevwjXCHzP2vMdKKJFTjhuXcfW/ofHjvVdRRyPrRa7+TThvbJD11XpVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640414; c=relaxed/simple;
	bh=IIvGDybMDGBsf9i9IL2dHgNdPdRpNKIkeQCWsef1wx0=;
	h=Date:To:From:Subject:Message-Id; b=TwmTAwBXMylWHv+IleWI+qb9CYWvnXbi0j8G8hEV7AdBOYUohfijWQwyTvsbgJ/eXW1sUy/0/CS6noeHcgBOABhhFU7x5eJPg+kC4p+V8E4TI7sLmIBHZMgz/aqiMIaFfcAN060JSDCu/S6W8zk0Axsl5oYD78i95/mOq+flml4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hq2NzXQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hq2NzXQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E6DC4AF16;
	Thu,  6 Jun 2024 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640413;
	bh=IIvGDybMDGBsf9i9IL2dHgNdPdRpNKIkeQCWsef1wx0=;
	h=Date:To:From:Subject:From;
	b=Hq2NzXQ02/TeWw5reFJhrXLF8Rl1zSdLmvWdgG9a3BFdOVLePcrRwBkzxQJok//kM
	 W12OQ1IVO3IcQwdS7qmUmoL5tzN9DhlSRD0uoeqIjP0A8K9B5BxrylOA/bkpdY7Vhb
	 12xYzKpCYsR+myoBm5nH2CW28vMhTg+dB5PT+H9U=
Date: Wed, 05 Jun 2024 19:20:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,keescook@chromium.org,elver@google.com,dvyukov@google.com,bjohannesmeyer@gmail.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning.patch removed from -mm tree
Message-Id: <20240606022013.C9E6DC4AF16@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: do not wipe out origin when doing partial unpoisoning
has been removed from the -mm tree.  Its filename was
     kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: do not wipe out origin when doing partial unpoisoning
Date: Tue, 28 May 2024 12:48:06 +0200

As noticed by Brian, KMSAN should not be zeroing the origin when
unpoisoning parts of a four-byte uninitialized value, e.g.:

    char a[4];
    kmsan_unpoison_memory(a, 1);

This led to false negatives, as certain poisoned values could receive zero
origins, preventing those values from being reported.

To fix the problem, check that kmsan_internal_set_shadow_origin() writes
zero origins only to slots which have zero shadow.

Link: https://lkml.kernel.org/r/20240528104807.738758-1-glider@google.com
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
  Link: https://lore.kernel.org/lkml/20240524232804.1984355-1-bjohannesmeyer@gmail.com/T/
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/kmsan/core.c~kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning
+++ a/mm/kmsan/core.c
@@ -196,8 +196,7 @@ void kmsan_internal_set_shadow_origin(vo
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	void *shadow_start;
-	u32 *origin_start;
+	u32 *shadow_start, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
@@ -225,8 +224,16 @@ void kmsan_internal_set_shadow_origin(vo
 	origin_start =
 		(u32 *)kmsan_get_metadata((void *)address, KMSAN_META_ORIGIN);
 
-	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++)
-		origin_start[i] = origin;
+	/*
+	 * If the new origin is non-zero, assume that the shadow byte is also non-zero,
+	 * and unconditionally overwrite the old origin slot.
+	 * If the new origin is zero, overwrite the old origin slot iff the
+	 * corresponding shadow slot is zero.
+	 */
+	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
+		if (origin || !shadow_start[i])
+			origin_start[i] = origin;
+	}
 }
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)
_

Patches currently in -mm which might be from glider@google.com are


