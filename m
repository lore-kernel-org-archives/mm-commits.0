Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517C92D592C
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 23:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492893; cv=none; b=oxu1Ubqid62DbO3a2B5aubmar5BFK/jYnUKnxMndh+dhiOVh3fWRZJBlZCyARaVHmHymDaoUACsk7T/+6nE7bUYKA6H7AUwIUsO7+xIstPz8XaLKRE08HRamgjEulI2Xow5JXeqIfc6215PY5VWX4BWcZ9qifHz/HP6aG63jzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492893; c=relaxed/simple;
	bh=T1LUE1D5uAVh0LWHsQ1Op4Nz0HsCBTTHl6Mfek7u4Pg=;
	h=Date:To:From:Subject:Message-Id; b=GA03vUNKUrhDj3lQxINWH6GTYBQeaMO5sgvYTTPb1EZd1K4gRBREi9rETg2xidiZt00E5M0UfJJColo+JDwN4BkirAtntXsmPPiYmkOe7VfrNUiT1o+9HGItZXh8gK1RgB+9Dyjx61Vy7ZFWeGSO288fgTiTf5VSrnWwvhkU0Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vR4ZckH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vR4ZckH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206FCC19423;
	Mon,  2 Mar 2026 23:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772492893;
	bh=T1LUE1D5uAVh0LWHsQ1Op4Nz0HsCBTTHl6Mfek7u4Pg=;
	h=Date:To:From:Subject:From;
	b=vR4ZckH1sjnJ5e0M5zLMFTDTKELaG4jPzWgBdtHWlxBU6zlGFv4wNiXi+n12DsBrP
	 NiT4o/ZAjUKKCw+Ogl6rZoMDGCwyZHd1HCxLTM+AF09/uubcJfOrM1BWllezI7FWpw
	 IYuVdWdWTQ593SiVN3c8SihxFfxmC0TPVgSFExGk=
Date: Mon, 02 Mar 2026 15:08:12 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,rdunlap@infradead.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-polynomial-dont-use-proxy-headers.patch added to mm-nonmm-unstable branch
Message-Id: <20260302230813.206FCC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: math: polynomial: don't use 'proxy' headers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-math-polynomial-dont-use-proxy-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-math-polynomial-dont-use-proxy-headers.patch

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
Subject: lib: math: polynomial: don't use 'proxy' headers
Date: Mon, 2 Mar 2026 10:28:08 +0100

Update header inclusions to follow IWYU (Include What You Use) principle.

Link: https://lkml.kernel.org/r/20260302092831.2267785-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/polynomial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/math/polynomial.c~lib-math-polynomial-dont-use-proxy-headers
+++ a/lib/math/polynomial.c
@@ -10,7 +10,8 @@
  *
  */
 
-#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/polynomial.h>
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-polynomial-move-to-math-subfolder.patch
lib-math-polynomial-dont-use-proxy-headers.patch
lib-math-polynomial-remove-link-to-non-exist-file-and-fix-spelling.patch

