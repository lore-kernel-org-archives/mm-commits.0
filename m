Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC9A3D3499
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773163172; cv=none; b=FiSjF8zzMgdZietS+Mu7ueyVsxsOLQ2f+U4rVuXVYVsFwuAX0w53NayjALhyYCBHhwCfkp7DZpxgpWX/NL/RvbPO5hv4WAi6XIaVJ5G+YM4x1z625qcV+0ocLQ0okR5IFK7wteuopFiVX9ZcqeJ+mJda7JjFBSNofWtNVj5QClI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773163172; c=relaxed/simple;
	bh=WVWCqLhiG9RC9Ux13aJ5hQkqUea2bMaKuludtYS7Uco=;
	h=Date:To:From:Subject:Message-Id; b=SqoufPVooqKlntBY1vPuF12WJDpgJwFExBQ0lm07zByR2LQRvETXwiP2pBnahgChHqYif59TyjqoE+Y3w3Un1aoujbmyLeJ4CKte3+oyzN5BXOQryJvekJURNnYUCcwp+3md0P1VNq78qkjCPnuTvPBl61Rw6+IKUOrG2b9P620=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XoSSFrPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XoSSFrPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC802C2BC9E;
	Tue, 10 Mar 2026 17:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773163172;
	bh=WVWCqLhiG9RC9Ux13aJ5hQkqUea2bMaKuludtYS7Uco=;
	h=Date:To:From:Subject:From;
	b=XoSSFrPxFygJ8k+3QWOyMISELhudmX7gncix2R8Z2J+ZVmeY9wT/5fY53rdRKvsk/
	 jwLL/l2XucNhLIQuFStcsAA4ZQH1Xz/ilP7zpBjUlKRU+bnXp8bvrH7RYTIxnGuk0V
	 VnDDMhQssvBEl7/KyCV5P4b+Yn2/Mp0ixknCEEfw=
Date: Tue, 10 Mar 2026 10:19:31 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-fix-typo-in-numa_memory_policyrst.patch added to mm-unstable branch
Message-Id: <20260310171931.EC802C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: mm: fix typo in numa_memory_policy.rst
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-fix-typo-in-numa_memory_policyrst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-typo-in-numa_memory_policyrst.patch

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
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: docs: mm: fix typo in numa_memory_policy.rst
Date: Wed, 11 Mar 2026 00:18:37 +0900

Fix a typo: MPOL_INTERLEAVED -> MPOL_INTERLEAVE.

Link: https://lkml.kernel.org/r/20260310151837.5888-1-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/numa_memory_policy.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/numa_memory_policy.rst~docs-mm-fix-typo-in-numa_memory_policyrst
+++ a/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -217,7 +217,7 @@ MPOL_PREFERRED
 	the MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags
 	described below.
 
-MPOL_INTERLEAVED
+MPOL_INTERLEAVE
 	This mode specifies that page allocations be interleaved, on a
 	page granularity, across the nodes specified in the policy.
 	This mode also behaves slightly differently, based on the
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

docs-mm-fix-typo-in-numa_memory_policyrst.patch

