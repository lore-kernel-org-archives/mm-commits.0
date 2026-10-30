Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372268;
	b=cNSpal+O1xwHt8hJrDQsHIPXPm+gnrkmdSqeonWudvHMCpFzr/7Xsa7d4nTS353Qoj0F
	 lfPyKrRn5TmrIiwExPP+dyaQBk5jkDg2K8osTOtgnETRfKRxbPfnoiIos4nkhzg+8DRCJ
	 MjbHyEllFEKdnpvt9U1j9/7sT5fjbvojWYnXwA29xMngnT2EGOqKko/jLEVk0Q2RDi/b9
	 lb19LadqSiSYKLiPgXtFekCcCW2VILF7Ll3NcDGCp+4Aiq8O1/YXZrzp+uXzyFBeS3opi
	 tEl3KcQOAuRKd+uXLnqOsoczXrZO+JvaIHWaRPk9UUtqapu4syV4GQtGtoF4R1SgmtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372268;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SEy1cxS6s4BlEoGBfkoNM57kpq+z3xY5MG3+/v6RUc0=;
	b=aonyCcGUOPcl0Z3ZOV6hSslSdfgRnMQ0HOwBDQkZ+NfBaKfBDmx0bU8yIWCSufGfBYzp
	 qrgyiD8OGOXdaiHubK8Bz5ANQ7uvedjQfyf49l9VuX5oNAuDVNXkQ1/5SPTbYW6r+RrB/
	 LPAKPDuqlqtM/J1gLwZfIexG0x6rf9bRAYZANJRE6/vv1J7fj7M4k3Aeab7upyaC7ZEtJ
	 koZSG6j9y2NXyTKWI7STu5nXrk5LiCvVRdiRAyvwF+kn6QH/Z57gbLudVlTs//wxWZ1xo
	 TXaPGA8Imuf+HHPgF1udfUpgGAuTjqO/Ew+16d3YT5cNtBJEjsep8z0RphAYuOopTEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tIfc6OJ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B95606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tIfc6OJ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03981F000C1;
	Fri, 30 Oct 2026 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793372267;
	bh=SEy1cxS6s4BlEoGBfkoNM57kpq+z3xY5MG3+/v6RUc0=;
	h=Date:To:From:Subject;
	b=tIfc6OJ5lLKgfTeNpUdzVlWeuMQvthgBe74LIPXbb6J9Qq54I5bP2SYxPx82rHbVH
	 F+daRkUJzxtdZEz2Jmhh6Lv5GRfhAcexDeBvxpxQW22va+9OXJPyC2kkjGmcyQ0OfV
	 HYzTzoRSYhhgjiqln+QbNT2iF23RFC3l0Ee7jVwo=
Date: Fri, 30 Oct 2026 07:57:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,gourry@gourry.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch added to mm-new branch
Message-Id: <20261030145747.D03981F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: check that unauthorized MADV_PAGEOUT skips large file folios
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch

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
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: selftests/mm: check that unauthorized MADV_PAGEOUT skips large file folios
Date: Mon, 19 Oct 2026 13:12:06 -0400

A caller that neither owns nor may write a file may page out the COW
pages of a private mapping of it, but not its file pages. When the
advised range only partly covers a large file folio, the folio must be
filtered out before it is split, on separate paths for PMD- and
PTE-mapped folios.

Splitting a file folio unmaps all of it, and a partly covered folio can
only be reclaimed after a split, so a split is the failure to look for.

Check that partial MADV_PAGEOUT by such a caller leaves every mapped page
of a PMD-sized shmem folio mapped, both when a PMD maps it and when a
mapping of half of it maps it with PTEs. Since this checks for a split
rather than for reclaim, it needs no swap.

Link: https://lore.kernel.org/20261019171206.3331374-8-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/madv_cold_pageout.c |  114 +++++++++++++++
 1 file changed, 114 insertions(+)

--- a/tools/testing/selftests/mm/madv_cold_pageout.c~selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios
+++ a/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -195,6 +195,33 @@ static void pte_map_thp(struct __test_me
 	ASSERT_TRUE(flags & KPF_COMPOUND_HEAD);
 }
 
