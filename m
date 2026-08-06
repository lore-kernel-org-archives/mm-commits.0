Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3428411F83
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050009; cv=none; b=D2eQsf6zfV/cIBBefh9/RrsLQ1Fxvum4NwMjM728nmRz7SOW+Db0DfVhFw5G4AQu1kVEKSwp6zweUMNZNVa+B4zlk1aaW7rLZ4kghg3gENqEJ5blCTilBF5NyNELDOSATTvY3l3Ga9+LdeI8Osrv0kWjRH+Qg/V6eZA8WqJV6Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050009; c=relaxed/simple;
	bh=pk0xlf8Bfih6d1L1tSStOQEItC52wauIiY7pxtzhiu0=;
	h=Date:To:From:Subject:Message-Id; b=Ow9lEP9elpGqWeLb1R4DqA1V8lv+700NrjbO9/Cpjm0Ie4x4cLwbwrwJSlFKxkJQrbFf2qzqqQ3j4RzSyjmagAXf3tCcv5kpsXcSKK6iNBtUALDH/y1v+I75BuY5qcoLFV401Jy3faCMS0LNXLonPVO3cRO7gF2daOrTbXE7fb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZ6+thIZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZ6+thIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB77A1F00A3A;
	Thu,  6 Aug 2026 21:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786050005;
	bh=ZSHSHn7J3lqgu8dsQKkmZ8L5bUImMp9wrm33/SqR4fs=;
	h=Date:To:From:Subject;
	b=zZ6+thIZAuEKfo+xlsWAMsNGIrHSjrrML2dSN6KAryBNW9lGQsTyfiD/vkXQ98aPP
	 i8iDq8ACk+iLe9et5OlUO3JOhIzfespF8ri5nz+9eri64wc/sC1uCNXI9z9IibaIUQ
	 GEGr/875V1G6LolotnN/4pXxVGZWftwTFqr9sXY8=
Date: Thu, 06 Aug 2026 14:00:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch added to mm-new branch
Message-Id: <20260806210005.AB77A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch

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
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
Date: Mon, 27 Jul 2026 10:52:18 +0100

The hole_punch case verifies that guard regions survive MADV_REMOVE and
that the backing range is punched out.  MADV_REMOVE delegates the hole
punch to the backing filesystem, which may reject the operation with
EOPNOTSUPP.

That result means the test cannot establish the state whose guard
semantics it intends to validate.  Treating the missing filesystem
capability as a guard-region failure creates a false regression.

Unmap the range and skip only when MADV_REMOVE fails with EOPNOTSUPP. 
Preserve the assertion for all other errors so failures on supported
configurations remain visible.

Link: https://lore.kernel.org/20260727095225.372655-3-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -1912,7 +1912,7 @@ TEST_F(guard_regions, hole_punch)
 {
 	const unsigned long page_size = self->page_size;
 	char *ptr;
-	int i;
+	int i, ret;
 
 	if (variant->backing == ANON_BACKED)
 		SKIP(return, "Truncation test specific to file-backed");
@@ -1944,8 +1944,12 @@ TEST_F(guard_regions, hole_punch)
 	}
 
 	/* Now hole punch the guarded region. */
-	ASSERT_EQ(madvise(&ptr[3 * page_size], 4 * page_size,
-			  MADV_REMOVE), 0);
+	ret = madvise(&ptr[3 * page_size], 4 * page_size, MADV_REMOVE);
+	if (ret == -1 && errno == EOPNOTSUPP) {
+		ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
+		SKIP(return, "MADV_REMOVE not supported by filesystem");
+	}
+	ASSERT_EQ(ret, 0);
 
 	/* Ensure guard regions remain. */
 	for (i = 0; i < 10; i++) {
_

Patches currently in -mm which might be from usama.anjum@arm.com are

selftests-mm-unpoison-pages-in-memory-failure-teardown.patch
selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch
selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch
selftests-mm-skip-khugepaged-swap-tests-without-swap.patch
selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch
selftests-mm-retry-migration-failures-for-the-full-runtime.patch

