Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BB436BCDA
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 00:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785804757; cv=none; b=H+JMtymIV8ooT2WVxP4+kUJjiR0IelhfM9DllPQhoDh6bnByGIpdmXJCOPR0VIDHIxQKKAccmF5+8ZoItMN5BTe+jZ7DDzDVNN/M6+0F6c/BxPQznl6c1nA14+R07QjH4DAeYacoib0Qrx0eq6ENCypUgSeCme9ymT53th+FLWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785804757; c=relaxed/simple;
	bh=jy/EqcVhMQzFTGpsqdDwVQxwtvP11viNRAgvGiFcyFQ=;
	h=Date:To:From:Subject:Message-Id; b=f+EeCDTZG8GUN77sTyWOIQ5IBCZZZNg0uuT2anot92wI8Qp7CBgXU3G09gZ0tLJHDXzM/sTye3D938CJbq/ROq3EeQpeQ7SSguyLQPLNJfiBuKXY3m5/vA5SxffZnwepxjlSjcYzh7YW/h5hzo90RzmrzAM+vIXRhyZ9zqNRgZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hwP7mA40; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hwP7mA40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5001F000E9;
	Tue,  4 Aug 2026 00:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785804756;
	bh=vFQ6yzAinI1P6iNqCFw3iQGf8a6vwSlBOWteTURgdEg=;
	h=Date:To:From:Subject;
	b=hwP7mA409DKSzTtN6GfbJU/preO99wdvk57u3ypwk0N9E2D380Gc7p0v6itTydn2X
	 TeneFMOGgblMfthKDWy28xmG3wJf/pvjB8WV7b9kl6X2lMXSF4CpHKCOj9cxEVlJT0
	 hcyPJ6VvARfNFs93UmPgme2NNCmWRnfz9/Iw8Mvg=
Date: Mon, 03 Aug 2026 17:52:35 -0700
To: mm-commits@vger.kernel.org,baoquan.he@linux.dev,anshuman.khandual@arm.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-do-not-warn-on-enomem-from-va_alloc.patch added to mm-new branch
Message-Id: <20260804005235.ED5001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: do not warn on -ENOMEM from va_alloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-do-not-warn-on-enomem-from-va_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-do-not-warn-on-enomem-from-va_alloc.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: do not warn on -ENOMEM from va_alloc()
Date: Sun, 2 Aug 2026 12:46:27 +0200

Since vmalloc() accepts non-blocking GFP flags, allocation requests may
fail when callers pass restrictive GFP masks.

va_clip() may return -ENOMEM when its GFP_NOWAIT fallback allocation fails
during NE_FIT_TYPE splitting.  This is an expected failure, so va_alloc()
should return the error without triggering a kernel splat.

Link: https://lore.kernel.org/20260802104627.63892-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6a6d3cbd.6ce73036.24301b.000e.GAE@google.com
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-do-not-warn-on-enomem-from-va_alloc
+++ a/mm/vmalloc.c
@@ -1875,8 +1875,10 @@ va_alloc(struct vmap_area *va,
 
 	/* Update the free vmap_area. */
 	ret = va_clip(root, head, va, nva_start_addr, size);
-	if (WARN_ON_ONCE(ret))
+	if (ret) {
+		WARN_ON_ONCE(ret != -ENOMEM);
 		return ret;
+	}
 
 	return nva_start_addr;
 }
@@ -1949,12 +1951,9 @@ preload_this_cpu_lock(spinlock_t *lock,
 
 	/*
 	 * Preload this CPU with one extra vmap_area object. It is used
-	 * when fit type of free area is NE_FIT_TYPE. It guarantees that
-	 * a CPU that does an allocation is preloaded.
-	 *
-	 * We do it in non-atomic context, thus it allows us to use more
-	 * permissive allocation masks to be more stable under low memory
-	 * condition and high memory pressure.
+	 * when fit type of free area is NE_FIT_TYPE. It is best effort
+	 * pre-loading. If it fails va_clip() may return -ENOMEM from its
+	 * GFP_NOWAIT fallback.
 	 */
 	if (!this_cpu_read(ne_fit_preload_node))
 		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-do-not-warn-on-enomem-from-va_alloc.patch

