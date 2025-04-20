Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1834101E6
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745180741; cv=none; b=S9mUJLjerGRvyo8KoOR4E0hd3z8aSq0RdIH0MCvOADfw4IhaiMHZpxWRl/RV6a6V3NjZHL/rFkhkViwv/ix7in+XrkUHERxMrWvY4X3xATJRPvDyV2MyKS9IuW0OrFr0xz5yk+tPUO5zV5ylFvULqImjCeawMDC/aqOGqRi/8zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745180741; c=relaxed/simple;
	bh=xWePrrWHGWWpBmkUk6fvRxfhSCqL3ovp1EPnLt4KJs8=;
	h=Date:To:From:Subject:Message-Id; b=U8RYxuc4Ax+PeYO7Iq6eKgNs6mGrqbgcKkgcDNdJRwtZshJRVGQvxIKSSf1ZtfXXE9hbjPjFmnl3hc316zBLEhccpPodz3SbhJ4fBnzBwn7Qfme+5ukxl5xJjTEH928GKUQZ2AryBNAKTMYQS8TJO1VV06z+3oW7a9Jtr6odadg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OO7j/L80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OO7j/L80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65767C4CEE2;
	Sun, 20 Apr 2025 20:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745180740;
	bh=xWePrrWHGWWpBmkUk6fvRxfhSCqL3ovp1EPnLt4KJs8=;
	h=Date:To:From:Subject:From;
	b=OO7j/L80eXi7mEIK4tuto2Kf254QKU9cRi6kvwTC+R7laiarEyo3X9RBoQMb0cIz0
	 RsKWIdoV3PPghJxpGUoGGYDi0JNqiTTpKsh0W1rXax+IuApBVpZGGlxdtMYy9u2g6/
	 KO+v26MvANWpHqTXxSCLrX/4btJc5Uf8Msm74b2w=
Date: Sun, 20 Apr 2025 13:25:39 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-nid-file.patch added to mm-unstable branch
Message-Id: <20250420202540.65767C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document nid file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-document-nid-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-nid-file.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document nid file
Date: Sun, 20 Apr 2025 12:40:29 -0700

Add a description of 'nid' file, which is optionally used for specific
DAMOS quota goal metrics such as node_mem_{used,free}_bp on the DAMON
sysfs ABI document.

Link: https://lkml.kernel.org/r/20250420194030.75838-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-nid-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -283,6 +283,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the current
 		value of the goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/nid
+Date:		Apr 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the nid
+		parameter of the goal.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

