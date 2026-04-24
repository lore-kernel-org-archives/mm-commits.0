Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F4E314D05
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 19:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057401; cv=none; b=qgBi6QFLyKEV1WB8WRmcRDcwNTYWOO0m4h1bcXnTg1QGcEUzf4uwoLbD29XzVppkjmxOCeROoP/xdoUwSW/vFPPTje1qPJ3zbNxOsyFq66eZ81uc8ceLjQV/Ud9Zq1HkX9e4E28mNOrnn14pStOKdIzzHmFeoneHXf3rXTDa7Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057401; c=relaxed/simple;
	bh=JWXkL5C4nJcjfXh5FJsa+fUPpw079c+0EKbY7fNRepc=;
	h=Date:To:From:Subject:Message-Id; b=Bn1AfvEnbKqVu10bEZzN3/T1mrNqZmwrNq4+dzH9v+/xZ01VIjuF/NFIFwl/TSXoyT7xxUK96r6Y7kGiOvDj7bTC7154I4uOOkAI9P7CrskFJ28UhFEABbGzDMz286l61WqvTRm1aA/NTvbw4XhH0lMHtuFek9RhL4W3iq/5wC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bKb0YxwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bKb0YxwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F069C19425;
	Fri, 24 Apr 2026 19:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777057401;
	bh=JWXkL5C4nJcjfXh5FJsa+fUPpw079c+0EKbY7fNRepc=;
	h=Date:To:From:Subject:From;
	b=bKb0YxwDzVB5kCtD8YI9FWUAyfscZJc/mWh9/fJQZExKgu4h5jWn7ME2MCly2Tifg
	 2L8iMkmbowZKT4ifa+P6HlYp+Tmf0uokM6aGBcJ6K/4fP7Z6OBwd8pWqQj1YGNkJ5e
	 9GXqhVas3OpEC3i1QQADwMV9k61HdVx03/lvWVkg=
Date: Fri, 24 Apr 2026 12:03:20 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-string_helpers-dont-use-proxy-headers.patch added to mm-nonmm-unstable branch
Message-Id: <20260424190321.1F069C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: string_helpers: don't use "proxy" headers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-string_helpers-dont-use-proxy-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-string_helpers-dont-use-proxy-headers.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/tests: string_helpers: don't use "proxy" headers
Date: Mon, 6 Apr 2026 21:32:48 +0200

Update header inclusions to follow IWYU (Include What You Use) principle.

Link: https://lore.kernel.org/20260406193425.1534197-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/string_helpers_kunit.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/tests/string_helpers_kunit.c~lib-tests-string_helpers-dont-use-proxy-headers
+++ a/lib/tests/string_helpers_kunit.c
@@ -5,11 +5,16 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <kunit/test.h>
+
 #include <linux/array_size.h>
-#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/limits.h>
+#include <linux/module.h>
 #include <linux/random.h>
-#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/sprintf.h>
 #include <linux/string_helpers.h>
+#include <linux/types.h>
 
 static void test_string_check_buf(struct kunit *test,
 				  const char *name, unsigned int flags,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-tests-string_helpers-decouple-unescape-and-escape-cases.patch
lib-tests-string_helpers-dont-use-proxy-headers.patch

