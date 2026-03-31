Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2167E792
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774916939; cv=none; b=m+cIxP82UwcFdv0RNq6BPv7RK06xieENqNmuX9u0Y0JpxdI9q7NItyR1mnmg0TmBSDQe5RMErGo2p0wdxbwK+0OJTzq2TzWHqPEWsEcVO2B6ealQLp7IxALB7+wt8Kjsej7+3bCmepiV0MIKWs16+EHR3zJX1e8hvq8b4GPs4d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774916939; c=relaxed/simple;
	bh=1+irtP9YOK1SiTaasaP4ulk6JyAOnRa6hvljRXHD5k8=;
	h=Date:To:From:Subject:Message-Id; b=KH/NhHeer/NeEnKYY35TYb9LefhjpivZMqXcvlc+xP1ZhWnt9W2FKBP45rIEUcTZT+q1VXIQhbvQe04AaoJRrSNd/0C7lA6XSg+tZYDQSOZJT4MefkpmmdRa+mfItDtpKQ3tcAGewR7+ZpAtXh2pSO/FB2nEreezfUhBlTtgEf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DOKosWkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DOKosWkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207A7C19423;
	Tue, 31 Mar 2026 00:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774916939;
	bh=1+irtP9YOK1SiTaasaP4ulk6JyAOnRa6hvljRXHD5k8=;
	h=Date:To:From:Subject:From;
	b=DOKosWkrghT20afrw0R8HE1QuhFVRzCTd5PpEH47qG+ksc6m9+cXjqOBfRod0vJFf
	 qQ8Um8Wr3N/5b2H2WL8imKWl7tY5s5ylqJU8hdEzCu2TYPfgLJpvr2FRHKD8U88x/L
	 HwPDJCQJLnY5KrIAoJrc85xT2672mevvh+vjFRg4=
Date: Mon, 30 Mar 2026 17:28:58 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-merge-test-for-partial-msealed-range-fix.patch added to mm-new branch
Message-Id: <20260331002859.207A7C19423@smtp.kernel.org>
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

 tools/testing/selftests/mm/merge.c |    1 +
 1 file changed, 1 insertion(+)

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

