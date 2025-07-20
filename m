Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277434409
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 00:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752969861; cv=none; b=jv1DzAWrrvz5MtjmTReqAFXuKzCbQRH3D2aJmmbcXGCkfr8LOUWITk9aWsePXF3/CuWtsDb8wyCJJqAXBDuB/ymb+11YRWQf7tl8QqmGpfrPgpb8vYSPdXktpNgJXTzeKbojsLZ4UdjIGS5R+EQSsGDmuzDCxEWMr6mKQoldaVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752969861; c=relaxed/simple;
	bh=3G/93ThzNXrwl35+R1WPcQisWmX/SHTIpbEFydQra4M=;
	h=Date:To:From:Subject:Message-Id; b=VEz8GAsNniBs7MWj1JGCzZ8SdtRS5v+M9NBwKfwNXxRtGS52rWm4qOMVRV6oO4HPflvob/maa1gv9xx8i8ozJpYuqupUxqW0GuZOwgmEw5oK5IczjsRGuMVKimMWgqp6zgsmicEkL3ISdmKXcDmX1jzFwLsRVoGEBOpAgR/lpxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vchyJELD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vchyJELD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2C7C4CEE3;
	Sun, 20 Jul 2025 00:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752969860;
	bh=3G/93ThzNXrwl35+R1WPcQisWmX/SHTIpbEFydQra4M=;
	h=Date:To:From:Subject:From;
	b=vchyJELD5PbWV4LWAoKk6EgypFNaQ4gSwvs12s39F0mVuK/sBxrSvYB2hsoIxJ1HC
	 2VKrjutrlRtpGZvAwzKYideLhscpXfiw44XKJeHJ0Ul790qA2rL4u72J8C4Yt1UmHQ
	 1OY15OZ6RCEtuaz6WX1dsT5G1jrvTjND0r2zhpFo=
Date: Sat, 19 Jul 2025 17:04:20 -0700
To: mm-commits@vger.kernel.org,snovitoll@gmail.com,ryabinin.a.a@gmail.com,lkp@intel.com,hca@linux.ibm.com,glider@google.com,dvyukov@google.com,christophe.leroy@csgroup.eu,andreyknvl@gmail.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix.patch added to mm-new branch
Message-Id: <20250720000420.9C2C7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix
has been added to the -mm mm-new branch.  Its filename is
     kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix
Date: Sat Jul 19 05:01:18 PM PDT 2025

fix build

>> mm/kasan/tags.c:145:6: error: redefinition of 'kasan_save_free_info'
     145 | void kasan_save_free_info(struct kmem_cache *cache, void *object)
         |      ^
   mm/kasan/kasan.h:403:20: note: previous definition is here
     403 | static inline void kasan_save_free_info(struct kmem_cache *cache, void *object)
         |                    ^

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507190528.W6ndwfyg-lkp@intel.com/
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/tags.c~kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix
+++ a/mm/kasan/tags.c
@@ -142,7 +142,7 @@ void kasan_save_alloc_info(struct kmem_c
 	save_stack_info(cache, object, flags, false);
 }
 
-void kasan_save_free_info(struct kmem_cache *cache, void *object)
+void __kasan_save_free_info(struct kmem_cache *cache, void *object)
 {
 	save_stack_info(cache, object, 0, true);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-introduce-per-node-proactive-reclaim-interface-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch
init-kconfig-restore-config_broken-help-text.patch

