Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45278218EB1
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343122; cv=none; b=tbtA+/J5uAAM46p6khXr2I1zfh+acnXqJfjh5Wg1LlZTMCXJOXlFgb1VkHR1TZc36xwxZ0S3gpUvK2rFWkhe0G+jiFGEx/YRyiUQxd1H95Zg7V/Ue0XYURfnRdEaJvnkNzsWSF0YS1jxXJEW5gFSwbGXVdi80fUDwmycE5a0ic0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343122; c=relaxed/simple;
	bh=e05zBUU64ZJv6jl1YJyu4bfzRifvYfdzD5rAu4tw8Tk=;
	h=Date:To:From:Subject:Message-Id; b=RO/UsFOEMFTc0BM8GSFca7fLjVGihHAHjj2Rs8Zh11LfecMLzIMpJlbpPjpYC8bD9mYp7noRI4LpAKvUgkZgLL5BktpCwDiGvmlOM6fDDmFM8633Q8Z0N41AROoXZdR2sjQyJygUEN+Kl0JqSu0AgiFbnsLTJJABTUb7GOCGVDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lWzPC5/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lWzPC5/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FD7C19422;
	Mon, 17 Nov 2025 01:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343122;
	bh=e05zBUU64ZJv6jl1YJyu4bfzRifvYfdzD5rAu4tw8Tk=;
	h=Date:To:From:Subject:From;
	b=lWzPC5/gL4iNUjeSe6zCRi+EbhmdUSvz/kTLz7q2l6dvagtDFIzDfwjEF0BxjBtZK
	 r4JOKw8VVgHrfR36oPzZRuCtBTr+lptcRXNuQXPcQUZKjHtgY4p+2nGSckt/pquf5A
	 2HRi+4+om2YvTjbgRfMXc4heVb2yQCAQ024MW/+Y=
Date: Sun, 16 Nov 2025 17:32:01 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,ritesh.list@gmail.com,glider@google.com,dvyukov@google.com,christophe.leroy@csgroup.eu,bhe@redhat.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-remove-__kasan_save_free_info-wrapper.patch removed from -mm tree
Message-Id: <20251117013202.10FD7C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: remove __kasan_save_free_info wrapper
has been removed from the -mm tree.  Its filename was
     kasan-remove-__kasan_save_free_info-wrapper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan: remove __kasan_save_free_info wrapper
Date: Thu, 9 Oct 2025 20:54:02 +0500

Patch series "kasan: cleanups for kasan_enabled() checks".

This patch series is the continuation of [1] the previous discussion
related to the KASAN internal refactoring.

Here we remove kasan_enabled() checks which are duplicated by higher
callers.  These checks deduplication are also related to the separate
patch series [2].


This patch (of 2):

We don't need a kasan_enabled() check in kasan_save_free_info() at all. 
Both the higher level paths (kasan_slab_free and
kasan_mempool_poison_object) already contain this check.  Therefore,
remove the __wrapper.

Link: https://lkml.kernel.org/r/20251009155403.1379150-1-snovitoll@gmail.com
Link: https://lkml.kernel.org/r/20251009155403.1379150-2-snovitoll@gmail.com
Link: https://lore.kernel.org/all/CA+fCnZce3AR+pUesbDkKMtMJ+iR8eDrcjFTbVpAcwjBoZ=gJnQ@mail.gmail.com/ [1]
Link: https://lore.kernel.org/all/aNTfPjS2buXMI46D@MiWiFi-R3L-srv/ [2]
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    2 +-
 mm/kasan/kasan.h   |    7 +------
 mm/kasan/tags.c    |    2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

--- a/mm/kasan/generic.c~kasan-remove-__kasan_save_free_info-wrapper
+++ a/mm/kasan/generic.c
@@ -573,7 +573,7 @@ void kasan_save_alloc_info(struct kmem_c
 	kasan_save_track(&alloc_meta->alloc_track, flags);
 }
 
-void __kasan_save_free_info(struct kmem_cache *cache, void *object)
+void kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 	struct kasan_free_meta *free_meta;
 
--- a/mm/kasan/kasan.h~kasan-remove-__kasan_save_free_info-wrapper
+++ a/mm/kasan/kasan.h
@@ -399,12 +399,7 @@ void kasan_set_track(struct kasan_track
 void kasan_save_track(struct kasan_track *track, gfp_t flags);
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags);
 
-void __kasan_save_free_info(struct kmem_cache *cache, void *object);
-static inline void kasan_save_free_info(struct kmem_cache *cache, void *object)
-{
-	if (kasan_enabled())
-		__kasan_save_free_info(cache, object);
-}
+void kasan_save_free_info(struct kmem_cache *cache, void *object);
 
 #ifdef CONFIG_KASAN_GENERIC
 bool kasan_quarantine_put(struct kmem_cache *cache, void *object);
--- a/mm/kasan/tags.c~kasan-remove-__kasan_save_free_info-wrapper
+++ a/mm/kasan/tags.c
@@ -142,7 +142,7 @@ void kasan_save_alloc_info(struct kmem_c
 	save_stack_info(cache, object, flags, false);
 }
 
-void __kasan_save_free_info(struct kmem_cache *cache, void *object)
+void kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 	save_stack_info(cache, object, 0, true);
 }
_

Patches currently in -mm which might be from snovitoll@gmail.com are


