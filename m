Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546DF1EF375
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119297; cv=none; b=GPWK3r/CZ8Rwzj9iRh4quwn8ulrW84c5DObQikJXMgnoakfwPpLd5ihefqUkdbccFKtDyFMdc1GIMFG6k+mlqSrczRXdXJ/P4s23Xx69/3wnivMS5qEnQRP1HKgf5z2z32S2YdjGULIeV/0RXjdLQu1CMw2gakQvQbDto2A9kxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119297; c=relaxed/simple;
	bh=OIUNgVLdGs5dY2qBU7GHb/gc/KhMiA0bLN6Cy/Nens4=;
	h=Date:To:From:Subject:Message-Id; b=ug+Wj5wzNhqgaT6dkmgLwMhzKmOs5ZzxCs2VTUSoM9hmQSZavHcx1drtogPp+AJaW7KnzDJlUgT8bMoSWu2i8nZA3c80vrh7GdJYls5dIutszG6DLK66wuVy9/DX/MwcwncyDJhiIkJC+4f0RphSib2cxU3JWJpiu5ucCjUN9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iax1vJkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iax1vJkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB781C4CEE4;
	Tue, 13 May 2025 06:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119296;
	bh=OIUNgVLdGs5dY2qBU7GHb/gc/KhMiA0bLN6Cy/Nens4=;
	h=Date:To:From:Subject:From;
	b=iax1vJkp35E1kiDmVLGEIYgkNvEiRV+iQYlq8N1/7cUb5dLtfFr0/7QUz7XKjrmrL
	 LQIewrQbWwUhscMh4CQsusT4ezETg8lLsbjxdJmwSV7hb6yhXfyBekgAMFymuMsQdJ
	 mIXbTcWoBM/5NeYlyJUko2n5PU2BAIQIAJdOQfNU=
Date: Mon, 12 May 2025 23:54:56 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] util_macrosh-make-the-header-more-resilient.patch removed from -mm tree
Message-Id: <20250513065456.BB781C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: util_macros.h: make the header more resilient
has been removed from the -mm tree.  Its filename was
     util_macrosh-make-the-header-more-resilient.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: util_macros.h: make the header more resilient
Date: Mon, 28 Apr 2025 10:27:54 +0300

Add missing header inclusions.

Link: https://lkml.kernel.org/r/20250428072754.3265274-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/util_macros.h~util_macrosh-make-the-header-more-resilient
+++ a/include/linux/util_macros.h
@@ -2,7 +2,10 @@
 #ifndef _LINUX_HELPER_MACROS_H_
 #define _LINUX_HELPER_MACROS_H_
 
+#include <linux/compiler_attributes.h>
 #include <linux/math.h>
+#include <linux/typecheck.h>
+#include <linux/stddef.h>
 
 /**
  * for_each_if - helper for handling conditionals in various for_each macros
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


