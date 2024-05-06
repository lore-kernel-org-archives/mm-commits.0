Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1021425757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957083; cv=none; b=C3nJeGHEl4RAX/HawaVhWCTGBihNo/DIRp9yn4DUMfRGG14SJJxzr2ByxSIWFHUu9Yr799Z9so+JvkoWexNKF7BpkhPq3qQ+ZNFbyDNkWxEfYgi8Nzs82exiOyPYSa6asrOXK9mG9ICVp0yrarWjtk4SdIzVj6Dvc/O1mBALN3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957083; c=relaxed/simple;
	bh=9CyAvYaQ5pODcW1CFXn0QbLji1gD5lK8CY67qOGgxEY=;
	h=Date:To:From:Subject:Message-Id; b=j6+S4CMuJzU+1qKDzHOO8yQen9yfa4aVxFjvDxL+AEHUwZNp9GCGQjrFdrgP2J3gbjlZOGbpK3zCZcMSXOoek0PmHzesFBAofSduJefFAV4mPom4qPTWfbedNNi0dknY2KyfNqozGqzwVq9QtzyT+6dT9qROhWp9VyGAhNUek08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z+KiE04i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z+KiE04i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D79C113CC;
	Mon,  6 May 2024 00:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957082;
	bh=9CyAvYaQ5pODcW1CFXn0QbLji1gD5lK8CY67qOGgxEY=;
	h=Date:To:From:Subject:From;
	b=Z+KiE04iBZo+qVkT3p1erSa80KfCq+5NNDij+menkFN8oLJDn7JVE2GRx4rLfjh2i
	 abVjsNM6Mf/XwfIVHwIjiHpkI81kQRJMRS9CkvQ5629CtRNLh/HHbkmv73mRIDDC5U
	 hBi8NrjhB2KnrnsrePsoOkWL6weRP8eb5TuBJYkk=
Date: Sun, 05 May 2024 17:58:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@rasmusvillemoes.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xarray-dont-use-proxy-headers.patch removed from -mm tree
Message-Id: <20240506005802.D9D79C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: don't use "proxy" headers
has been removed from the -mm tree.  Its filename was
     xarray-dont-use-proxy-headers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

media-rc-add-missing-ioh.patch
media-stih-cec-add-missing-ioh.patch
kfifo-dont-use-proxy-headers.patch

