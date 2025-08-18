Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30625231836
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 01:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755482009; cv=none; b=MgSHAd0MShTgKyfyU3kok+XG6t3lGAd0z0h5E2YX+swawQ9W6QSEkLpL3opDVTzA5h6WF2nXtQAYuwh/U7J14hgaBsU8AhuPpVsTHisKOZmCOH4fuz8BmkwXMEu4cB1Q0AwQVjyO5tx/j+FWJBLQRNDfbU6RexQ1t2XpFavnGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755482009; c=relaxed/simple;
	bh=ywUFn5AK/z+0ZJTBe8ZC8w3OdU+ELslQWHyJ/AXW7fo=;
	h=Date:To:From:Subject:Message-Id; b=M2PATktfeL2jPK8RnTGjkN/IFine8sjdjoUYNY0gCQCRw60cx6g1Rj37/Iy5I1wB1dq6e0cggWMMimsOeB+xnt9Hia2oVTMF4vcq7OXxc06SfdWEuhB+63cQ1PL131xdeoIW8jLBIIwkU5XcPCboUDULzlMR3IdmxHvnSbSVVUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gg/kRnFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gg/kRnFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5526C4CEEB;
	Mon, 18 Aug 2025 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755482008;
	bh=ywUFn5AK/z+0ZJTBe8ZC8w3OdU+ELslQWHyJ/AXW7fo=;
	h=Date:To:From:Subject:From;
	b=Gg/kRnFnXFbGlAAiFXWzp2++/BFer7UqYq6KfH0tKXxg54gOtNp5wEcUAicgCPLlU
	 3BLgRoo8MfD4kzaNOo6RHMUY0ZRR3y/DXVOqMuozY/sVN7kNvnOpQ/gly9n0YKHt5m
	 Q24vJkvOmB0IL43ZWVw+inm2nUi5sLehQc3KaU9s=
Date: Sun, 17 Aug 2025 18:53:27 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-test-no-op-commit-broke-damon-status-fix.patch added to mm-unstable branch
Message-Id: <20250818015328.A5526C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: change wrong json.dump usage to json.dumps
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-test-no-op-commit-broke-damon-status-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-test-no-op-commit-broke-damon-status-fix.patch

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: selftests/damon: change wrong json.dump usage to json.dumps
Date: Sat, 16 Aug 2025 10:40:33 +0900

To print drgn status to stdout json.dumps should be used without
json.dump.  Change incorrect function call by typo.

Link: https://lkml.kernel.org/r/20250816014033.190451-1-ekffu200098@gmail.com
Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON status")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_no_op_commit_break.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py~selftests-damon-test-no-op-commit-broke-damon-status-fix
+++ a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -62,8 +62,8 @@ def main():
         exit(1)
 
     if before_commit_status != after_commit_status:
-        print(f'before: {json.dump(before_commit_status, indent=2)}')
-        print(f'after: {json.dump(after_commit_status, indent=2)}')
+        print(f'before: {json.dumps(before_commit_status, indent=2)}')
+        print(f'after: {json.dumps(after_commit_status, indent=2)}')
         exit(1)
 
     kdamonds.stop()
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-core-fix-commit_ops_filters-by-using-correct-nth-function.patch
selftests-damon-fix-selftests-by-installing-drgn-related-script.patch
mm-damon-core-fix-damos_commit_filter-not-changing-allow.patch
mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
selftests-damon-test-no-op-commit-broke-damon-status-fix.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

