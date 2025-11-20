Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8168B347BB4
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675095; cv=none; b=Nbw4CT/Yp9PV6Y7RVSUS3eIrc8TLQSmQp30ysj2Qn2qw2OzMoTPjNLFPf140XjArQGrkI6qygZQdP52NHjeQBrPVGRVEWA/G/+ZOF8kgbQbohjhp2DkeIlO+iSETZ28nWg1a0T6lCC9qbuIATxIXAmIbSKYGP923hhOlDF0KGNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675095; c=relaxed/simple;
	bh=czG+nx1GfjHXhjk28m6N/VoAacYQ93eYylzSsmLNUoE=;
	h=Date:To:From:Subject:Message-Id; b=SIbXkUoqwKcxcpVG/fqBNw1Swjwk8di2b6+F+Bzyu1xK04jn1zIFoPw7WyzRnIgrdPweNdfO24QFLxyWkxK/D7Ua1nNVcMamMPeNtNIed5kw92taW26ObmIiqpR7EOvODUtXBBJ01WbJ7reEdHybeMzHKn5gGB4hw/xwiqCOF0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nqLRHnyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nqLRHnyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F3BC4CEF1;
	Thu, 20 Nov 2025 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675095;
	bh=czG+nx1GfjHXhjk28m6N/VoAacYQ93eYylzSsmLNUoE=;
	h=Date:To:From:Subject:From;
	b=nqLRHnyRD5atXk+TlD3ljE2sm/gL9J4GziBrQk0Py2+3z2+eQU5PdNPgM98UHHvvW
	 ZeGDDL0bw6jj/d8lZXmUccsEFDmFvvl/56VqSGG1LHpuXNjalNN4iFSNd0+jqoifK/
	 oY2MvaGdyq9mmDwaoef4rSkuzDNrirTuAJYVPooo=
Date: Thu, 20 Nov 2025 13:44:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,pfalcato@suse.de,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,avagin@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-selftests-mm-add-madv_collapse-test-case.patch removed from -mm tree
Message-Id: <20251120214455.56F3BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/selftests/mm: add MADV_COLLAPSE test case
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-mm-add-madv_collapse-test-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests/mm: add MADV_COLLAPSE test case
Date: Tue, 18 Nov 2025 10:17:50 +0000

To ensure the retract_page_tables() logic functions correctly with the
introduction of VM_MAYBE_GUARD, add a test to assert that madvise collapse
fails when guard regions are established in the collapsed range in all
cases.

Unfortunately we cannot differentiate between e.g. 
CONFIG_READ_ONLY_THP_FOR_FS not being set vs.  a file-backed VMA having
collapse correctly disallowed, so in each instance we will get an assert
pass here.

We add an additional check to see whether guard regions are preserved
across collapse in case of a bug causing the collapse to succeed, which
will give us more data to debug with should this occur in future.

Link: https://lkml.kernel.org/r/0748beeb864525b8ddfa51adad7128dd32eb3ac4.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |   65 +++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/tools/testing/selftests/mm/guard-regions.c~tools-testing-selftests-mm-add-madv_collapse-test-case
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -2138,4 +2138,69 @@ TEST_F(guard_regions, pagemap_scan)
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
+TEST_F(guard_regions, collapse)
+{
+	const unsigned long page_size = self->page_size;
+	const unsigned long size = 2 * HPAGE_SIZE;
+	const unsigned long num_pages = size / page_size;
+	char *ptr;
+	int i;
+
+	/* Need file to be correct size for tests for non-anon. */
+	if (variant->backing != ANON_BACKED)
+		ASSERT_EQ(ftruncate(self->fd, size), 0);
+
+	/*
+	 * We must close and re-open local-file backed as read-only for
+	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
+	 */
+	if (variant->backing == LOCAL_FILE_BACKED) {
+		ASSERT_EQ(close(self->fd), 0);
+
+		self->fd = open(self->path, O_RDONLY);
+		ASSERT_GE(self->fd, 0);
+	}
+
+	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* Prevent being faulted-in as huge. */
+	ASSERT_EQ(madvise(ptr, size, MADV_NOHUGEPAGE), 0);
+	/* Fault in. */
+	ASSERT_EQ(madvise(ptr, size, MADV_POPULATE_READ), 0);
+
+	/* Install guard regions in ever other page. */
+	for (i = 0; i < num_pages; i += 2) {
+		char *ptr_page = &ptr[i * page_size];
+
+		ASSERT_EQ(madvise(ptr_page, page_size, MADV_GUARD_INSTALL), 0);
+		/* Accesses should now fail. */
+		ASSERT_FALSE(try_read_buf(ptr_page));
+	}
+
+	/* Allow huge page throughout region. */
+	ASSERT_EQ(madvise(ptr, size, MADV_HUGEPAGE), 0);
+
+	/*
+	 * Now collapse the entire region. This should fail in all cases.
+	 *
+	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
+	 * not set for the local file case, but we can't differentiate whether
+	 * this occurred or if the collapse was rightly rejected.
+	 */
+	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
+
+	/*
+	 * If we introduce a bug that causes the collapse to succeed, gather
+	 * data on whether guard regions are at least preserved. The test will
+	 * fail at this point in any case.
+	 */
+	for (i = 0; i < num_pages; i += 2) {
+		char *ptr_page = &ptr[i * page_size];
+
+		/* Accesses should still fail. */
+		ASSERT_FALSE(try_read_buf(ptr_page));
+	}
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch

