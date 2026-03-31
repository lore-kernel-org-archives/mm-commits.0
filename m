Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E891A4C81
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774916224; cv=none; b=obCyh9yDQSNIW1+olUWxlcjgQsiZxVCoDbKcd69/su5jK2l/BFxQnMZajukCFx/VgDojG9Z8jtglBPo8cno00msi8dW2zUKje5RvDSJGj1N7j7BIHlD3ebel9wVlhu0LAziA+ccqkbCSzLq+X4f92g3VvJiOrODWYHVOgFclKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774916224; c=relaxed/simple;
	bh=dO9rcqkI7+tJZl4Rtx5zHE0JmFoZEC2OctQyZ+kYm/w=;
	h=Date:To:From:Subject:Message-Id; b=q4EiRtD7LrealSVr0xSbfR2SHRzTBFUDb29si4kAgG5fonmYeM6EY2vmv8DsHWl8V57dV1xkggLv699CLGpZW8IvF/ARotsyXxWGj0CNgfHR07d3EF57SFcQpp4Yymd9S/qpIIEeiD0qYeh4DkgBA1uq7Iv/2hC7vSmDCIJL/Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YWIIyoGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YWIIyoGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7EDC4CEF7;
	Tue, 31 Mar 2026 00:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774916223;
	bh=dO9rcqkI7+tJZl4Rtx5zHE0JmFoZEC2OctQyZ+kYm/w=;
	h=Date:To:From:Subject:From;
	b=YWIIyoGx1QB4EsdsDd72Bwhryt1hH0YTJrkp339lWTcyCV/ufS79zXfVcSpPydk8h
	 zf5HUQXSYI6IFCalwjnUk/e0gh5uyQKGdW/8KZQUjZ9fEzxSRFFyuRNo8L7DFHoLhR
	 +bKJBmPgpPh1ZcExc3pfEh2UcvrydLAnA+a+Lvx4=
Date: Mon, 30 Mar 2026 17:17:02 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch added to mm-new branch
Message-Id: <20260331001703.6C7EDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-merge-test-for-partial-msealed-range-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-merge-test-for-partial-msealed-range-fix
Date: Mon Mar 30 05:12:35 PM PDT 2026

fix build

In file included from merge.c:4:
merge.c: In function merge_merge_vmas_with_mseal:
merge.c:1229:27: error: __NR_mseal undeclared (first use in this function)
 1229 |         ASSERT_EQ(syscall(__NR_mseal, 0, 0, ~0UL), -1);
      |                           ^~~~~~~~~~

Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c      |    1 +
 tools/testing/selftests/mm/mseal_test.c |    1 +
 2 files changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-merge-test-for-partial-msealed-range-fix
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -8,6 +8,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <stdbool.h>
+#include <unistd.h>
 #include "kselftest.h"
 #include <syscall.h>
 #include <errno.h>
--- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-merge-test-for-partial-msealed-range-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -6,6 +6,7 @@
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <asm-generic/unistd.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/prctl.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

