Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2D426299
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 01:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775005224; cv=none; b=MN7wLKWu5ptfZf9aPQpUOTPimprHs2m9xP7+YKkwR+uAHc5o8kkkpd6C0tzQ2wicuF7ooKM5IiFzLQ1ZI3QHyc9RtZgUJOJt0+FGrlY4BQqqIkbIs7eqRDBssbqhL9OXUInksNYhwE5dk00vetdvGmg/hFJQ6hy7rkaEG2hm1ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775005224; c=relaxed/simple;
	bh=e2Yq9SqEpY2vQp/5Z/r4Hk5FyTvOyypTdLhPX/xpOf8=;
	h=Date:To:From:Subject:Message-Id; b=pvNCTcW7dvq0CCWKtuLWCM421vPhXkd7uK/XaKIFTptU0DNHDNAq51TIgnqmv5skDAyAuaxvbOR7ZgjPWLx/XO1U2T2DxGYmgRNx6W++uzVvd42wsKYDJ406CaSEp7hKgTiHvdI8g59+qWHvhYySI5s3Orc9crC0XpUve4C6oYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A9QdWj5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A9QdWj5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26262C19423;
	Wed,  1 Apr 2026 01:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775005224;
	bh=e2Yq9SqEpY2vQp/5Z/r4Hk5FyTvOyypTdLhPX/xpOf8=;
	h=Date:To:From:Subject:From;
	b=A9QdWj5/O0a/uj6rxgJJ4GQ+uf113hKmYRJbZNcoe0kWX808hlaFHMXYvLrNbUk4A
	 TPOTzKEHKq7Dxd3eDy897QU6M5yvs9YfCAAdDdpNYa0AmqjcDNrBFX9e/5Ec0+CD3E
	 bNBjWvK8eFS5ucmTnytjBKvJi2Z5Wi+jVCayEiAA=
Date: Tue, 31 Mar 2026 18:00:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch added to mm-new branch
Message-Id: <20260401010024.26262C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
Date: Tue, 31 Mar 2026 11:01:35 +0100

simplifications per Pedro

Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -1245,7 +1245,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 		SKIP(return, "mseal not supported, skipping.");
 
 	/* Map carveout. */
-	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
+	carveout = mmap(NULL, 5 * page_size, PROT_NONE,
 			MAP_PRIVATE | MAP_ANON, -1, 0);
 	ASSERT_NE(carveout, MAP_FAILED);
 
@@ -1257,14 +1257,14 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 * |-----------|-----------|-----------|
 	 *      ptr         ptr2        ptr3
 	 */
-	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
-	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
+	ptr2 = mmap(&carveout[2 * page_size], page_size,
 		    PROT_READ | PROT_WRITE | PROT_EXEC,
 		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr2, MAP_FAILED);
-	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
+	ptr3 = mmap(&carveout[3 * page_size], page_size, PROT_READ,
 		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
@@ -1276,10 +1276,10 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 * |-----------|-----------|-----------|
 	 *      ptr         ptr2        ptr3
 	 */
-	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
+	ASSERT_EQ(sys_mseal(ptr2, page_size, 0), 0);
 
 	/* Make first VMA mergeable upon mseal. */
-	ASSERT_EQ(mprotect(ptr, 5 * page_size,
+	ASSERT_EQ(mprotect(ptr, page_size,
 			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
 	/*
 	 * At this point we have:
@@ -1291,7 +1291,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 *
 	 * Now mseal all of the VMAs.
 	 */
-	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
+	ASSERT_EQ(sys_mseal(ptr, 3 * page_size, 0), 0);
 
 	/*
 	 * We should end up with:
@@ -1303,7 +1303,7 @@ TEST_F(merge, merge_vmas_with_mseal)
 	 */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-khugepaged-fix-issue-with-tracking-lock.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix.patch

