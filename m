Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F2A373BE4
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028840; cv=none; b=J1hIzm+eKd6RiNNcxXPezFIAIQy6PsHDL7jHYO4VwNul4AYJ2M17Y7Hc+kkPBV6vuf7ruy3JSXRJ5VoiIO2FkTJ7lKnl0/BlPJTx158CZY4BsbpSwOprCKovkJThwmDDN2AAjJ0+R1XHRTrHhQfge5eX5UTJkbASOn+tdLx/irQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028840; c=relaxed/simple;
	bh=TLkMxP3KwHSCvBW1iv/va/FvM5sCUqRZNZOOjRmWhW0=;
	h=Date:To:From:Subject:Message-Id; b=FHcbQbq0mwR+Dj5lQiQObF+OHIqqW6t61tCP75Jq5Z8Thn+WECjLhhe7ZFuo8V5ncVRq5+p88M/bxQwCWPCrl4UQ4yorDwmcDiBfvljNt3J5lzf0RQavo5DXtOOY2zw1yb5pBd8a25z7x2jcYx/4QM9NWmwCd1tzBV40iV4/zzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WYQsJfgZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WYQsJfgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF28D1F00893;
	Fri, 29 May 2026 04:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028839;
	bh=t8ciJGyF8etWvHbaoPtBj6Eb2/J8Jytaw0g84FyIUlI=;
	h=Date:To:From:Subject;
	b=WYQsJfgZSrhjCZtAePzFVjrJocx0U+dN9Ene5hXvs5FCre63F132in1Vo27hzQ0Wd
	 giFi3J6ur/KXiRhZozFhz3nqFSVxAcBQg0SuvxoS+KPwH9h2xF2MvrhDflo12fAdqV
	 duOFAU44WinH5e/wtEFMcXIXRzPepNXvUoHvIYPA=
Date: Thu, 28 May 2026 21:27:18 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,andy@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] string-use-min-in-sized_strscpy.patch removed from -mm tree
Message-Id: <20260529042718.DF28D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: string: use min in sized_strscpy
has been removed from the -mm tree.  Its filename was
     string-use-min-in-sized_strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: string: use min in sized_strscpy
Date: Thu, 14 May 2026 18:56:03 +0200

Use min() and drop the limit variable to simplify sized_strscpy().

Link: https://lore.kernel.org/20260514165601.527883-3-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/lib/string.c~string-use-min-in-sized_strscpy
+++ a/lib/string.c
@@ -21,6 +21,7 @@
 #include <linux/errno.h>
 #include <linux/limits.h>
 #include <linux/linkage.h>
+#include <linux/minmax.h>
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -125,11 +126,8 @@ ssize_t sized_strscpy(char *dest, const
 	 * If src is unaligned, don't cross a page boundary,
 	 * since we don't know if the next page is mapped.
 	 */
-	if ((long)src & (sizeof(long) - 1)) {
-		size_t limit = PAGE_SIZE - ((long)src & (PAGE_SIZE - 1));
-		if (limit < max)
-			max = limit;
-	}
+	if ((long)src & (sizeof(long) - 1))
+		max = min(PAGE_SIZE - ((long)src & (PAGE_SIZE - 1)), max);
 #else
 	/* If src or dest is unaligned, don't do word-at-a-time. */
 	if (((long) dest | (long) src) & (sizeof(long) - 1))
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-mseal-use-min-max-in-mseal_apply.patch

