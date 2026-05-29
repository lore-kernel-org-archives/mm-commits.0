Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889BD35AC01
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028749; cv=none; b=DyrAUhLABdG9dQc27wK7cG2or7mCpAMBh0pzhenSdSDZvDMjAtEq+2n4ojn8cl0k3e3c7N8Q8hcAI1ujcnb99otXNTmysEDh+w0RJrBvhgIewfrtq7x9NWogtEjIER9hA4qqB/OwTsotJJMvi5HeJpz+XlwY0D0BAQGQ76YzACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028749; c=relaxed/simple;
	bh=mVvqPGtcVuMMxtUv4D+99kOATs24E4zp2g2PlddMrZ0=;
	h=Date:To:From:Subject:Message-Id; b=U5fAqA9gih2vkNMUVmS9Wm6gq0zQypsRLMrUMQRdOkRVFyVrBTJplEDs9bNu1saLSrEuovhP4wGWdIXPgyHp1o1m7JRGpCm67Ms7syY5t9U8/M+L0ciwSIWKKFloymd4SzkD3379pEX1+pepvqL0eYh/hRAxljWcTGEErNoORxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qp7qgPgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qp7qgPgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F931F00899;
	Fri, 29 May 2026 04:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028748;
	bh=JDrmvEXsAbsee6skIQeF4SsSesBDY+yYuXs/bAbtp5E=;
	h=Date:To:From:Subject;
	b=Qp7qgPgUDL795ASv2DHZ1mO367bJ444ALX55zxjG9MV55daGIOh5oQxLIPCVXXATo
	 AZ6+lHRw+F95OleObXAQ4+1NmybufyAWR0McgdpfXncFMbkPRGNFLSm/g+pFEo1axf
	 864sjUCHBQCBqMAX+eCEe2fNqN6WPZCS1536rXOY=
Date: Thu, 28 May 2026 21:25:47 -0700
To: mm-commits@vger.kernel.org,kees@kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-tests-string_helpers-dont-use-proxy-headers.patch removed from -mm tree
Message-Id: <20260529042548.00F931F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/tests: string_helpers: don't use "proxy" headers
has been removed from the -mm tree.  Its filename was
     lib-tests-string_helpers-dont-use-proxy-headers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


