Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F163E368D42
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 19:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778613771; cv=none; b=WTkLTDOEqwz+8gSrkq5NePahi49BEQxwRpG4QQ1iLfMJpOU4Rm5E4nyAJ2C53frDrnfNwZlP4WKs3Ybo354cbooIdwQ+ujUPPOTx8PQrZbxH4iTtc1BkTCq+/pEoc1qnM/0ZmWYaE7GBX/X2gLKZZfbfnXxXogldYd0Vm/bM0g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778613771; c=relaxed/simple;
	bh=KLNSY3jDORQWHB7D6QVC9GBmotVhcSrlzbX3YuOysE8=;
	h=Date:To:From:Subject:Message-Id; b=N79sqO88LShunXJFoZw/RQtDz9XQ2A/FQZmnxkza5I5DVM+GPkmCGjkfTMwov6Vdie1d4kV42jHTFbHI9q+tObpHbIi9AompXeeE1zpRI55fWB8/6KJchTtv4gOAsP/zrTEZILkLYOSm9gNbE1X5ZPam4gNYA8YjOIPc+nrH1R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yIhWQbj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yIhWQbj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1492C2BCC7;
	Tue, 12 May 2026 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778613770;
	bh=KLNSY3jDORQWHB7D6QVC9GBmotVhcSrlzbX3YuOysE8=;
	h=Date:To:From:Subject:From;
	b=yIhWQbj/p/J3FfzbyKnuSM1CFBR/hdmdXZZdYFe4uU7dbZwEeeBrV+f2h2pca36hw
	 8nc/0Rcivw8OnYxtbSnb6H9by08Q3nX6OzB6QUsPODIyAihNUKa1rGKk8ruVAxVntE
	 RiDjC/3AZB34DXDJGBi8KBC5n1viRLv4xIcbh1FQ=
Date: Tue, 12 May 2026 12:22:50 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,ljs@kernel.org,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch added to mm-new branch
Message-Id: <20260512192250.A1492C2BCC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix mmap() return value check in run_migration_benchmark
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix mmap() return value check in run_migration_benchmark
Date: Tue, 12 May 2026 18:13:05 +0800

mmap() returns MAP_FAILED on error, not NULL.  The current check uses
!buffer->ptr, which evaluates to false when mmap() fails (since MAP_FAILED
is (void *)-1, not 0), so the error path is never taken.

Link: https://lore.kernel.org/20260512101305.139509-1-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2740,7 +2740,7 @@ static inline int run_migration_benchmar
 	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	if (!buffer->ptr)
+	if (buffer->ptr == MAP_FAILED)
 		return -1;
 
 	/* Apply THP hint if requested */
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-fix-mmap-return-value-check-in-run_migration_benchmark.patch

