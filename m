Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0ED1C3C18
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160838; cv=none; b=cFO8enRAGke6koUnhbZwY97mr15vMp4BrxDI0IsCccsT+pVi4I0i0PICET5otKuyPuE0pitZMi1goqYmzxgY/JS+lX4oYb67LTvces4nktyQFA1sXwneeT5jeKuYPFZXBHxjysEJfGRl9QaA2178iBq9H2yWq67eWPgtNX41zPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160838; c=relaxed/simple;
	bh=Fthy44ShgtDZG1k2RPIMl96TMZzpXgDUCDIjcGHz7To=;
	h=Date:To:From:Subject:Message-Id; b=r1NVRs53PxCFjXWb0vFgmjtZ6rbbcBgRQGwY6c+0ueNvf9o+cMtYmxeJ/vHUzTlTxmxqyTwUiH5wzDhrMv7UI88oiyZCjKXQfw+YLwg4AoSlGrUzkM8MaDA69zuICIrAh07nUkHuqUM/LTuEBJ6H2jlpdR/5s4tzpvtd49385+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PqyBMFOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PqyBMFOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF409C4CEEF;
	Sat,  2 Aug 2025 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160837;
	bh=Fthy44ShgtDZG1k2RPIMl96TMZzpXgDUCDIjcGHz7To=;
	h=Date:To:From:Subject:From;
	b=PqyBMFOGSpvNQuv6/bZA4+7bCrK/wGvpGuaK75DyHevnl29qx0gLBlvvg4KNiaVsf
	 7B3Sbs8Sm0AXDyqVeu2A7fM/dmYT/dRdrkUmo1TPKdoGeEnp7lgL6OT+nwB7rOO5dk
	 ZOHaVT5wH+6EI2LnJreKvJQPhuIeq5RXPplBf3qM=
Date: Sat, 02 Aug 2025 11:53:57 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch removed from -mm tree
Message-Id: <20250802185357.CF409C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: skip quarantine if object is still accessible under RCU
has been removed from the -mm tree.  Its filename was
     kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kasan: skip quarantine if object is still accessible under RCU
Date: Wed, 23 Jul 2025 16:59:19 +0200

Currently, enabling KASAN masks bugs where a lockless lookup path gets a
pointer to a SLAB_TYPESAFE_BY_RCU object that might concurrently be
recycled and is insufficiently careful about handling recycled objects:
KASAN puts freed objects in SLAB_TYPESAFE_BY_RCU slabs onto its quarantine
queues, even when it can't actually detect UAF in these objects, and the
quarantine prevents fast recycling.

When I introduced CONFIG_SLUB_RCU_DEBUG, my intention was that enabling
CONFIG_SLUB_RCU_DEBUG should cause KASAN to mark such objects as freed
after an RCU grace period and put them on the quarantine, while disabling
CONFIG_SLUB_RCU_DEBUG should allow such objects to be reused immediately;
but that hasn't actually been working.

I discovered such a UAF bug involving SLAB_TYPESAFE_BY_RCU yesterday; I
could only trigger this bug in a KASAN build by disabling
CONFIG_SLUB_RCU_DEBUG and applying this patch.

Link: https://lkml.kernel.org/r/20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/kasan/common.c~kasan-skip-quarantine-if-object-is-still-accessible-under-rcu
+++ a/mm/kasan/common.c
@@ -230,16 +230,12 @@ static bool check_slab_allocation(struct
 }
 
 static inline void poison_slab_object(struct kmem_cache *cache, void *object,
-				      bool init, bool still_accessible)
+				      bool init)
 {
 	void *tagged_object = object;
 
 	object = kasan_reset_tag(object);
 
-	/* RCU slabs could be legally used after free within the RCU period. */
-	if (unlikely(still_accessible))
-		return;
-
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
 
@@ -261,7 +257,22 @@ bool __kasan_slab_free(struct kmem_cache
 	if (!kasan_arch_is_ready() || is_kfence_address(object))
 		return false;
 
-	poison_slab_object(cache, object, init, still_accessible);
+	/*
+	 * If this point is reached with an object that must still be
+	 * accessible under RCU, we can't poison it; in that case, also skip the
+	 * quarantine. This should mostly only happen when CONFIG_SLUB_RCU_DEBUG
+	 * has been disabled manually.
+	 *
+	 * Putting the object on the quarantine wouldn't help catch UAFs (since
+	 * we can't poison it here), and it would mask bugs caused by
+	 * SLAB_TYPESAFE_BY_RCU users not being careful enough about object
+	 * reuse; so overall, putting the object into the quarantine here would
+	 * be counterproductive.
+	 */
+	if (still_accessible)
+		return false;
+
+	poison_slab_object(cache, object, init);
 
 	/*
 	 * If the object is put into quarantine, do not let slab put the object
@@ -519,7 +530,7 @@ bool __kasan_mempool_poison_object(void
 	if (check_slab_allocation(slab->slab_cache, ptr, ip))
 		return false;
 
-	poison_slab_object(slab->slab_cache, ptr, false, false);
+	poison_slab_object(slab->slab_cache, ptr, false);
 	return true;
 }
 
_

Patches currently in -mm which might be from jannh@google.com are

kasan-test-fix-protection-against-compiler-elision.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch

