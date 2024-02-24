Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2398AC148
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739445; cv=none; b=FVYG5P/KXi/FyHsuqZCzoaDnCpFs/53Ghi6LHqgvG8h4gT/hjGoj07kb05Ge11tItGp5MON+mumiA7eF48G427T2gZJL2PHiCmFNN/P5sfDyy3SLMojmoPi9Pb1lb1whUc7mQjhOjbKUQgI5N3JLl5sXmgcoMxiluyYSAWf4Yrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739445; c=relaxed/simple;
	bh=mA4fym+7X7ukY8QOWVlyN+4ycwIhdKX9jp6752t4Y2M=;
	h=Date:To:From:Subject:Message-Id; b=cELint3A6z9YQU/Lq1zN7qmXU1j/BPGFq89iBb5ZxsO4ManzNVkC+RPwK/u+MXcx08lMTNMH00v+IpI45uuhL0DJJNlhn1vEQ2gm2hBxlJ+bgHftBWr1sUBTJjLaPMGi1I66N6Ve909lYnQImaanO+sl7VcxzOl7AdBxVeoaO34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dDMUniLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dDMUniLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4DEC433F1;
	Sat, 24 Feb 2024 01:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739445;
	bh=mA4fym+7X7ukY8QOWVlyN+4ycwIhdKX9jp6752t4Y2M=;
	h=Date:To:From:Subject:From;
	b=dDMUniLGzEQ+BHwf2S1riVG17F22GNweSj7V0eWx2MRP7FhJYy9Qd4Sa/0B1vxOiz
	 t6O6Kq2pqTIw5JbhBNtfLEQi7ofcN60dyebCTrY7K89Fb/xciXzQ3CJDyHHPmxrI7h
	 RpXDy9Niup6bfSoLm0mxBNA/iPgO4l7RM2duUBPo=
Date: Fri, 23 Feb 2024 17:50:44 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch removed from -mm tree
Message-Id: <20240224015044.ED4DEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Chengming Zhou as a zswap reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: MAINTAINERS: add Chengming Zhou as a zswap reviewer
Date: Tue, 20 Feb 2024 07:38:51 +0000

I have been actively contributing to zswap and reviewing zswap patches for
a while, and I am already getting CC'd on most of them.  So add myself as
a reviewer, will continue to work on it and help with the review process.

Link: https://lkml.kernel.org/r/20240220073851.865113-1-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-chengming-zhou-as-a-zswap-reviewer
+++ a/MAINTAINERS
@@ -24426,6 +24426,7 @@ ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Yosry Ahmed <yosryahmed@google.com>
 M:	Nhat Pham <nphamcs@gmail.com>
+R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/zswap.rst
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

