Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71453D310;
	Fri, 26 Jan 2024 07:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255752; cv=none; b=iJin4pALxaXDGK5mqTC1+D7pv0+Lut9rvnZHXGPsfFBDyO7aKmpqUEX+8gZoEDinu+tlpYbkQfJ3TUK6vpuy+kql8P4+6oIDbwMGyBiy1NKVI+Dfn3kx2pKdx9dyKXYX2wmAQ4acBUasKc3oBhvVfQV4DdwZePueruaULk88bPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255752; c=relaxed/simple;
	bh=M/QUWP76IB4VJUcP++vvVHDkJnZGDAdduOWwKZEac+0=;
	h=Date:To:From:Subject:Message-Id; b=X4kt04Jlc2uxUImbPT+XUVL0Y4rcnoqegG/MZ6xzPOY1q68RofM6iGZ43mEOWfeT8D5h32pvjl6bPHcsov7K8a9j4FzebRddrmUm9iJWhweF8nV2QbGwIrNSqiUO4r+2nFp413suUQv1cWWIXfxkGl1DVDwivNWzU1P4C2khFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g6cTJpAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g6cTJpAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E49CC433F1;
	Fri, 26 Jan 2024 07:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255751;
	bh=M/QUWP76IB4VJUcP++vvVHDkJnZGDAdduOWwKZEac+0=;
	h=Date:To:From:Subject:From;
	b=g6cTJpAKWb6sIIZhyQOB14q9s0lnGXeC46WqQkb35dqcG/rIOTqGItqygRkYRe9Cx
	 zTQBKE6IMfkJe7zfY9zfFJLEnRYHcbJMjq3Eli2L2dQV2Y6LvHHawhHvg6GRjXeW3d
	 RXw/mQ0+G+tCoVn9St2VwmMDKWvEagv0w2oVGGTw=
Date: Thu, 25 Jan 2024 23:55:49 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,pedrodemargomes@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch removed from -mm tree
Message-Id: <20240126075551.7E49CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: ksm_tests should only MADV_HUGEPAGE valid memory
has been removed from the -mm tree.  Its filename was
     selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: ksm_tests should only MADV_HUGEPAGE valid memory
Date: Mon, 22 Jan 2024 12:05:54 +0000

ksm_tests was previously mmapping a region of memory, aligning the
returned pointer to a PMD boundary, then setting MADV_HUGEPAGE, but was
setting it past the end of the mmapped area due to not taking the pointer
alignment into consideration.  Fix this behaviour.

Up until commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries"), this buggy behavior was (usually) masked because the
alignment difference was always less than PMD-size.  But since the
mentioned commit, `ksm_tests -H -s 100` started failing.

Link: https://lkml.kernel.org/r/20240122120554.3108022-1-ryan.roberts@arm.com
Fixes: 325254899684 ("selftests: vm: add KSM huge pages merging time test")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -566,7 +566,7 @@ static int ksm_merge_hugepages_time(int
 	if (map_ptr_orig == MAP_FAILED)
 		err(2, "initial mmap");
 
-	if (madvise(map_ptr, len + HPAGE_SIZE, MADV_HUGEPAGE))
+	if (madvise(map_ptr, len, MADV_HUGEPAGE))
 		err(2, "MADV_HUGEPAGE");
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch
tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch

