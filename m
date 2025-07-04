Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567341FC0FC
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751661861; cv=none; b=L4G0uT28gfeqMi9CjcY+mtYsm5PdHear7qdr7UF/BZHEfbNJqlbVYv6MPnPkeOB1xlFpbCQy+VHg0n6no/+0ypxw880Nvr8KiK1gdWX0wlz8PXPcoLiVF2ZDUmioVsRp+NxbFlNl+4c7rra2bLPy4OsgU8SxQGoNHqceECPXGNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751661861; c=relaxed/simple;
	bh=GJxW71LazLQo5JgDJ0vc/FDWmqj5e4h7/ABUgVhSfc0=;
	h=Date:To:From:Subject:Message-Id; b=UfIkzjCtw8PpH6tUfvNXByEHNu/9YrETCo/g/VIZLUYAqA3m7+r6BDefsrs/DA2dHg2Ytp8RrmUlpvC4to8ijpqYt1RDMOC875cWOBUi+Of+ZH6zyQ9RSkOAi+rVPORxlUWezbsPPXAx1+HOWM1bj5jYQRfFVnIV/djfDNicnTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e4G5Ypj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e4G5Ypj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8666C4CEEE;
	Fri,  4 Jul 2025 20:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751661860;
	bh=GJxW71LazLQo5JgDJ0vc/FDWmqj5e4h7/ABUgVhSfc0=;
	h=Date:To:From:Subject:From;
	b=e4G5Ypj1MbWoI2reYn8r8avnKfJqcFFlRz0SLKDvtMdIujshsg/xy+WD5K5EPXQBt
	 MJhwuYgTKK9cLAa8N3qbi2qYencnXmWKEvHKj1mN86evqa7YQ7iW5EcvKPPry7Mjbi
	 UV4GWHUCmeupo26zVTABRaTq9I/ivWCon5Y3/oBY=
Date: Fri, 04 Jul 2025 13:44:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-make-max-number-of-pools-build-time-configurable.patch added to mm-nonmm-unstable branch
Message-Id: <20250704204420.C8666C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stackdepot: make max number of pools build-time configurable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     stackdepot-make-max-number-of-pools-build-time-configurable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-make-max-number-of-pools-build-time-configurable.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Matt Fleming <mfleming@cloudflare.com>
Subject: stackdepot: make max number of pools build-time configurable
Date: Fri, 4 Jul 2025 13:06:04 +0100

We're hitting the WARN in depot_init_pool() about reaching the stack depot
limit because we have long stacks that don't dedup very well.

Introduce a new config to allow users to set the number of maximum stack
depot pools at build time.  Also, turn the silent capping into a
build-time assert to provide more obvious feedback when users set this
value too high.

Link: https://lkml.kernel.org/r/20250704120604.2688934-1-matt@readmodwrite.com
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Macro Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig      |    6 ++++++
 lib/stackdepot.c |    8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/lib/Kconfig~stackdepot-make-max-number-of-pools-build-time-configurable
+++ a/lib/Kconfig
@@ -669,6 +669,12 @@ config STACKDEPOT_MAX_FRAMES
 	default 64
 	depends on STACKDEPOT
 
+config STACKDEPOT_MAX_POOLS
+	int "Maximum number of stack depot pools to store stack traces" if EXPERT
+	range 1024 131071
+	default 8192
+	depends on STACKDEPOT
+
 config REF_TRACKER
 	bool
 	depends on STACKTRACE_SUPPORT
--- a/lib/stackdepot.c~stackdepot-make-max-number-of-pools-build-time-configurable
+++ a/lib/stackdepot.c
@@ -36,11 +36,11 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
-#define DEPOT_POOLS_CAP 8192
+#define DEPOT_MAX_POOLS CONFIG_STACKDEPOT_MAX_POOLS
+
 /* The pool_index is offset by 1 so the first record does not have a 0 handle. */
-#define DEPOT_MAX_POOLS \
-	(((1LL << (DEPOT_POOL_INDEX_BITS)) - 1 < DEPOT_POOLS_CAP) ? \
-	 (1LL << (DEPOT_POOL_INDEX_BITS)) - 1 : DEPOT_POOLS_CAP)
+static_assert(DEPOT_MAX_POOLS <= (1LL << (DEPOT_POOL_INDEX_BITS)) - 1);
+
 
 static bool stack_depot_disabled;
 static bool __stack_depot_early_init_requested __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);
_

Patches currently in -mm which might be from mfleming@cloudflare.com are

stackdepot-make-max-number-of-pools-build-time-configurable.patch

