Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508B3153BD9
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619852; cv=none; b=USzIewah6R3J1Fddbk4NMmLvd3Qlp+rRRQp4aa2fSdHE9EHV8LlnLu6xw3IImh3SpvF474I+6Zc9THfgpUQVRPQYLEa5lFPSF9CQH3SMAdeoYpp/Y20GfUUxMYc6ijOTdvyWX/sw+xymGF6MN+k1BVi+qV8ChCu9upmVOIIujjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619852; c=relaxed/simple;
	bh=vH851cFuThH1srAoFvPYFdMoroMjf7x80zxgkiEWJ0U=;
	h=Date:To:From:Subject:Message-Id; b=IZuvXhS64Te8YYVPT1prJzU7b3+9MD0Vkchqpktvn6Mq+XGdjqShEmevY3+qKMFTtaQXnHYeEC4wz2p2XgzmzTV8RrIzHSHSkeA3hdUxKs2GGBE8OcqX1vAn8n5Rm0b1SAhLMS+jbSlKV5zmdP7PUb5Mug2M3L2f0WMWIyf5FFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wZhwtjNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wZhwtjNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B6DC4CEEC;
	Sat, 22 Mar 2025 05:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619851;
	bh=vH851cFuThH1srAoFvPYFdMoroMjf7x80zxgkiEWJ0U=;
	h=Date:To:From:Subject:From;
	b=wZhwtjNqqmdS/9bjMCRS9GhUda5JZ2+5mKNrrvL/v30kuHG+MzJxqFmExevFHqvgv
	 5i6FkBYN8JYl54H7IMUeCJe+yMGitpQE4zm4AEZLU0lf1pPQd5PMF1j71Hy/j2+qqq
	 y+Ds3zTS6FnpP+nR1nuJiR1lvK4ERGNpz7z1bWA4=
Date: Fri, 21 Mar 2025 22:04:11 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,raquini@redhat.com,peterx@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-speed-up-split_huge_page_test.patch removed from -mm tree
Message-Id: <20250322050411.B1B6DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: speed up split_huge_page_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-speed-up-split_huge_page_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: speed up split_huge_page_test
Date: Tue, 18 Mar 2025 17:43:41 +0000

create_pagecache_thp_and_fd() was previously writing a file sized at twice
the PMD size by making a per-byte write syscall.  This was quite slow when
the PMD size is 4M, but completely intolerable for 32M (PMD size for
arm64's 16K page size), and 512M (PMD size for arm64's 64K page size).

The byte pattern has a 256 byte period, so let's create a 1K buffer and
fill it with exactly 4 periods.  Then we can write the buffer as many
times as is required to fill the file.  This makes things much more
tolerable.

The test now passes for 16K page size.  It still fails for 64K page size
because MAX_PAGECACHE_ORDER is too small for 512M folio size (I think).

Link: https://lkml.kernel.org/r/20250318174343.243631-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-speed-up-split_huge_page_test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -5,6 +5,7 @@
  */
 
 #define _GNU_SOURCE
+#include <assert.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
@@ -398,6 +399,7 @@ int create_pagecache_thp_and_fd(const ch
 {
 	size_t i;
 	int dummy = 0;
+	unsigned char buf[1024];
 
 	srand(time(NULL));
 
@@ -405,11 +407,12 @@ int create_pagecache_thp_and_fd(const ch
 	if (*fd == -1)
 		ksft_exit_fail_msg("Failed to create a file at %s\n", testfile);
 
-	for (i = 0; i < fd_size; i++) {
-		unsigned char byte = (unsigned char)i;
+	assert(fd_size % sizeof(buf) == 0);
+	for (i = 0; i < sizeof(buf); i++)
+		buf[i] = (unsigned char)i;
+	for (i = 0; i < fd_size; i += sizeof(buf))
+		write(*fd, buf, sizeof(buf));
 
-		write(*fd, &byte, sizeof(byte));
-	}
 	close(*fd);
 	sync();
 	*fd = open("/proc/sys/vm/drop_caches", O_WRONLY);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


