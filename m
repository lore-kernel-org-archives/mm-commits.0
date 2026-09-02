Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8131E390226
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 19:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788376926; cv=none; b=VQma8No+R8M4TCCVgSLEs0DJ75PIwQz+cnqjZYzxOp3qz6oie/w5sMWOpPydLCO5lxwPCGgkRy/xeAptiPEX4u5IzmYvKZyDs5juAsTfLZvoqyucBT7w5ghFXZwSLWlstNcf9XrTR+mEq36Y/J1WyWj/WoK99GgUkO0sn6AF/uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788376926; c=relaxed/simple;
	bh=Mf7pJvf/fZfcN71ginTIaXwDik7c/q0p7ip2LqqI1k4=;
	h=Date:To:From:Subject:Message-Id; b=f12tBgubGLoN94ppqDnMVKOvskkIdAVBDZYTeI2NaxSfsn0a4UheNRHuvRSP8a40829RJoW3WFcUKbYv/QfWQwn4KcTndAZGKMKfwpJBXjyP3G9a0WBjj7JdX3zJXPld4qr2OqhJ1ZHo/PoZjIFBWNcumakwFkSAbZoDR9DtM8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eoWP/wmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eoWP/wmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DE41F000E9;
	Wed,  2 Sep 2026 19:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788376925;
	bh=+9hT+MhjVdhPM/Hs6zehwjUHyNj8A8cUQeP4ySPVjOY=;
	h=Date:To:From:Subject;
	b=eoWP/wmPLuom3SxCc0KGjzYS9N70nqMB1+7wcBs0uZi0wUTqBcofPhfCuMXQ2Xf+J
	 LBXc6cX4fR+pEMTvGaBPPdOMImqGBgn2fhLDL4VyFiYSf/58Aj8DbZl78eMapUMgaD
	 W/dHBDTImIzNjBEF9gv8nXGw4n1vC7SSFx5j1MVM=
Date: Wed, 02 Sep 2026 12:22:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,jack@suse.cz,hughd@google.com,gregkh@linuxfoundation.org,david@kernel.org,baolin.wang@linux.alibaba.com,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch added to mm-new branch
Message-Id: <20260902192205.27DE41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests
Date: Wed, 02 Sep 2026 19:00:23 +0100

Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
anonymous.

We test both unfaulted and faulted/unfaulted merges - each with the
regions having page offset of 0, which would not merge if the mappings
were treated as if they were file-backed.

With the recent change that makes them behave as pure anonymous mappings,
the merges should succeed as their page offsets are equal to their
anonymous page offsets.

Link: https://lore.kernel.org/20260902-map-private-dev-zero-v1-6-a578c730cec7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |  104 +++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests
+++ a/tools/testing/selftests/mm/merge.c
@@ -1362,6 +1362,110 @@ TEST_F(merge, anon_and_page_offset_misma
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
 }
 
+TEST_F(merge, merge_map_private_dev_zero_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map two MAP_PRIVATE-/dev/zero VMAs next to one another with offset 0
+	 * each.
+	 *
+	 * With these being made truly anonymous upon mapping, they will
+	 * merge. If they were file-backed VMAs the page offsets would prevent
+	 * merge:
+	 *
+	 * |-----||------|    |-------------|
+	 * | ptr || ptr2 | -> |     ptr     |
+	 * |-----||------|    |-------------|
+	 */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr2 == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	close(fd_zero);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
+TEST_F(merge, merge_map_private_dev_zero_faulted_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map a MAP_PRIVATE mapping of /dev/zero with page offset 0, then fault
+	 * it in:
+	 *
+	 * |-------------------------------|
+	 * |           faulted             |
+	 * |-------------------------------|
+	 */
+	ptr = mmap(carveout, 15 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	memset(ptr, 'x', 15 * page_size);
+
+	/*
+	 * Unmap the middle:
+	 *
+	 * |---------|           |---------|
+	 * | faulted |           | faulted |
+	 * |---------|           |---------|
+	 */
+	ASSERT_EQ(munmap(&ptr[5 * page_size], 5 * page_size), 0);
+
+	/*
+	 * Map in a new unfaulted mapping in the middle with page offset 0 -
+	 * this should merge and would not if it were treated as a file rather
+	 * than pure anon:
+	 *
+	 * |---------|-----------|---------|
+	 * | faulted | unfaulted | faulted |
+	 * |---------|-----------|---------|
+	 */
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd_zero, 0);
+	close(fd_zero);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch
mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch
mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

