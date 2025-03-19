Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F4513DDB9
	for <mm-commits@vger.kernel.org>; Wed, 19 Mar 2025 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742350690; cv=none; b=DkUfjiQQ3LDWdoXybWmFezdeX0+A9CbH/SSJefejBFCHs39KA2aZd+iagnc2abY80R92kjC8X1x48Quro0+tlJlMtDg0CL+h3yZrSpDbPWgSHXSH0tfVodvFQKeVQWvKPmeYkaBeK3+hzt+G7dGWQYMDRnPiPPCTIFEs+5PKROQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742350690; c=relaxed/simple;
	bh=V9w6iXIHhDYE/98FMmLETOPXi66YUD5hvfDkmy+JFas=;
	h=Date:To:From:Subject:Message-Id; b=L72qBmA1uZfcA9PoZskwSGLgtPNkhdsAPL8k/cPH6ELcxEy/jrQ8ha/UqPGpxyvHRbzeKPUSn6xOB5xGLu/x3CKSX8ybsibFe4mt0wXN18cW0SK3o++awVVfcN8AUykX0RWC9h3QV1+ucWc6M03+Y361wMP0fZEmUqEhTVjpTSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u9DtXv+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u9DtXv+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2DEC4CEDD;
	Wed, 19 Mar 2025 02:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742350689;
	bh=V9w6iXIHhDYE/98FMmLETOPXi66YUD5hvfDkmy+JFas=;
	h=Date:To:From:Subject:From;
	b=u9DtXv+219m4wZGL8eYVgrkEeitxGafW5Z4ZQzqkYCIIfjz9hLRfvRflm3428WrBZ
	 7XUaIaRpLHK5OsVCgvUwRu6BoqX3sxIREMZKLQ2lajfC1DjmHAmMbF9kKFTLYFZRVj
	 GbE/TcMQLpPi8rRoJEnej7kEuehobHKUUI7rBnkE=
Date: Tue, 18 Mar 2025 19:18:09 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,raquini@redhat.com,peterx@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-speed-up-split_huge_page_test.patch added to mm-unstable branch
Message-Id: <20250319021809.DB2DEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: speed up split_huge_page_test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-speed-up-split_huge_page_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-speed-up-split_huge_page_test.patch

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

selftests-mm-uffd-unit-tests-support-for-hugepages-2m.patch
selftests-mm-speed-up-split_huge_page_test.patch

