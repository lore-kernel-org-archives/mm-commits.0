Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B719B3FC2;
	Tue,  2 Dec 2025 04:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764648535; cv=none; b=cAdq/HuT13dUNPndAakpIhl+aviqXrtdNmFAJoAvvNnZwhikOHHa9j7p/inPYaTExUTfH37WeoL6d8DRAd39b7Q1hC+k84ezqYhF6g9TEqJnep3c6WnBYpNRc9mUXFw2H4Di5ejmEqg08MMG9wPvE+/R4EkJH0e6KlvihwRBn7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764648535; c=relaxed/simple;
	bh=vthWfx3yrmQlDIqNv2/VStr3y0fTHYXbZYIZalJoJ5Y=;
	h=Date:To:From:Subject:Message-Id; b=tKj3J6nbcsOIsHag3YYdW0o3DksvxgU+qp6PG8AV3rbButlCrQRdALOHcVJZMK2H6eZr9T/YKFecsaeTakczAtaJU5Ksgj6aen655BfuXAh8NGeo4rMftCza821AFK56hzry8fDA8HBRClFuIdPHWuGGpmPEJQFBd6JtitkIuLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H4KePCc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H4KePCc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2219FC4CEF1;
	Tue,  2 Dec 2025 04:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764648535;
	bh=vthWfx3yrmQlDIqNv2/VStr3y0fTHYXbZYIZalJoJ5Y=;
	h=Date:To:From:Subject:From;
	b=H4KePCc8CWty3aDZC4mBZGsFqH4qIm3gfeLFq7S4lXnHAjPCAOjlOxfhSOdt+tq0r
	 tdCVmR+WxqM/A8QEzGqzxZ9uwj+NcjpE6bC+Z8anrgb/v6HXfyPS0qqczQ2J7HEc71
	 3Mq4Oq0fEungBhacJsYr4YJ63rx0aJOabUq7BV4I=
Date: Mon, 01 Dec 2025 20:08:54 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,snovitoll@gmail.com,ryabinin.a.a@gmail.com,ritesh.list@gmail.com,richard@nod.at,lkp@intel.com,johannes@sipsolutions.net,glider@google.com,dvyukov@google.com,anton.ivanov@cambridgegreys.com,andreyknvl@gmail.com,chleroy@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] um-disable-kasan_inline-when-static_link-is-selected.patch removed from -mm tree
Message-Id: <20251202040855.2219FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: um: disable KASAN_INLINE when STATIC_LINK is selected
has been removed from the -mm tree.  Its filename was
     um-disable-kasan_inline-when-static_link-is-selected.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
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


