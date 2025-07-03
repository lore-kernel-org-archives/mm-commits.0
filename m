Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF281FDA89
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 23:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584001; cv=none; b=YkKFi3UbY2mtJzoVYMZi4MxSNgzmXd5/ahWHKm91RWl5mBj7CdLRD2dO3Y0jRiieX9PTl62LYBl7MwsvAvP9TyBsfTBycV2ei7j+s6DyzLibEhgybpjzNhsSpi0FF879GwOjimqOyClWBo32AwSOu0OBhpzzuj0upfOkWC/KloI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584001; c=relaxed/simple;
	bh=sIOUg85gv4UAaHPZQViJ4cIzOgsTmuqgB2Rav9J2RR0=;
	h=Date:To:From:Subject:Message-Id; b=P4RNNp4syRwF2PvFIXuc6rxM/QcPGLUcKnc0+YXPBd6p1tcpM5WbzFMQ67DJSL7MM2wsPfPtN41eAZoYTad9N7DGjSzWIG5tQquZT7woiU5x7mkVFiDI8jhsSQHreFPscKlfDrZWgcXxoa8VX9cUU7yHTZdc7qO9LF0wdbOs7fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zNonH7ZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zNonH7ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AB2C4CEE3;
	Thu,  3 Jul 2025 23:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751584000;
	bh=sIOUg85gv4UAaHPZQViJ4cIzOgsTmuqgB2Rav9J2RR0=;
	h=Date:To:From:Subject:From;
	b=zNonH7ZHoOKTD5U4AcWv9jswJ9DTyUd2WpiofRwkV9uxektPt6EPdNWmyly1Q3FV8
	 z/U3IpPXMGCodsKrjVQikH+WC63mJhybatasL3nrrhW/uJ213z9IOrMaoNROHp0Z1z
	 XgDG92UNwFi4BYcagtJbA2bkUnRVlNeCCJ6N2KEw=
Date: Thu, 03 Jul 2025 16:06:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch added to mm-new branch
Message-Id: <20250703230640.B2AB2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add mremap() unfaulted/faulted test cases
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch

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
Subject: tools/testing/selftests: add mremap() unfaulted/faulted test cases
Date: Wed, 2 Jul 2025 09:47:17 +0100

Assert that mremap() behaviour is as expected when moving around unfaulted
VMAs immediately adjacent to faulted ones, as well as moving around
faulted VMAs and placing them back immediately adjacent to the VMA from
which they were moved.

This also introduces a shared helper for the syscall version of mremap()
so we don't encounter any issues with libc filtering parameters.

Link: https://lkml.kernel.org/r/20250702084717.21360-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c   |  599 ++++++++++++++++++++++++-
 tools/testing/selftests/mm/vm_util.c |    8 
 tools/testing/selftests/mm/vm_util.h |    3 
 3 files changed, 608 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases
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
--- a/tools/testing/selftests/mm/vm_util.c~tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -559,3 +559,11 @@ void teardown_sighandler(void)
 	if (sigaction(SIGSEGV, &act, NULL))
 		ksft_exit_fail_perror("sigaction in teardown");
 }
+
+void *sys_mremap(void *old_address, unsigned long old_size,
+		 unsigned long new_size, int flags, void *new_address)
+{
+	return (void *)syscall(__NR_mremap, (unsigned long)old_address,
+			       old_size, new_size, flags,
+			       (unsigned long)new_address);
+}
--- a/tools/testing/selftests/mm/vm_util.h~tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -139,6 +139,9 @@ static inline void log_test_result(int r
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
+void *sys_mremap(void *old_address, unsigned long old_size,
+		 unsigned long new_size, int flags, void *new_address);
+
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
mm-maps-read-proc-pid-maps-under-per-vma-lock-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch

