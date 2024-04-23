Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA86113FD65
	for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2024 19:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713899110; cv=none; b=cBZwfx+G0AHZydBAnxAWTTBHJYDjkWNdl8l1N+chxmhy8Lp6Lt6Qknon64AwzgXgrf54NBKeVwxy78MJ9uZ4bYLfNHYKbU2EGDLKNk7Zihyk+k/ZNwW7Zs14Q/4vWDM47/AisMK4JTNgj8M273ZIwbSLUBf2hp1cuBNYtLhRxTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713899110; c=relaxed/simple;
	bh=LmgHWXCY1Y1n7MUVpDV0dDmksyg+pfdSlAFkYZAIKYg=;
	h=Date:To:From:Subject:Message-Id; b=bFWZha97lAM6BmyaJ4RF3pSav+ai4xY/GzNEEI9gZtWzTKzsIMrmm/ntfI5rdDneuo9tJjxWgbWL3L/4DzFxazUvn8T/ZYJEeea7iGhA2Ue9N/hPzKFQmZEysfjOJessgN3J11VL9AJAaXnc4Ur2ul1JmXfqiJMDJsDBARezL/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=caM7N7ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="caM7N7ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3685EC32781;
	Tue, 23 Apr 2024 19:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713899110;
	bh=LmgHWXCY1Y1n7MUVpDV0dDmksyg+pfdSlAFkYZAIKYg=;
	h=Date:To:From:Subject:From;
	b=caM7N7geK+z0zJYPaRN3XTCEzNEQbVpyG4uFedb1vBmKcXvJEnDQN+z3L424ki5JJ
	 Pi2FyrZAUj9N04qWPQO+FofGH/YN+1zb6pfO8MFbZF+kkP0Plm7d49xUaUkoJoejYj
	 Xuu13qktrEwzu4YdLDDpkjQx4wvzGXD8bUH5IBTY=
Date: Tue, 23 Apr 2024 12:05:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-use-bits_per_longs.patch added to mm-unstable branch
Message-Id: <20240423190510.3685EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: use BITS_PER_LONGS()
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-use-bits_per_longs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-use-bits_per_longs.patch

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
Subject: xarray: use BITS_PER_LONGS()
Date: Tue, 23 Apr 2024 17:20:24 +0300

Patch series "xarray: Clean up xarray.h".

Main portion of this change is to get rid of kernel.h included into other
globally available headers.  This decreases a dependency hell degree.  The
first patch makes it possible to avoid math.h to be included as bitops.h
is implied by bitmap.h.


This patch (of 2):

Use BITS_PER_LONGS() instead of open coded variant.

Link: https://lkml.kernel.org/r/20240423142204.2408923-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/xarray.h~xarray-use-bits_per_longs
+++ a/include/linux/xarray.h
@@ -1146,7 +1146,7 @@ static inline void xa_release(struct xar
 #define XA_CHUNK_SIZE		(1UL << XA_CHUNK_SHIFT)
 #define XA_CHUNK_MASK		(XA_CHUNK_SIZE - 1)
 #define XA_MAX_MARKS		3
-#define XA_MARK_LONGS		DIV_ROUND_UP(XA_CHUNK_SIZE, BITS_PER_LONG)
+#define XA_MARK_LONGS		BITS_TO_LONGS(XA_CHUNK_SIZE)
 
 /*
  * @count is the count of every non-NULL element in the ->slots array
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-page_alloc-consolidate-free-page-accounting-fix-4.patch
xarray-use-bits_per_longs.patch
xarray-dont-use-proxy-headers.patch
devres-switch-to-use-dev_err_probe-for-unification.patch
devres-dont-use-proxy-headers.patch

