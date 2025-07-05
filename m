Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFEE13E898
	for <mm-commits@vger.kernel.org>; Sat,  5 Jul 2025 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751752553; cv=none; b=nK5CqJXSj9MdvRyzhAhfmHGefDJWxtwRQBp81J6RRmxZhc4+aCRAf0QjC4qahgQQ7jTDWhOpIAIAyRXL3t82LLUEh9iUJEZSgUbfP3SpkexTc//Cu71fXcgwYox10GajktL36fbzS1dwC+PT9JaQhwhUSAo5kCSyfYSE8nsIlvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751752553; c=relaxed/simple;
	bh=OA6kkGkwhvP0kUuxk3BsC0M527n6XJ6ezm045huSFTg=;
	h=Date:To:From:Subject:Message-Id; b=r/i0o7TdfGyntUi0lNE8Zmd6ElMymmkXeGJHX27n47sqfXfLRsXvLy3FBIPwzJNTFYx399LMKUvPjWDYo6+JWNQZzS9ZJXlVldjRQDQP8J+VzTGMBk/Ggl/ZdWxhrZFvk9r7Hu8My/OlPf8pb0jdKJEsdXzbhQFn2yXjx3EQpbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wodgXF4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wodgXF4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18EBC4CEE7;
	Sat,  5 Jul 2025 21:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751752552;
	bh=OA6kkGkwhvP0kUuxk3BsC0M527n6XJ6ezm045huSFTg=;
	h=Date:To:From:Subject:From;
	b=wodgXF4lRoebO26/OYbtOZZX69q314n9wCqf1jwVtTr+wd/3nzgy38Ax52wcHJ2nx
	 eoNqT5hvQND00gdlRhchj2i7lnDv80cHmH2GdLaszPRmN5/dcrU7IXSKALiZzc54kd
	 Z/BMi4WR7S1xVpk/ot6ztHBUPvYhseUdjm3HHcPw=
Date: Sat, 05 Jul 2025 14:55:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] stackdepot-make-max-number-of-pools-build-time-configurable.patch removed from -mm tree
Message-Id: <20250705215552.A18EBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stackdepot: make max number of pools build-time configurable
has been removed from the -mm tree.  Its filename was
     stackdepot-make-max-number-of-pools-build-time-configurable.patch

This patch was dropped because an updated version will be issued

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


