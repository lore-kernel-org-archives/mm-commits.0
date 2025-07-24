Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8058929A5
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 00:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753316780; cv=none; b=S+b7X7SWzvpiknC+FdrbVhC8WPLjZHIR4SKCPjigvxX7j9quS5JBNDIyclxugcWZz5VAo+eLBY+KK5QWdrFhBkKM/J1QE7WEOiFfR0n6H82leqsa2nqVZ7SukTMk7647XxO0O5qr9HydZWkpLAcEdQ47sv6R2w1Dg0Jt/x6Zgr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753316780; c=relaxed/simple;
	bh=bGZd7p01CMrOdzh8PKjG1OGMNB0SYvU0yc9AUiwpLM0=;
	h=Date:To:From:Subject:Message-Id; b=XZ6g6INHaevcKMDNh7LzNV3i1EaFE96yvlzrVH1Z8r2iVuNc3r3ZgQ3CzvlZ3OiY18e9LDgOgDzjYoubdZZfvG1JhhDphqc8kGp/Ey9IFmqYPtT830C34FvbHGI+PVw08vBjInPn6blFF1g5yCFrq7LWjikwpgGVIzFJkeAOW2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xd3DMwRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xd3DMwRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DD4C4CEE7;
	Thu, 24 Jul 2025 00:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753316779;
	bh=bGZd7p01CMrOdzh8PKjG1OGMNB0SYvU0yc9AUiwpLM0=;
	h=Date:To:From:Subject:From;
	b=Xd3DMwRJiMOLvwgy30DAHggNLY8RCLJHwI2KWKBrl4wFltPPGqpZ+KA5SjD8hFaKB
	 EC3wIiAMyYie7aRmL807PL2R2FfQDEpDbB9VtPyI789EnVY6nNwMvjKFWNWn/cC5we
	 wDN7nMrXfuNTmG2j9Ls2lgYt+S02lTJp0Bh0gLUk=
Date: Wed, 23 Jul 2025 17:26:19 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch added to mm-unstable branch
Message-Id: <20250724002619.D0DD4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: skip quarantine if object is still accessible under RCU
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch

