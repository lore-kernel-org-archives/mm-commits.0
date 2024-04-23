Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7404013FD6E
	for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2024 19:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713899112; cv=none; b=GhsvWsT4+InqLpuTpBH/lc8eJbLnvWFF75RzTK2Tcd7Ort1vOZIoDEFr1B2HTtebe42cSvRgZaiLHBmw59zH+z+b84N8/co6ALeDVL4ui9azDtGByuPMUBUjVUt0sDDpquR6d1nZg/S/j+7sKdY/n9Jx0NYzutWq/PHQj990NN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713899112; c=relaxed/simple;
	bh=26Wg8I8Sq2/ftvTzjNM+uCqGYP9gA992YeSlbWY+fls=;
	h=Date:To:From:Subject:Message-Id; b=oggq6sFOYjQ3O0Z+aX1I5E4CKvug/4ai7cuyqaS9+iX5BSR4lzXG7+xPIFt9DtvG0LhObIdHDG1Tohf/gri5tR2WksdHI1f8r3VBr8xkbgprV8pIQwZR1uvl9ggASFfYXNZ+K35lWWEaz3z8llo3QeKX1HODawlgnl4NKR9LKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bqS94gmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bqS94gmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCF0C2BD10;
	Tue, 23 Apr 2024 19:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713899112;
	bh=26Wg8I8Sq2/ftvTzjNM+uCqGYP9gA992YeSlbWY+fls=;
	h=Date:To:From:Subject:From;
	b=bqS94gmAx/0gMtqDUa87sJpTxH00a5EJR/tVaFlEH4Jbr7qD/A8DFp0gZpJQ5KteQ
	 Z9eaD4g59K1bcNTkkNGeOF9V1HPbfNp0h5b2LCJAirZHD079qARZKzTaim6VvMM39K
	 MbR0IZHhN89lwK+1UVJDl0hhbeOtQBTWjK/AQ4ho=
Date: Tue, 23 Apr 2024 12:05:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-dont-use-proxy-headers.patch added to mm-unstable branch
Message-Id: <20240423190511.EDCF0C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: don't use "proxy" headers
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-dont-use-proxy-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-dont-use-proxy-headers.patch

This patch will later appear in the mm-unstable branch at
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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: xarray: don't use "proxy" headers
Date: Tue, 23 Apr 2024 17:20:25 +0300

Update header inclusions to follow IWYU (Include What You Use)
principle.

Link: https://lkml.kernel.org/r/20240423142204.2408923-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/xarray.h~xarray-dont-use-proxy-headers
+++ a/include/linux/xarray.h
@@ -12,14 +12,18 @@
 #include <linux/bitmap.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/kconfig.h>
-#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/lockdep.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/mm.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
+struct list_lru;
+
 /*
  * The bottom two bits of the entry determine how the XArray interprets
  * the contents:
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-page_alloc-consolidate-free-page-accounting-fix-4.patch
xarray-use-bits_per_longs.patch
xarray-dont-use-proxy-headers.patch
devres-switch-to-use-dev_err_probe-for-unification.patch
devres-dont-use-proxy-headers.patch

