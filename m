Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864371DA58
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 01:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723251862; cv=none; b=Thq/KRvTwo/YxCSbO4AcxnAg/GVoqQkl4OzjS74AdrMy69LBP3r6Zr8pDX5MgDyKACDI6EYtCSkY/NPgAFfbr93TZFHDre51dKwTs1JF6u2lZD7yH0TbKJGxuD9GEPdAecXxTMgjsYN2Re5DDEowmPpHxJangGcH/nyXDVd/dgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723251862; c=relaxed/simple;
	bh=OoZDY1jluILL1I1dueyf/MejaRggI7f3XhsdZXSfxVE=;
	h=Date:To:From:Subject:Message-Id; b=SpOKCsA/62DdrN0OUgwwuyhSnl8QezoK2ioJoEYNLFB/PXqv5piYRpxGq+oMfh447BIGWz0kRPQQpVH+3/dNKAr+rzp3wDsZ5tTvP5GKMnW0rqgfSPKaOOvh2TmJf+H7iGfLctcuhbyhN4NOqiH+qlfV4s3qi2rnB/aX5TjG8p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QOYAJJ2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QOYAJJ2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E2FC32782;
	Sat, 10 Aug 2024 01:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723251862;
	bh=OoZDY1jluILL1I1dueyf/MejaRggI7f3XhsdZXSfxVE=;
	h=Date:To:From:Subject:From;
	b=QOYAJJ2Mi8ox8PNteuC/S9x6z+juxe8LEyENT7kiA1wmDqbs+OiUtwRWCfUVyTJwr
	 Vapio2kaFCPqZ+v2f87gmoc5tiCeq68KfImG+javqL5qJCn9WdOv610E+GDflKlN1z
	 iijsdqnolzJpl/kHp90yuaP8AmxF4nNFDQBn+WHo=
Date: Fri, 09 Aug 2024 18:04:21 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,glider@google.com,elver@google.com,dvyukov@google.com,dsterba@suse.cz,cl@linux.com,andreyknvl@gmail.com,42.hyeyoo@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slub-introduce-config_slub_rcu_debug-v8.patch added to mm-unstable branch
Message-Id: <20240810010421.E0E2FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slub: Introduce CONFIG_SLUB_RCU_DEBUG
has been added to the -mm mm-unstable branch.  Its filename is
     slub-introduce-config_slub_rcu_debug-v8.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slub-introduce-config_slub_rcu_debug-v8.patch

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
Subject: slub: Introduce CONFIG_SLUB_RCU_DEBUG
Date: Fri, 09 Aug 2024 17:36:56 +0200

  - move rcu_barrier() out of locked region (vbabka)
  - rearrange code in slab_free_after_rcu_debug (vbabka)

Link: https://lkml.kernel.org/r/20240809-kasan-tsbrcu-v8-2-aef4593f9532@google.com
Tested-by: syzbot+263726e59eab6b442723@syzkaller.appspotmail.com
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz> (slab)
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   22 +++++++++++++---------
 mm/slub.c        |    5 ++---
 2 files changed, 15 insertions(+), 12 deletions(-)

--- a/mm/slab_common.c~slub-introduce-config_slub_rcu_debug-v8
+++ a/mm/slab_common.c
@@ -576,15 +576,6 @@ void kmem_cache_destroy(struct kmem_cach
 	if (unlikely(!s) || !kasan_check_byte(s))
 		return;
 
-	cpus_read_lock();
-	mutex_lock(&slab_mutex);
-
-	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
-
-	s->refcount--;
-	if (s->refcount)
-		goto out_unlock;
-
 	if (IS_ENABLED(CONFIG_SLUB_RCU_DEBUG) &&
 	    (s->flags & SLAB_TYPESAFE_BY_RCU)) {
 		/*
@@ -593,10 +584,23 @@ void kmem_cache_destroy(struct kmem_cach
 		 * defer their freeing with call_rcu().
 		 * Wait for such call_rcu() invocations here before actually
 		 * destroying the cache.
+		 *
+		 * It doesn't matter that we haven't looked at the slab refcount
+		 * yet - slabs with SLAB_TYPESAFE_BY_RCU can't be merged, so
+		 * the refcount should be 1 here.
 		 */
 		rcu_barrier();
 	}
 
+	cpus_read_lock();
+	mutex_lock(&slab_mutex);
+
+	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
+
+	s->refcount--;
+	if (s->refcount)
+		goto out_unlock;
+
 	err = shutdown_cache(s);
 	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
 	     __func__, s->name, (void *)_RET_IP_);
--- a/mm/slub.c~slub-introduce-config_slub_rcu_debug-v8
+++ a/mm/slub.c
@@ -4563,9 +4563,8 @@ static void slab_free_after_rcu_debug(st
 		return;
 
 	/* resume freeing */
-	if (!slab_free_hook(s, object, slab_want_init_on_free(s), true))
-		return;
-	do_slab_free(s, slab, object, object, 1, _THIS_IP_);
+	if (slab_free_hook(s, object, slab_want_init_on_free(s), true))
+		do_slab_free(s, slab, object, object, 1, _THIS_IP_);
 }
 #endif /* CONFIG_SLUB_RCU_DEBUG */
 
_

Patches currently in -mm which might be from jannh@google.com are

mm-fix-harmless-type-confusion-in-lock_vma_under_rcu.patch
kasan-catch-invalid-free-before-slub-reinitializes-the-object.patch
slub-introduce-config_slub_rcu_debug.patch
slub-introduce-config_slub_rcu_debug-v8.patch

