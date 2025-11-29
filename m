Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4162631063B
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 17:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764438986; cv=none; b=MvtxEpGGU2oBxHFWRNOXOMLDpkpg5f18gA41GseHAKfigUec7Msap9Qp7TyTUV0PUUvqAeUek1txy1SjK87cbnX5tPiEe2QDT9DBfNdZphQEeHjvesuC9Lz04vOzIM/ePdWACxusjqrf3Wq+/vaHe9YapbJ5PLEfv2FMpayLobs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764438986; c=relaxed/simple;
	bh=08UqYqZVDX2Wftg1KrHS4yQABX6yfkbQrP0qi2O0QbE=;
	h=Date:To:From:Subject:Message-Id; b=muqVr66+yrI4kXLQn+VvCKEzEVuktYYIcPnOCMI5OZHQgOqW+SMx9XXnJtu2AOh0jskJCU/3l+mhJElRNEIQg5ZYNJF6eQnRI7a7/sTOIP/nGnzFo3J+a/LHybbfF7FPPDnqze0ewaYL7EnO6vT1GrSJ+Ws3cKhEstmidN/ydBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DhiCQqvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DhiCQqvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B674AC4CEF7;
	Sat, 29 Nov 2025 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764438985;
	bh=08UqYqZVDX2Wftg1KrHS4yQABX6yfkbQrP0qi2O0QbE=;
	h=Date:To:From:Subject:From;
	b=DhiCQqvX7ZL3naWS47XMR3HPZ7waHabTsnzg5vTE/crlv/e0pQ7/A1+ZhiQc44pmB
	 65nAEnxqLzEMkHWOX7oLVR7Bbp2ZNPloSrp8iiTBh5USYYKwV7EwrGRRqTopYdq74b
	 lm4OdIQYc66GdB1U+sq8BwAjphzds7S+DSD3xmcQ=
Date: Sat, 29 Nov 2025 09:56:25 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,snovitoll@gmail.com,ryabinin.a.a@gmail.com,ritesh.list@gmail.com,richard@nod.at,lkp@intel.com,johannes@sipsolutions.net,glider@google.com,dvyukov@google.com,anton.ivanov@cambridgegreys.com,andreyknvl@gmail.com,chleroy@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + um-disable-kasan_inline-when-static_link-is-selected.patch added to mm-hotfixes-unstable branch
Message-Id: <20251129175625.B674AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: um: disable KASAN_INLINE when STATIC_LINK is selected
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     um-disable-kasan_inline-when-static_link-is-selected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/um-disable-kasan_inline-when-static_link-is-selected.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: um: disable KASAN_INLINE when STATIC_LINK is selected
Date: Sat, 29 Nov 2025 10:56:02 +0100

um doesn't support KASAN_INLINE together with STATIC_LINK.

Instead of failing the build, disable KASAN_INLINE when
STATIC_LINK is selected.

Link: https://lkml.kernel.org/r/2620ab0bbba640b6237c50b9c0dca1c7d1142f5d.1764410067.git.chleroy@kernel.org
Fixes: 1e338f4d99e6 ("kasan: introduce ARCH_DEFER_KASAN and unify static key across modes")
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511290451.x9GZVJ1l-lkp@intel.com/
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig             |    1 +
 arch/um/include/asm/kasan.h |    4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/arch/um/include/asm/kasan.h~um-disable-kasan_inline-when-static_link-is-selected
+++ a/arch/um/include/asm/kasan.h
@@ -24,10 +24,6 @@
 
 #ifdef CONFIG_KASAN
 void kasan_init(void);
-
-#if defined(CONFIG_STATIC_LINK) && defined(CONFIG_KASAN_INLINE)
-#error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
-#endif
 #else
 static inline void kasan_init(void) { }
 #endif /* CONFIG_KASAN */
--- a/arch/um/Kconfig~um-disable-kasan_inline-when-static_link-is-selected
+++ a/arch/um/Kconfig
@@ -5,6 +5,7 @@ menu "UML-specific options"
 config UML
 	bool
 	default y
+	select ARCH_DISABLE_KASAN_INLINE if STATIC_LINK
 	select ARCH_NEEDS_DEFER_KASAN if STATIC_LINK
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
 	select ARCH_HAS_CACHE_LINE_SIZE
_

Patches currently in -mm which might be from chleroy@kernel.org are

um-disable-kasan_inline-when-static_link-is-selected.patch

