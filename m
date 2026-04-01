Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390681DF748
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 00:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775004827; cv=none; b=RX4BSc3fpxMfclwUKH32CD76m+YjH0RnLeF/OED8nDzXBeTbtyiUzcW9HW689ENUo8/qiiVc87ro40FifH9PVyoVy/pqqW2MpJ4VR9Uyvl4Zm+4XosekmhK8WR1kzFae2zSpnert4S5G8vLLnHRZprufgDpHbyHdkx374hXbejE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775004827; c=relaxed/simple;
	bh=2tGIryAe6stZEuVkwjAJjh+GWDTu6nDtWCBQSvQRA/0=;
	h=Date:To:From:Subject:Message-Id; b=GmIhHdCGfO97kB2/inYLnBBpGzAZMFDzEznqJBjXk/n84t/RvT8RZ0s4hd0Y9rle2TF+tX39LJ5Y4d1ZyTheZauTUQ8fcn53lH30so/rPQzFRCyFFn7hi1pk714Fgmnpf+Y1J45640dlvF28xZO4svN6nscId7huSEAERlQTcwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UA06DASl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UA06DASl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A843BC19423;
	Wed,  1 Apr 2026 00:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775004826;
	bh=2tGIryAe6stZEuVkwjAJjh+GWDTu6nDtWCBQSvQRA/0=;
	h=Date:To:From:Subject:From;
	b=UA06DASlFJm2BnjrhQtD1cJyQHFnQk+dNz00CvchVVTHIIRgiNZXV7tW2NNacxyLO
	 iY/QFUcLlzmJR1yrCPCOHy3Y4E9y4aiIOrpMjmDg6tZXe/5N6J8hs7ab77Qpwcw0a2
	 hyY52y7o2YAa47rB3+PsrU1yV+841Z/nrV/aAzmg=
Date: Tue, 31 Mar 2026 17:53:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-merge-test-for-partial-msealed-range.patch removed from -mm tree
Message-Id: <20260401005346.A843BC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add merge test for partial msealed range
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-merge-test-for-partial-msealed-range.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: selftests/mm: add merge test for partial msealed range
Date: Mon, 30 Mar 2026 14:50:11 +0100

Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
an issue in the loop which iterates through VMAs applying mseal, which was
triggered by mseal()'ing a range of VMAs where the second was mseal()'d
and the first mergeable with it, once mseal()'d.

Add a regression test to assert that this behaviour is correct.  We place
it in the merge selftests as this is strictly an issue with merging (via a
vma_modify() invocation).

It also assert that mseal()'d ranges are correctly merged as you'd expect.

The test is implemented such that it is skipped if mseal() is not
available on the system.

[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20260330135011.107036-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |   76 +++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~selftests-mm-add-merge-test-for-partial-msealed-range
+++ a/tools/testing/selftests/mm/merge.c
@@ -6,6 +6,7 @@
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <asm-generic/unistd.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/prctl.h>
@@ -1217,6 +1218,81 @@ TEST_F(merge, mremap_correct_placed_faul
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
+TEST_F(merge, merge_vmas_with_mseal)
+{
+	unsigned int page_size = self->page_size;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+	/* We need our own as cannot munmap() once sealed. */
+	char *carveout;
+
+	/* Invalid mseal() call to see if implemented. */
+	ASSERT_EQ(syscall(__NR_mseal, 0, 0, ~0UL), -1);
+	if (errno == ENOSYS)
+		SKIP(return, "mseal not supported, skipping.");
+
+	/* Map carveout. */
+	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
+			MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(carveout, MAP_FAILED);
+
+	/*
+	 * Map 3 separate VMAs:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWE    |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
+		    PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * mseal the second VMA:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ASSERT_EQ(syscall(__NR_mseal, (unsigned long)ptr2, 5 * page_size, 0), 0);
+
+	/* Make first VMA mergeable upon mseal. */
+	ASSERT_EQ(mprotect(ptr, 5 * page_size,
+			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
+	/*
+	 * At this point we have:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RWE    |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 *
+	 * Now mseal all of the VMAs.
+	 */
+	ASSERT_EQ(syscall(__NR_mseal, (unsigned long)ptr, 15 * page_size, 0), 0);
+
+	/*
+	 * We should end up with:
+	 *
+	 * |-----------------------|-----------|
+	 * |          RWES         |    ROS    |
+	 * |-----------------------|-----------|
+	 *            ptr               ptr3
+	 */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-khugepaged-fix-issue-with-tracking-lock.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

