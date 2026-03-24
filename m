Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185C03659F5
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388607; cv=none; b=ra/fGRzUL9COKvw9bt6gZie8PPQfgBSQ/ZUVSlKfq/cfW2U2M9AT8RHsdXY80SgrMnMiLc2uVNgwRegL8TvQMTFiYrLM1F+C2DFaFiqN3iU66VtewX4l7eNvOnq29rwQ7EYLLZTTnsThPN0snjQUfxLcvl3ramolgnzaf8FF5Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388607; c=relaxed/simple;
	bh=M3msFQjQohsiwEZsZJfislDXBhv3EELDqK6rYvGt3d8=;
	h=Date:To:From:Subject:Message-Id; b=Y/79WqMuJd9I/+iH5Cym38XAuHtYMx5YYU9Uib/St0apJpVp6rnTO0Qiyf+Rg3nJQO7qMGfN849o52g1Aqx2SkI8jiHLXNiInc9+CLMJ+nafiQw8PWrCZ98g2N8/zDuvEFluP8eQYQh7y2vlZcZBmMt1PXrTzBE0X0JstL/cTd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqA34MEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqA34MEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F094C19424;
	Tue, 24 Mar 2026 21:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388606;
	bh=M3msFQjQohsiwEZsZJfislDXBhv3EELDqK6rYvGt3d8=;
	h=Date:To:From:Subject:From;
	b=jqA34MEtSnQQwLv02hVG5qXGwztVcpVB1uVQOIulMD+xUqMfoRmqiiYc37Saty/2I
	 ++MC3KXvKufn4j8Ns2jMOwgTPQXwzGTR3ZsDQOH+eC5G1lcU58FGqP1f3yDBmPhm52
	 UBLQJKWdvHAHOvdGVjbV5HL+zGPKQhQj6hGER/dU=
Date: Tue, 24 Mar 2026 14:43:26 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-myself-as-reviewer-for-swap.patch removed from -mm tree
Message-Id: <20260324214326.9F094C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Youngjun Park as reviewer for SWAP
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-reviewer-for-swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: MAINTAINERS: add Youngjun Park as reviewer for SWAP
Date: Thu, 26 Feb 2026 10:07:39 +0900

Recently, I have been actively contributing to the swap subsystem through
works such as swap-tier patches and flash friendly swap proposal.  During
this process, I have consistently reviewed swap table code, some other
patches and fixed several bugs.

As I am already CC'd on many patches and maintaining active interest in
ongoing developments, I would like to officially add myself as a reviewer.
I am committed to contributing to the kernel community with greater
responsibility.

Link: https://lkml.kernel.org/r/20260226010739.3773838-1-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-reviewer-for-swap
+++ a/MAINTAINERS
@@ -16902,6 +16902,7 @@ R:	Kemeng Shi <shikemeng@huaweicloud.com
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
+R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-pm-hibernate-fix-swapoff-race-in-uswsusp-by-pinning-swap-device.patch
mm-swap-remove-redundant-swap-device-reference-in-alloc-free.patch

