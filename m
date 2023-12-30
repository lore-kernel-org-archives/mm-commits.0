Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE68C1385
	for <mm-commits@vger.kernel.org>; Sat, 30 Dec 2023 04:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkFUYhoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A9AC433C7;
	Sat, 30 Dec 2023 04:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703910045;
	bh=caFBH/lBQs358Hgl8YB7djgpJxbCAYntno6LREwBbv4=;
	h=Date:To:From:Subject:From;
	b=rkFUYhoGpe3i0U3UuhZD+Yqo5AZEbyLtilLgN86pT5IH/jGkWik6AhditWNWhhyv7
	 RHFE05OqEnV6oaeXPxo8RPDYuqV26ld8brA4qFnjdH50q8bF1UhktF+ziClOgRZx5m
	 razrI1eCBo7BcMV1m6R5obkSQMt/qkIh4E4+dkCE=
Date: Fri, 29 Dec 2023 20:20:44 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,chrisl@kernel.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-memcontrol-implement-zswap-writeback-disabling-fix.patch removed from -mm tree
Message-Id: <20231230042045.11A9AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: memcontrol: implement zswap writeback disabling (fix)
has been removed from the -mm tree.  Its filename was
     zswap-memcontrol-implement-zswap-writeback-disabling-fix.patch

This patch was dropped because it was folded into zswap-memcontrol-implement-zswap-writeback-disabling.patch

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: memcontrol: implement zswap writeback disabling (fix)
Date: Wed, 20 Dec 2023 16:57:25 -0800

Add a caveat about recurring zswap store failures leading to reclaim
inefficiency.

Link: https://lkml.kernel.org/r/20231221005725.3446672-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    5 ++++-
 Documentation/admin-guide/mm/zswap.rst  |    4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~zswap-memcontrol-implement-zswap-writeback-disabling-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1686,7 +1686,10 @@ PAGE_SIZE multiple when read back.
 
 	When this is set to 0, all swapping attempts to swapping devices
 	are disabled. This included both zswap writebacks, and swapping due
-	to zswap store failure.
+	to zswap store failures. If the zswap store failures are recurring
+	(for e.g if the pages are incompressible), users can observe
+	reclaim inefficiency after disabling writeback (because the same
+	pages might be rejected again and again).
 
 	Note that this is subtly different from setting memory.swap.max to
 	0, as it still allows for pages to be written to the zswap pool.
--- a/Documentation/admin-guide/mm/zswap.rst~zswap-memcontrol-implement-zswap-writeback-disabling-fix
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -159,6 +159,10 @@ zswap itself) on a cgroup-basis as follo
 
 	echo 0 > /sys/fs/cgroup/<cgroup-name>/memory.zswap.writeback
 
+Note that if the store failures are recurring (for e.g if the pages are
+incompressible), users can observe reclaim inefficiency after disabling
+writeback (because the same pages might be rejected again and again).
+
 When there is a sizable amount of cold memory residing in the zswap pool, it
 can be advantageous to proactively write these cold pages to swap and reclaim
 the memory for other use cases. By default, the zswap shrinker is disabled.
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-memcontrol-implement-zswap-writeback-disabling.patch

