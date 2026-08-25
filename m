Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBCE233942
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622832; cv=none; b=qOBHwPNgrpZF9/HplHw0aSDtJLnzAk3159eQGnpFr5iJyMwBySxXk/Mo9Kdf9WzpeC9oiSs6mN3G0uuZus1Eb7oNfnPM7IXnCNGsVn+uVoMCbuoVUd6WUYyEFwqnQMa7u08E3a08692GriPQEenRjK9lKc03/3YG33ztrIRO3Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622832; c=relaxed/simple;
	bh=Er/YwcYi+66jafdrXjimjWa6ElUZn7GFl1WWg801Q74=;
	h=Date:To:From:Subject:Message-Id; b=AblORp4NkAkcM9fMwQW8AzYQjtVyU5kVnj9+2wwOh8oPbdEP014cwJZDa249UjpA7vaIhDzGOk9bp8LwMPEN8ApFFuea7PaEn8ArX4YPTMG77szgRt5+Fa/0J1abxr0wz9ygBlXl6WbsYEuqhJ4BoZmWvP0ptTAnAczY9Gx0OkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQo5F1zC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQo5F1zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EB51F00A3A;
	Tue, 25 Aug 2026 01:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622830;
	bh=sQTIbW/XXHrcrvY5pLCypRCm3IRRnmFwP/pZXA/bKUs=;
	h=Date:To:From:Subject;
	b=UQo5F1zCE5yCExEONdTma0kTKVVWCe4uS4PotXD9gOvw3vBMqWU+Dnx83dSgpXQjn
	 dHzULm6LvIrEn7Mxkisc6l91nsI41K9Gx0NfdjrqXf78Q1WCBfWSU54jFdsQpQGd3+
	 qMDwDO3NrMUvQV7vGG+c/l6oraAoPkVonRlO3tYM=
Date: Mon, 24 Aug 2026 18:53:50 -0700
To: mm-commits@vger.kernel.org,baoquan.he@linux.dev,anshuman.khandual@arm.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-do-not-warn-on-enomem-from-va_alloc.patch removed from -mm tree
Message-Id: <20260825015350.C4EB51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: do not warn on -ENOMEM from va_alloc()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-do-not-warn-on-enomem-from-va_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1840,8 +1840,10 @@ va_alloc(struct vmap_area *va,
 
 	/* Update the free vmap_area. */
 	ret = va_clip(root, head, va, nva_start_addr, size);
-	if (WARN_ON_ONCE(ret))
+	if (ret) {
+		WARN_ON_ONCE(ret != -ENOMEM);
 		return ret;
+	}
 
 	return nva_start_addr;
 }
@@ -1914,12 +1916,9 @@ preload_this_cpu_lock(spinlock_t *lock,
 
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


