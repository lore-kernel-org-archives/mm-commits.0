Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C919EED3
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 23:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760054242; cv=none; b=ZsRXZMDhy0mhs9zCXwPOxmZtPRKj6LZqFNsDCiTPHHv8o3u07JVGarZtdx22Zs3bTfzr8lb9btKlKufoOXl7YBE6QUf6+PjeAG1PumORdMC9cKtFNZaolRcAGoRJu3sY0BS8qY6bkuMaJ9FCtRyJfHWKFsA5ay+GSmgnHAiYOhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760054242; c=relaxed/simple;
	bh=u4yWDxTokBEFH48D/aiWPICfK3oLVs7VWnnrD1cYjiA=;
	h=Date:To:From:Subject:Message-Id; b=MnqL8MUx2c0mDyeiKOIYPH/sGR2YxkzP4+pBEErvThPUexgXX4+tva+nq7eu2aIE2wI3jfEjC1Q0CkAGdoo7XA3nSi84Ktm4cK6++ZoZIkKyDJlzwSTR0okJSqyeFwwY0Silt0wITDaSwzkHkEYQ9gq1bnRNj9rsCBIFKqf9c2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0X0oXH/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0X0oXH/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1B7C4CEE7;
	Thu,  9 Oct 2025 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760054241;
	bh=u4yWDxTokBEFH48D/aiWPICfK3oLVs7VWnnrD1cYjiA=;
	h=Date:To:From:Subject:From;
	b=0X0oXH/M+hmsBM4RCZwYNQoV3xUKCMANPKRdsY4SL3IZVxXQ8lLEQtehE+ICt6Nc1
	 5UCoh7Rgg1FbF3vJ1bJtHl1F0RH1VPgoxxGCDtVCMPeXthVTun2Swgg4fpF0oHcMvq
	 E7l83iLgpPBCPiuV+RHW+TJiY6lP95p4ztxZ9yXE=
Date: Thu, 09 Oct 2025 16:57:20 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,ritesh.list@gmail.com,glider@google.com,dvyukov@google.com,christophe.leroy@csgroup.eu,bhe@redhat.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-remove-__kasan_save_free_info-wrapper.patch added to mm-new branch
Message-Id: <20251009235721.7B1B7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: remove __kasan_save_free_info wrapper
has been added to the -mm mm-new branch.  Its filename is
     kasan-remove-__kasan_save_free_info-wrapper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-remove-__kasan_save_free_info-wrapper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

kasan-remove-__kasan_save_free_info-wrapper.patch
kasan-cleanup-of-kasan_enabled-checks.patch

