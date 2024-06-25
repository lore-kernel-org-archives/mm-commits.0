Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636A33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293187; cv=none; b=FJIu+QbLZpZ3HGs9BD01EFG0tyGrunLJ3aPPLLCHL4lcP39o/NcLpAyHRBMEUqnG/ppNs3tr00ZE7AYZIgZzr9qcWlVNS9u6rcN+Pu91HKEpMjGyEePeQLf4w/hphDv/wnWl6oG/20OlOTNGuTbVEKxrE60q3SkmTAtuBW5lyus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293187; c=relaxed/simple;
	bh=/Ko6CuZb+ScMMajogFsjDih0+dTis+A4ys8AeVQgxzc=;
	h=Date:To:From:Subject:Message-Id; b=fbARoxNN1lTlVkvhQO2ar2F1VsKLnRHax2jpOCrSqlhl0A4yWmtRhT69AJ6argUgbXoxq+55YWfmr4N1V2ttU8aSeBC74kexI1VBjYrTQDcC1F1N+23wnxPveDO4mY/k9SnRqarAuXzmE6XmsEyqkp4UInYumxHbcclRfWySj6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1KPogmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1KPogmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9E0C32782;
	Tue, 25 Jun 2024 05:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293187;
	bh=/Ko6CuZb+ScMMajogFsjDih0+dTis+A4ys8AeVQgxzc=;
	h=Date:To:From:Subject:From;
	b=W1KPogmrxACQ5B0R6zheGKUlpqweCBaMHZc0e9y2lhreQrJRYR+kkrUXwsCcP3tj9
	 /WetoAlLI7Pa0Mi3G1N0tgIyTNXm+E2d8L7g+gcodJoWJqlznRz+NwaCzunYOrtuzS
	 yKOI335TXPaTiQ1FyvPvqvV6+EDdBjID/4x0qhfA=
Date: Mon, 24 Jun 2024 22:26:26 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-sort-remove-unused-pr_fmt-macro.patch removed from -mm tree
Message-Id: <20240625052626.ED9E0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sort: remove unused pr_fmt macro
has been removed from the -mm tree.  Its filename was
     lib-sort-remove-unused-pr_fmt-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: remove unused pr_fmt macro
Date: Tue, 28 May 2024 04:30:08 +0800

Patch series "lib/sort: Optimizations and cleanups".

This patch series optimizes the handling of the last 2 or 3 elements in
lib/sort and adds a testcase in lib/test_sort to maintain 100% code
coverage reflecting this change.  Additionally, it corrects outdated
descriptions regarding glibc qsort() and removes the unused pr_fmt macro.


This patch (of 4):

The pr_fmt macro is defined but not used in lib/sort.c.  Since there are
no pr_* functions printing any messages, the pr_fmt macro is redundant and
can be safely removed.

Link: https://lkml.kernel.org/r/20240527203011.1644280-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20240527203011.1644280-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/sort.c~lib-sort-remove-unused-pr_fmt-macro
+++ a/lib/sort.c
@@ -10,8 +10,6 @@
  * quicksort's O(n^2) worst case.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/sort.h>
_

Patches currently in -mm which might be from visitorckw@gmail.com are


