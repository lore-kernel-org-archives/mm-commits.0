Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0986A1CD10
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644472; cv=none; b=KE3HCwSw7HVu/JrPEtYDmK4QBPZrcW0BZPiW4m+L2HY3FVLF1U5OCkQfI0v40WmFlzuiCuQk39ccSdfmSZMtbkLNsq9e3bdQ8/aJFlBpBZtKlrfh4fvc7yeOk1Dhh9AJWgLzMdc7f+TOyLM+5Mn7zwMfmNTrYedu6FkI3e9i7zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644472; c=relaxed/simple;
	bh=bKU29M6dYiNAhQMBurS5qC6aZCxAIDfDX8XPCgE2F9I=;
	h=Date:To:From:Subject:Message-Id; b=DBeFGzDfw1FMWk1FdmECXw3dNYUH7QQyZVUnfxwTljt/6kYBrc4pw8478dE2POCVQv84E+ifN34c+/548dcJ40iQPPyrmQlYVN72FrbHoS4zUaH8PoLLcRNjd680pmuUCssHALpZw3kURk8mosVj4+dPEEWf4rH1Mx7tMasoBTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mc435o7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mc435o7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20E8C433F1;
	Thu, 22 Feb 2024 23:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644471;
	bh=bKU29M6dYiNAhQMBurS5qC6aZCxAIDfDX8XPCgE2F9I=;
	h=Date:To:From:Subject:From;
	b=mc435o7hqVdhdeSLBrxNDJI0WWNQjeKJv0Ar7ODkfVVWmp2l9hvGlF43sAO83HP02
	 cFDtb0II24efmjdDQfCgE3c1SzqbFWzu4gJROS0Q7pVERzOjg7VQp+0Htxo4Vz0ejc
	 FlS9eKzqzXlG+5m4EmRij34MeDxVtoeYcRhLbUXg=
Date: Thu, 22 Feb 2024 15:27:51 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-fix-the-zswap-invasive-shrink-test.patch removed from -mm tree
Message-Id: <20240222232751.C20E8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: fix the zswap invasive shrink test
has been removed from the -mm tree.  Its filename was
     selftests-fix-the-zswap-invasive-shrink-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: selftests: fix the zswap invasive shrink test
Date: Mon, 5 Feb 2024 14:56:07 -0800

The zswap no invasive shrink selftest breaks because we rename the zswap
writeback counter (see [1]).  Fix the test.

[1]: https://patchwork.kernel.org/project/linux-kselftest/patch/20231205193307.2432803-1-nphamcs@gmail.com/

Link: https://lkml.kernel.org/r/20240205225608.3083251-3-nphamcs@gmail.com
Fixes: a697dc2be925 ("selftests: cgroup: update per-memcg zswap writeback selftest")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-fix-the-zswap-invasive-shrink-test
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -52,7 +52,7 @@ static int get_zswap_stored_pages(size_t
 
 static int get_cg_wb_count(const char *cg)
 {
-	return cg_read_key_long(cg, "memory.stat", "zswp_wb");
+	return cg_read_key_long(cg, "memory.stat", "zswpwb");
 }
 
 static long get_zswpout(const char *cgroup)
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch

