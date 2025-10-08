Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9442367C1;
	Wed,  8 Oct 2025 00:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759883003; cv=none; b=le2AOWuO1QzEjLK1XhXyY7WhFcFV31o0o+Qq4FMI8nfVPUIlzRjuUxQGJySnUwZL23qgD0nq0XPe04pq+qanto3B0divVkhS8wp3yhWImaEL831m5fJfcJlCZMq4e6vOeBnJM13sOj0Sk7v3hJPN1sp+2eDSzI5AvQKtVesLYSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759883003; c=relaxed/simple;
	bh=9qTl8MFrq8byUI/luyAshzWL2uR9+2LJSMmBqC/BeUA=;
	h=Date:To:From:Subject:Message-Id; b=g4P4tPB/oJD0wiagMpYOpHqtJAm0QLgnnWSS9ywOE8t4UvyMsPkN/eSvfbjv7w9QorlgHK7G9EKRzdyh4qgGWeIrnq4u9VyyRMS23oXy/t1m0exrr829mJZkp2Y6VaAZrrkLuDS2TAgBrg9JqYhjMUSuzaxATvSNh5S5wBAoQDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CBoONFi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CBoONFi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB549C4CEF1;
	Wed,  8 Oct 2025 00:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759883002;
	bh=9qTl8MFrq8byUI/luyAshzWL2uR9+2LJSMmBqC/BeUA=;
	h=Date:To:From:Subject:From;
	b=CBoONFi7REQiuzx8CWeEj9fzqCpspOCxRS++vaAPorc5Ey9WJWieyd5o/I0bC/gPx
	 MRpCtNLt0gW8j7d+H3kL8tveUqtzBGTVGRfgVuHZz/USNYxL7VX56YYzn+MzXi0Ct3
	 fnYUaG/c5EWvT9lVOeL3mH0aCtsvkxzoE+IIWtis=
Date: Tue, 07 Oct 2025 17:23:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20251008002322.AB549C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: catch commit test ctx alloc failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/sysfs: catch commit test ctx alloc failure
Date: Fri, 3 Oct 2025 13:14:54 -0700

The damon_ctx for testing online DAMON parameters commit inputs is used
without its allocation failure check.  This could result in an invalid
memory access.  Fix it by directly returning an error when the allocation
failed.

Link: https://lkml.kernel.org/r/20251003201455.41448-2-sj@kernel.org
Fixes: 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-catch-commit-test-ctx-alloc-failure
+++ a/mm/damon/sysfs.c
@@ -1473,6 +1473,8 @@ static int damon_sysfs_commit_input(void
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err) {
 		damon_destroy_ctx(test_ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-catch-commit-test-ctx-alloc-failure.patch
mm-damon-sysfs-dealloc-commit-test-ctx-always.patch
mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

