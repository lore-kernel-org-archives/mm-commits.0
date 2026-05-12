Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E553822B9
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 21:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778621272; cv=none; b=S0Acbm1mra1Dhr4ND12sU60ClhKeBFzl4J9BsAuPYNZkJxk2YRU/AJ7Im4scXpVsKfRWhJnd+QwMS9PkUoa3ZusxSYu5dRudOxuG3xz6ABb+kTK34n9Lc3RrjXgadWoWd4X3q4naL0+B8pVbOF1U32w0Q8gftjLFbm7pBs0EQvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778621272; c=relaxed/simple;
	bh=rABy34ZJVQsu3uhGut26IpLkRsz0pPQiF8SvNhso7Rg=;
	h=Date:To:From:Subject:Message-Id; b=T7+iYmkt3kxPXSTTeUWc95eqK1R7h+Aw+OgUWseU9hrIfwC3FSQMK1wuUizn7IdkAAmP+Zz75B9IO+mD+cLngsRLPNMHqotd8ah/n1FS+gvnHLZMJOn7acvSgby4FWcIC8JDfTxzJpv5ob+1Nt3D74AbmBquAAvt7Lvp3Hnzjqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eABHurDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eABHurDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C331FC2BCB0;
	Tue, 12 May 2026 21:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778621271;
	bh=rABy34ZJVQsu3uhGut26IpLkRsz0pPQiF8SvNhso7Rg=;
	h=Date:To:From:Subject:From;
	b=eABHurDx9DzMsfVeVLlA/DGsornfz7q8D2V9KKWSWBGM6LUdJMvygZUzPpjaZ9/rB
	 9/n2H3b71dOhgwz8uKzw9nWwiK/41yzX4n6zmfyX3PvPyaamqP6GhfEV8Q4TS3CFCB
	 1XIL23QneW6777BkswiE2UiO0doSviJVFjiIyb+Q=
Date: Tue, 12 May 2026 14:27:51 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch added to mm-new branch
Message-Id: <20260512212751.C331FC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: check file initialization writes in split_huge_page_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch

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
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: selftests/mm: check file initialization writes in split_huge_page_test
Date: Tue, 12 May 2026 13:19:24 +0530

create_pagecache_thp_and_fd() fills the backing file for the pagecache THP
tests using repeated write() calls, but the return value is never checked.

If a write fails or completes only partially, the test may continue with
an incompletely initialized file and produce misleading results.

Check the result of write() and fail the test if the expected number of
bytes was not written.

Link: https://lore.kernel.org/20260512074924.27721-1-agarwal.vineet2006@gmail.com
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-check-file-initialization-writes-in-split_huge_page_test
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -609,9 +609,16 @@ static int create_pagecache_thp_and_fd(c
 	assert(fd_size % sizeof(buf) == 0);
 	for (i = 0; i < sizeof(buf); i++)
 		buf[i] = (unsigned char)i;
-	for (i = 0; i < fd_size; i += sizeof(buf))
-		write(*fd, buf, sizeof(buf));
+	for (i = 0; i < fd_size; i += sizeof(buf)) {
+		ssize_t written;
 
+		written = write(*fd, buf, sizeof(buf));
+		if (written != sizeof(buf)) {
+			ksft_perror("write testfile");
+			close(*fd);
+			goto err_out_unlink;
+		}
+	}
 	close(*fd);
 	sync();
 	*fd = open("/proc/sys/vm/drop_caches", O_WRONLY);
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are

selftests-mm-khugepaged-initialize-file-contents-via-mmap.patch
mm-khugepaged-return-eagain-for-scan_page_has_private-in-madv_collapse.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test.patch

