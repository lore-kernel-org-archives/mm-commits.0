Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794290902;
	b=j7LIEwlx61fp8cFUJtz/6ihZGL4ccXVgT1ZTSyKbD424ri+pFtMedfCoKAO1ZjYVCvgb
	 wZ3gP2zelBkAoHou3wouNYgba27qHFSH5VNqEDB24Pveb5Z2efDe8T9Y/haGLnmq6pan/
	 OPpbW+jdJUrRbzROlTQFKiU12xlqjTUn6oH9d557B7M59JPeunMtCZ2BAs6RHhC1Q4ocC
	 nbaUiOQeUShUOzAZ0Vru2ALMbbu4adrobwoWsBF/Ggi/LWGsoBGBV8vDBZOcfrRlPqLTq
	 BySwU89Us5TlLAq82kamHRZgI35v+d5/CEgNnhIMEZ6wL24YZ9IaRZdOkkqQMxAy2JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794290902;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=VM+nubyeDrc+R8pzhug2p/kYs48Rvv1dN+OpHOXziKs=;
	b=FPQ7cbg7JG/jBQebio3J6z7sfbfWIlfIPqK87FebCrR8RpbIdwxTkom8y4zJudxDXjRt
	 s3g3G0lZ2e/XX8XuZv/beOIL2duDHCsN9hUW8uQfnt8Oomr8knldQdTPGzRl0qM3QWYs5
	 jIATDywkkLIiXeD9k7o7UDiy3SQhHgNtqXn+ga1i1vk9ug3j0lqog1Ba5FtIuLGgkEs6C
	 DNMy/DvN+QvMMBdhV/JU9p2CEGlTsSEEZNLd4tw99HXSmy9bz7Qxy6wfOHHUNah4Ud7lK
	 1rvZml2QIRbu9q0pglk75VOAz115meA8ryA4al+EUxL50SVtz5dNTUstdRW9Eqb+/FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="G/pkNNYS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5591606A31C
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=G/pkNNYS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705B31F0089F;
	Tue, 10 Nov 2026 06:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794290901;
	bh=VM+nubyeDrc+R8pzhug2p/kYs48Rvv1dN+OpHOXziKs=;
	h=Date:To:From:Subject;
	b=G/pkNNYSrbuvyVRo9EH3dtuebZ9eiNVpbzj0rG8a5BVcYBGerN3xC5HvCLUIZ4DLP
	 P5BCEtM8lLs/oTw24666NSthMoQX7nOnR8KGhengZBXa7Sar5sbpNbAjp+koUckFJb
	 lhuzgy4xsYBO7xJBFDXcQC2Y1US/pfKZch9Hf0mI=
Date: Mon, 09 Nov 2026 22:08:21 -0800
To: mm-commits@vger.kernel.org,yosry@kernel.org,nphamcs@gmail.com,
	hannes@cmpxchg.org,chengming.zhou@linux.dev,zhangchujun@cmss.chinamobile.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-test_zswap-check-malloc-return-value.patch added to mm-unstable branch
Message-Id: <20261110060821.705B31F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/cgroup: test_zswap: check malloc() return value
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-test_zswap-check-malloc-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-test_zswap-check-malloc-return-value.patch

This patch will later appear in the mm-unstable branch at
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
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: selftests/cgroup: test_zswap: check malloc() return value
Date: Wed, 04 Nov 2026 17:53:15 +0800

test_no_invasive_cgroup_shrink() uses zw_allocation immediately after
malloc() without checking for allocation failure.

Check for NULL before accessing the buffer and use the existing cleanup
path to report test failure, matching the handling of wb_allocation later
in the function.

Link: https://lore.kernel.org/20261104095315.2326-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-check-malloc-return-value
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -503,6 +503,8 @@ static int test_no_invasive_cgroup_shrin
 	if (cg_enter_current(zw_group))
 		goto out;
 	zw_allocation = malloc(allocation_size);
+	if (!zw_allocation)
+		goto out;
 	for (int i = 0; i < nr_pages; i++) {
 		off = (unsigned long)i * page_size;
 		memset(&zw_allocation[off], 0, page_size);
_

Patches currently in -mm which might be from zhangchujun@cmss.chinamobile.com are

mm-page_owner-use-%u-to-print-the-stack-depot-handle.patch
selftests-cgroup-test_zswap-check-malloc-return-value.patch