+static char *map_aligned_file(struct __test_metadata *_metadata, int fd,
+			      size_t size, int flags)
+{
+	char *mapping = reserve_aligned(_metadata, size);
+
+	ASSERT_EQ(mmap(mapping, size, PROT_READ | PROT_WRITE, flags | MAP_FIXED,
+		       fd, 0), mapping);
+
+	return mapping;
+}
+
+/* Create a PMD-sized shmem file filled with 1s. */
+static int create_shmem_file(struct __test_metadata *_metadata)
+{
+	char *shared;
+	int fd;
+
+	fd = memfd_create("madv_cold_pageout", 0);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, pmd_size), 0);
+	shared = map_aligned_file(_metadata, fd, pmd_size, MAP_SHARED);
+	memset(shared, 1, pmd_size);
+	ASSERT_EQ(munmap(shared, pmd_size), 0);
+
+	return fd;
+}
+
 static void assert_filled(struct __test_metadata *_metadata,
 			  const char *mapping, size_t size)
 {
@@ -792,6 +819,93 @@ TEST_F(madv_cold_pageout, pageout_privat
 	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
 }
 
+/*
+ * An unauthorized caller must leave a large file folio of a private mapping
+ * alone, even when the advised range only partly covers it. Splitting the
+ * folio would unmap all of it, so every page must stay mapped, which needs
+ * no swap to check. See pageout_stays_within_range about other unmapping.
+ */
+TEST_F(madv_cold_pageout, pageout_private_file_skips_large_file_folio)
+{
+	char *mapping;
+	size_t offset;
+	int fd;
+
+	if (!pmd_size)
+		SKIP(return, "PMD-sized THPs are not supported");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	fd = create_shmem_file(_metadata);
+	mapping = map_aligned_file(_metadata, fd, pmd_size, MAP_PRIVATE);
+	if (!collapse(mapping, pmd_size, check_huge_file))
+		SKIP(return, "could not allocate a PMD-sized shmem THP");
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_PAGEOUT), 0);
+	for (offset = 0; offset < pmd_size; offset += page_size) {
+		ASSERT_TRUE(page_is_present(self->pagemap_fd,
+					    mapping + offset))
+			TH_LOG("page at offset %zu was unmapped", offset);
+	}
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+	close(fd);
+}
+
+/*
+ * The same holds for a large file folio that a private mapping maps with
+ * PTEs: every page the mapping maps must stay mapped. See
+ * pageout_stays_within_range about other unmapping.
+ */
+TEST_F(madv_cold_pageout, pageout_private_file_skips_pte_mapped_file_folio)
+{
+	const size_t size = pmd_size / 2;
+	char *mapping, *shared;
+	unsigned long pfn;
+	uint64_t flags;
+	size_t offset;
+	int fd;
+
+	if (!pmd_size)
+		SKIP(return, "PMD-sized THPs are not supported");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	if (self->kpageflags_fd < 0)
+		SKIP(return, "cannot read page flags");
+	fd = create_shmem_file(_metadata);
+	shared = map_aligned_file(_metadata, fd, pmd_size, MAP_SHARED);
+	if (!collapse(shared, pmd_size, check_huge_file))
+		SKIP(return, "could not allocate a PMD-sized shmem THP");
+	ASSERT_EQ(munmap(shared, pmd_size), 0);
+
+	/* Mapping half of the folio leaves it mapped by PTEs. */
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	assert_filled(_metadata, mapping, size);
+	pfn = pagemap_get_pfn(self->pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, self->kpageflags_fd, &flags), 0);
+	if (!(flags & KPF_COMPOUND_HEAD))
+		SKIP(return, "the shmem THP was split");
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(madvise(mapping, size / 2, MADV_PAGEOUT), 0);
+	for (offset = 0; offset < size; offset += page_size) {
+		ASSERT_TRUE(page_is_present(self->pagemap_fd,
+					    mapping + offset))
+			TH_LOG("page at offset %zu was unmapped", offset);
+	}
+	assert_filled(_metadata, mapping, size);
+
+	ASSERT_EQ(munmap(mapping, size), 0);
+	close(fd);
+}
+
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch
mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch
mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch
selftests-mm-add-madv_cold-and-madv_pageout-contract-tests.patch
selftests-mm-check-madv_cold-and-madv_pageout-range-handling.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch
selftests-mm-check-madv_pageout-file-permissions.patch
selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch

