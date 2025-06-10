Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA22265CB2
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588769; cv=none; b=efxeqBj6XUZXILCtqlUZ2q7RQLCOdsC4nba3PoDqY6EqirqILjfQreiPCiO3dUG20qoE1jdT/yEJr/h4dkhagSIqu1YdFBIB2g5Fl5cLmQ78roMGYIJT7uDviM4B4lEdAza4BUqJ9BZXvyUxdCtui6HfYzwXbGWSs08xO8OJZro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588769; c=relaxed/simple;
	bh=oVvcT6+xkiJawMjKGSo8Z63pu043C3t46sO1TXGljhM=;
	h=Date:To:From:Subject:Message-Id; b=H8CFv/Hv4sPBKCRiG1AZXShQbpY4LIvS0nc1F6aBJRo3z90fCyG5S25w/eYe9sW4oFgCjEA35zlS5NuCYWbRSPZjMJYmxB7Nu9SExaUWngrwLBg/rD/P137pqP+s7sbIokO9gsFWe8+cdKnRkQVyLMi72lfRlCP2H7Ed5Qfr58I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EH/AvtQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EH/AvtQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB30C4CEED;
	Tue, 10 Jun 2025 20:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588768;
	bh=oVvcT6+xkiJawMjKGSo8Z63pu043C3t46sO1TXGljhM=;
	h=Date:To:From:Subject:From;
	b=EH/AvtQfaTkL8u2TXMESpG+nf0FyrKLk6T7vQZMuiOiQCcyopKkHan92M2iCh0bGf
	 0b/0tWXcuCXVnUHEAuMge95+5syC+CniPATd4eMWZJhFesyk6YxD3H5VzFPqNGcTNB
	 XJjNKoR+iaYd5FXHK/oPJVhtAfZMawX18sf+Pe/Q=
Date: Tue, 10 Jun 2025 13:52:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-mremap-cases-that-merge-normally.patch added to mm-new branch
Message-Id: <20250610205248.4BB30C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add mremap() cases that merge normally
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-add-mremap-cases-that-merge-normally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-mremap-cases-that-merge-normally.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: add mremap() cases that merge normally
Date: Mon, 9 Jun 2025 14:26:40 +0100

Use a direct system call version of mremap() as, when we move to using
MREMAP_[MUST_]RELOCATE_ANON, the glibc wrapper will disallow this.

Also import linux/mman.h (which will amount to the local tools cache of
mman.h) to enusre these header values are available when later added.

Then, add tests asserting all the mremap() merge cases that function
correctly without MREMAP_[MUST_]RELOCATE_ANON.

This constitutes moving around unfaulted VMAs and moving around faulted
VMAs back into position immediately adjacent to VMAs also faulted in with
that moved VMA.

By doing so we provide a baseline set of expectations on mremap()
operations and VMA merge which we can expand upon for
MREMAP_[MUST_]RELOCATE_ANON cases in a subsequent commit.

Link: https://lkml.kernel.org/r/094de8c0b76b8a040f5ad6ede0c09e14a949915f.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |  599 ++++++++++++++++++++++++++-
 1 file changed, 597 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-mremap-cases-that-merge-normally
+++ a/tools/testing/selftests/mm/merge.c
@@ -13,6 +13,7 @@
 #include <sys/wait.h>
 #include <linux/perf_event.h>
 #include "vm_util.h"
+#include <linux/mman.h>
 
 FIXTURE(merge)
 {
@@ -25,7 +26,7 @@ FIXTURE_SETUP(merge)
 {
 	self->page_size = psize();
 	/* Carve out PROT_NONE region to map over. */
-	self->carveout = mmap(NULL, 12 * self->page_size, PROT_NONE,
+	self->carveout = mmap(NULL, 30 * self->page_size, PROT_NONE,
 			      MAP_ANON | MAP_PRIVATE, -1, 0);
 	ASSERT_NE(self->carveout, MAP_FAILED);
 	/* Setup PROCMAP_QUERY interface. */
@@ -34,7 +35,7 @@ FIXTURE_SETUP(merge)
 
 FIXTURE_TEARDOWN(merge)
 {
-	ASSERT_EQ(munmap(self->carveout, 12 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
 	ASSERT_EQ(close_procmap(&self->procmap), 0);
 	/*
 	 * Clear unconditionally, as some tests set this. It is no issue if this
@@ -576,4 +577,598 @@ TEST_F(merge, ksm_merge)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
+TEST_F(merge, mremap_unfaulted_to_faulted)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2;
+
+	/*
+	 * Map two distinct areas:
+	 *
+	 * |-----------|  |-----------|
+	 * | unfaulted |  | unfaulted |
+	 * |-----------|  |-----------|
+	 *      ptr            ptr2
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[7 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Offset ptr2 further away. */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Fault in ptr:
+	 *                \
+	 * |-----------|  /  |-----------|
+	 * |  faulted  |  \  | unfaulted |
+	 * |-----------|  /  |-----------|
+	 *      ptr       \       ptr2
+	 */
+	ptr[0] = 'x';
+
+	/*
+	 * Now move ptr2 adjacent to ptr:
+	 *
+	 * |-----------|-----------|
+	 * |  faulted  | unfaulted |
+	 * |-----------|-----------|
+	 *      ptr         ptr2
+	 *
+	 * It should merge:
+	 *
+	 * |----------------------|
+	 * |       faulted        |
+	 * |----------------------|
+	 *            ptr
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
+TEST_F(merge, mremap_unfaulted_behind_faulted)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2;
+
+	/*
+	 * Map two distinct areas:
+	 *
+	 * |-----------|  |-----------|
+	 * | unfaulted |  | unfaulted |
+	 * |-----------|  |-----------|
+	 *      ptr            ptr2
+	 */
+	ptr = mmap(&carveout[6 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[14 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Offset ptr2 further away. */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Fault in ptr:
+	 *                \
+	 * |-----------|  /  |-----------|
+	 * |  faulted  |  \  | unfaulted |
+	 * |-----------|  /  |-----------|
+	 *      ptr       \       ptr2
+	 */
+	ptr[0] = 'x';
+
+	/*
+	 * Now move ptr2 adjacent, but behind, ptr:
+	 *
+	 * |-----------|-----------|
+	 * | unfaulted |  faulted  |
+	 * |-----------|-----------|
+	 *      ptr2        ptr
+	 *
+	 * It should merge:
+	 *
+	 * |----------------------|
+	 * |       faulted        |
+	 * |----------------------|
+	 *            ptr2
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &carveout[page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr2));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr2);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr2 + 10 * page_size);
+}
+
+TEST_F(merge, mremap_unfaulted_between_faulted)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+
+	/*
+	 * Map three distinct areas:
+	 *
+	 * |-----------|  |-----------|  |-----------|
+	 * | unfaulted |  | unfaulted |  | unfaulted |
+	 * |-----------|  |-----------|  |-----------|
+	 *      ptr            ptr2           ptr3
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[7 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[14 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/* Offset ptr3 further away. */
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/* Offset ptr2 further away. */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Fault in ptr, ptr3:
+	 *                \                 \
+	 * |-----------|  /  |-----------|  /  |-----------|
+	 * |  faulted  |  \  | unfaulted |  \  |  faulted  |
+	 * |-----------|  /  |-----------|  /  |-----------|
+	 *      ptr       \       ptr2      \       ptr3
+	 */
+	ptr[0] = 'x';
+	ptr3[0] = 'x';
+
+	/*
+	 * Move ptr3 back into place, leaving a place for ptr2:
+	 *                                        \
+	 * |-----------|           |-----------|  /  |-----------|
+	 * |  faulted  |           |  faulted  |  \  | unfaulted |
+	 * |-----------|           |-----------|  /  |-----------|
+	 *      ptr                     ptr3      \       ptr2
+	 */
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[10 * page_size]);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * Finally, move ptr2 into place:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |  faulted  | unfaulted |  faulted  |
+	 * |-----------|-----------|-----------|
+	 *      ptr        ptr2         ptr3
+	 *
+	 * It should merge, but only ptr, ptr2:
+	 *
+	 * |-----------------------|-----------|
+	 * |        faulted        | unfaulted |
+	 * |-----------------------|-----------|
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr3));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr3);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr3 + 5 * page_size);
+}
+
+TEST_F(merge, mremap_unfaulted_between_faulted_unfaulted)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+
+	/*
+	 * Map three distinct areas:
+	 *
+	 * |-----------|  |-----------|  |-----------|
+	 * | unfaulted |  | unfaulted |  | unfaulted |
+	 * |-----------|  |-----------|  |-----------|
+	 *      ptr            ptr2           ptr3
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[7 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[14 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/* Offset ptr3 further away. */
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+
+	/* Offset ptr2 further away. */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Fault in ptr:
+	 *                \                 \
+	 * |-----------|  /  |-----------|  /  |-----------|
+	 * |  faulted  |  \  | unfaulted |  \  | unfaulted |
+	 * |-----------|  /  |-----------|  /  |-----------|
+	 *      ptr       \       ptr2      \       ptr3
+	 */
+	ptr[0] = 'x';
+
+	/*
+	 * Move ptr3 back into place, leaving a place for ptr2:
+	 *                                        \
+	 * |-----------|           |-----------|  /  |-----------|
+	 * |  faulted  |           | unfaulted |  \  | unfaulted |
+	 * |-----------|           |-----------|  /  |-----------|
+	 *      ptr                     ptr3      \       ptr2
+	 */
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[10 * page_size]);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * Finally, move ptr2 into place:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |  faulted  | unfaulted | unfaulted |
+	 * |-----------|-----------|-----------|
+	 *      ptr        ptr2         ptr3
+	 *
+	 * It should merge:
+	 *
+	 * |-----------------------------------|
+	 * |              faulted              |
+	 * |-----------------------------------|
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+}
+
+TEST_F(merge, mremap_unfaulted_between_correctly_placed_faulted)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2;
+
+	/*
+	 * Map one larger area:
+	 *
+	 * |-----------------------------------|
+	 * |            unfaulted              |
+	 * |-----------------------------------|
+	 */
+	ptr = mmap(&carveout[page_size], 15 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Fault in ptr:
+	 *
+	 * |-----------------------------------|
+	 * |              faulted              |
+	 * |-----------------------------------|
+	 */
+	ptr[0] = 'x';
+
+	/*
+	 * Unmap middle:
+	 *
+	 * |-----------|           |-----------|
+	 * |  faulted  |           |  faulted  |
+	 * |-----------|           |-----------|
+	 *
+	 * Now the faulted areas are compatible with each other (anon_vma the
+	 * same, vma->vm_pgoff equal to virtual page offset).
+	 */
+	ASSERT_EQ(munmap(&ptr[5 * page_size], 5 * page_size), 0);
+
+	/*
+	 * Map a new area, ptr2:
+	 *                                        \
+	 * |-----------|           |-----------|  /  |-----------|
+	 * |  faulted  |           |  faulted  |  \  | unfaulted |
+	 * |-----------|           |-----------|  /  |-----------|
+	 *      ptr                               \       ptr2
+	 */
+	ptr2 = mmap(&carveout[20 * page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Finally, move ptr2 into place:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |  faulted  | unfaulted |  faulted  |
+	 * |-----------|-----------|-----------|
+	 *      ptr        ptr2         ptr3
+	 *
+	 * It should merge:
+	 *
+	 * |-----------------------------------|
+	 * |              faulted              |
+	 * |-----------------------------------|
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+}
+
+TEST_F(merge, mremap_correct_placed_faulted)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+
+	/*
+	 * Map one larger area:
+	 *
+	 * |-----------------------------------|
+	 * |            unfaulted              |
+	 * |-----------------------------------|
+	 */
+	ptr = mmap(&carveout[page_size], 15 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Fault in ptr:
+	 *
+	 * |-----------------------------------|
+	 * |              faulted              |
+	 * |-----------------------------------|
+	 */
+	ptr[0] = 'x';
+
+	/*
+	 * Offset the final and middle 5 pages further away:
+	 *                \                 \
+	 * |-----------|  /  |-----------|  /  |-----------|
+	 * |  faulted  |  \  |  faulted  |  \  |  faulted  |
+	 * |-----------|  /  |-----------|  /  |-----------|
+	 *      ptr       \       ptr2      \       ptr3
+	 */
+	ptr3 = &ptr[10 * page_size];
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+	ASSERT_NE(ptr3, MAP_FAILED);
+	ptr2 = &ptr[5 * page_size];
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Move ptr2 into its correct place:
+	 *                            \
+	 * |-----------|-----------|  /  |-----------|
+	 * |  faulted  |  faulted  |  \  |  faulted  |
+	 * |-----------|-----------|  /  |-----------|
+	 *      ptr         ptr2      \       ptr3
+	 *
+	 * It should merge:
+	 *                            \
+	 * |-----------------------|  /  |-----------|
+	 * |        faulted        |  \  |  faulted  |
+	 * |-----------------------|  /  |-----------|
+	 *            ptr             \       ptr3
+	 */
+
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+
+	/*
+	 * Now move ptr out of place:
+	 *                            \                 \
+	 *             |-----------|  /  |-----------|  /  |-----------|
+	 *             |  faulted  |  \  |  faulted  |  \  |  faulted  |
+	 *             |-----------|  /  |-----------|  /  |-----------|
+	 *                  ptr2      \       ptr       \       ptr3
+	 */
+	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Now move ptr back into place:
+	 *                            \
+	 * |-----------|-----------|  /  |-----------|
+	 * |  faulted  |  faulted  |  \  |  faulted  |
+	 * |-----------|-----------|  /  |-----------|
+	 *      ptr         ptr2      \       ptr3
+	 *
+	 * It should merge:
+	 *                            \
+	 * |-----------------------|  /  |-----------|
+	 * |        faulted        |  \  |  faulted  |
+	 * |-----------------------|  /  |-----------|
+	 *            ptr             \       ptr3
+	 */
+	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
+			 MREMAP_MAYMOVE | MREMAP_FIXED, &carveout[page_size]);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+
+	/*
+	 * Now move ptr out of place again:
+	 *                            \                 \
+	 *             |-----------|  /  |-----------|  /  |-----------|
+	 *             |  faulted  |  \  |  faulted  |  \  |  faulted  |
+	 *             |-----------|  /  |-----------|  /  |-----------|
+	 *                  ptr2      \       ptr       \       ptr3
+	 */
+	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Now move ptr3 back into place:
+	 *                                        \
+	 *             |-----------|-----------|  /  |-----------|
+	 *             |  faulted  |  faulted  |  \  |  faulted  |
+	 *             |-----------|-----------|  /  |-----------|
+	 *                  ptr2        ptr3      \       ptr
+	 *
+	 * It should merge:
+	 *                                        \
+	 *             |-----------------------|  /  |-----------|
+	 *             |        faulted        |  \  |  faulted  |
+	 *             |-----------------------|  /  |-----------|
+	 *                        ptr2            \       ptr
+	 */
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr2[5 * page_size]);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr2));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr2);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr2 + 10 * page_size);
+
+	/*
+	 * Now move ptr back into place:
+	 *
+	 * |-----------|-----------------------|
+	 * |  faulted  |        faulted        |
+	 * |-----------|-----------------------|
+	 *      ptr               ptr2
+	 *
+	 * It should merge:
+	 *
+	 * |-----------------------------------|
+	 * |              faulted              |
+	 * |-----------------------------------|
+	 *                  ptr
+	 */
+	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
+			 MREMAP_MAYMOVE | MREMAP_FIXED, &carveout[page_size]);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+
+	/*
+	 * Now move ptr2 out of the way:
+	 *                                        \
+	 * |-----------|           |-----------|  /  |-----------|
+	 * |  faulted  |           |  faulted  |  \  |  faulted  |
+	 * |-----------|           |-----------|  /  |-----------|
+	 *      ptr                     ptr3      \       ptr2
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Now move it back:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |  faulted  |  faulted  |  faulted  |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 *
+	 * It should merge:
+	 *
+	 * |-----------------------------------|
+	 * |              faulted              |
+	 * |-----------------------------------|
+	 *                  ptr
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+
+	/*
+	 * Move ptr3 out of place:
+	 *                                        \
+	 * |-----------------------|              /  |-----------|
+	 * |        faulted        |              \  |  faulted  |
+	 * |-----------------------|              /  |-----------|
+	 *            ptr                         \       ptr3
+	 */
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 1000);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * Now move it back:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |  faulted  |  faulted  |  faulted  |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 *
+	 * It should merge:
+	 *
+	 * |-----------------------------------|
+	 * |              faulted              |
+	 * |-----------------------------------|
+	 *                  ptr
+	 */
+	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED, &ptr[10 * page_size]);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

