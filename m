Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC97023A9B3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676261; cv=none; b=Y5qrgCfRYcDAN8Dk9oYMb+a8FjCM+XyoPMTWL+IzrKOmBzsYTrJFQWbOuyNUpRxojzTfGxYWcFv85fkOM3cIq10zyU92OqOTG7MV7MmS7is52rs6iKoxwRKbfZJ9aAeL6dCLVftigiittLbR7XQvfwUCmljyAgPPEjH0uzaIFuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676261; c=relaxed/simple;
	bh=voPR3+NOguu1YOwQ/gAGiqwq76qXAgyuFg+RMjwCVgU=;
	h=Date:To:From:Subject:Message-Id; b=UxhRdWZnEW8uiV0ZKE9P9tp2qNMkq4H1lShF07vv3ShUAQFyIcSTP2xEFclXVkzfyYA1452FrEHV8u3rcrZ9bmjufTjuND2SDom4D9pwbzCtXIZTbTU0EpQvJ/iGviK7rY+RcvtkAjMMYbL+sPB4oubqgWsXuP3bZLNrqKAMMBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0kscyzII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0kscyzII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDEAC4CEF1;
	Thu, 20 Nov 2025 22:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676261;
	bh=voPR3+NOguu1YOwQ/gAGiqwq76qXAgyuFg+RMjwCVgU=;
	h=Date:To:From:Subject:From;
	b=0kscyzIIkGsG+I7ppHedSk2AcsMjq6+SqjjGcw+3LBh0itkvhiSjyNwb5eie3Dln0
	 cSJbJKRiOUxQQ8Mu8JtSYLi3s27w0Y0+i4ke3yFxCjVeMAMpgt1xNNQbgBhwXtUd9I
	 lKMDfWMpGqGzYtkh1d5E6RIZVZi0GbexBTzWKoq0=
Date: Thu, 20 Nov 2025 14:04:20 -0800
To: mm-commits@vger.kernel.org,aardelean@baylibre.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] util_macrosh-fix-kernel-doc-for-u64_to_user_ptr.patch removed from -mm tree
Message-Id: <20251120220421.2CDEAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: util_macros.h: fix kernel-doc for u64_to_user_ptr()
has been removed from the -mm tree.  Its filename was
     util_macrosh-fix-kernel-doc-for-u64_to_user_ptr.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: util_macros.h: fix kernel-doc for u64_to_user_ptr()
Date: Tue, 4 Nov 2025 19:38:34 +0100

The added documentation to u64_to_user_ptr() misspelled the function name.
Fix it.

Link: https://lkml.kernel.org/r/20251104183834.1046584-1-andriy.shevchenko@linux.intel.com
Fixes: 029c896c4105 ("kernel.h: move PTR_IF() and u64_to_user_ptr() to util_macros.h")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexandru Ardelean <aardelean@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/util_macros.h~util_macrosh-fix-kernel-doc-for-u64_to_user_ptr
+++ a/include/linux/util_macros.h
@@ -136,10 +136,10 @@
 #define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
 
 /**
- * to_user_ptr - cast a pointer passed as u64 from user space to void __user *
+ * u64_to_user_ptr - cast a pointer passed as u64 from user space to void __user *
  * @x: The u64 value from user space, usually via IOCTL
  *
- * to_user_ptr() simply casts a pointer passed as u64 from user space to void
+ * u64_to_user_ptr() simply casts a pointer passed as u64 from user space to void
  * __user * correctly. Using this lets us get rid of all the tiresome casts.
  */
 #define u64_to_user_ptr(x)		\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


