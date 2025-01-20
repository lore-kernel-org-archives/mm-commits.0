Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDCA8BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337170; cv=none; b=CXvhjR7dAD6DNzz0794ARsKO1CEM7kAGjmLejI/ovb8+WElmiOPb3t62yWwpQQ7p5bx8TGMHVnCMD/ooXoyd8XgqJJK/myhZO72Hm2SizSisRleWcY18Gj5UR35QUdTo1lUXItKDtLQEKdtWi6RjNx1ttK8FqkmihL83xDxNGn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337170; c=relaxed/simple;
	bh=1kiG7sZyGBNR76HgcRfQ2eOJ5GNKsqI0+qRtEf5hU6Q=;
	h=Date:To:From:Subject:Message-Id; b=UI9TuUxcgo1kk7E4nCnUQjXyFoWOBafIzDacaekQw3GI867V4WXNGNfTNq3rk67NtvEJ27vvd0Js0j/Y+mbcFuU4TNfjKscIobTtF9KurECMWu70zGcM0T1r3I6Pff6a6ykFLpD+m0C5NOJheowNErDFcVchXEjMJ4novkE5Qt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xD+8/N+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xD+8/N+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E92C4CED6;
	Mon, 20 Jan 2025 01:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337170;
	bh=1kiG7sZyGBNR76HgcRfQ2eOJ5GNKsqI0+qRtEf5hU6Q=;
	h=Date:To:From:Subject:From;
	b=xD+8/N+jq1/4uMMYM8A0n1yU/QyDrt/XX/nm6pr6mqB0KDqqFiTXMWYqiorOJT9fp
	 DWO85bKWAlIjK/nIOwwFRGDc9/gzLRlbl3PKPRmtaL4O8cyJRYiZBltpRgu8B3JUZp
	 Q7tLP241CcVEMLWaVUzVZ0JQ+TR9vSysLG6qK3vU=
Date: Sun, 19 Jan 2025 17:39:30 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch removed from -mm tree
Message-Id: <20250120013930.A3E92C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use str_high_low() helper in damos_wmark_wait_us()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/damon/core: use str_high_low() helper in damos_wmark_wait_us()
Date: Thu, 16 Jan 2025 21:42:16 +0100

Remove hard-coded strings by using the str_high_low() helper function.

Link: https://lkml.kernel.org/r/20250116204216.106999-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-str_high_low-helper-in-damos_wmark_wait_us
+++ a/mm/damon/core.c
@@ -14,6 +14,7 @@
 #include <linux/psi.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -2075,9 +2076,8 @@ static unsigned long damos_wmark_wait_us
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
 		if (scheme->wmarks.activated)
 			pr_debug("deactivate a scheme (%d) for %s wmark\n",
-					scheme->action,
-					metric > scheme->wmarks.high ?
-					"high" : "low");
+				 scheme->action,
+				 str_high_low(metric > scheme->wmarks.high));
 		scheme->wmarks.activated = false;
 		return scheme->wmarks.interval;
 	}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

