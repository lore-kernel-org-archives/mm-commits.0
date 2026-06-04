Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8756137F8BC
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 19:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600922; cv=none; b=i5pZ7b/b9HGruphxydHglayzSEgi23UdCMxFuIu/YK7sdBRQNFhY7sVd89aS4dBuntZkR1eBWqvtT3+9wfhRJ7LplhSsp2BvEorIp4qNPAL9M5fhMOYCfiEI1ENJLFIPWDMi/mk/iGhyuPlXH/4e0zuNnKjUzthOuDwcQP3Q18A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600922; c=relaxed/simple;
	bh=QcTK0Md+pnB7RADKTaV++Ikxo/GC5pGnCtlPiT6tT+Q=;
	h=Date:To:From:Subject:Message-Id; b=NIt28gkahNDKmfHpba8s1YxgEdA5GEQEIitHExY2/AeLnKPPaDB0Th3OwJY09CVLo5ZLVS4ZOnDQ0cT5JnFF6Jzn/bBwAqALBFejLYyQurim3qg8qUsE0QzjuWLe5ThKX4VwLNVOBPUXwp/i65UTpEOeGWvf9gkHNebcQlPHETA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fJ4W3Xpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fJ4W3Xpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B3A1F00893;
	Thu,  4 Jun 2026 19:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600921;
	bh=MC2FPHlc8VEuV3cDAwRgAfb1rhLOi+aRfh3vu74ddoI=;
	h=Date:To:From:Subject;
	b=fJ4W3Xpz4szmyRUPMlxWuevD7rt1VHah1ZHsqw9RLmL0yDWWlVVSeu7r9UWQ4Afwv
	 /bAsJnhYD9NuNAUi21Ur/GngNwv1CgkhmGzqhb3Kz84RtHYEvYV9yQ+Icbmtd43dXh
	 iUKP2+k1Dut5iq4e94ysiYWJsIy+bsBko6Ie7XPU=
Date: Thu, 04 Jun 2026 12:22:00 -0700
To: mm-commits@vger.kernel.org,osalvador@kernel.org,ljs@kernel.org,david@kernel.org,balbirs@nvidia.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch added to mm-unstable branch
Message-Id: <20260604192201.27B3A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
Date: Thu, 4 Jun 2026 05:53:06 +0000

To cover pagemap paths scanning PMD entries, add assertions to check
whether a device-private PMD entry has the correct pagemap information -
the PM_SWAP bit must be on in the pagemap entry.  Before that, we must
assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is at PMD
level and not PTE level.

Link: https://lore.kernel.org/20260604055308.1947679-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |   34 +++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2274,8 +2274,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	unsigned long npages;
 	unsigned long size;
 	unsigned long i;
+	unsigned char *m;
+	uint64_t entry;
 	void *old_ptr;
 	void *map;
+	int pagemap_fd;
 	int *ptr;
 	int ret;
 
@@ -2298,8 +2301,6 @@ TEST_F(hmm, migrate_anon_huge_fault)
 
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
-	ret = madvise(map, size, MADV_HUGEPAGE);
-	ASSERT_EQ(ret, 0);
 	old_ptr = buffer->ptr;
 	buffer->ptr = map;
 
@@ -2307,6 +2308,9 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
 
+	ret = madvise(map, size, MADV_COLLAPSE);
+	ASSERT_EQ(ret, 0);
+
 	/* Migrate memory to device. */
 	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
 	ASSERT_EQ(ret, 0);
@@ -2316,6 +2320,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
 
+	if (!hmm_is_coherent_type(variant->device_number)) {
+		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
+				      buffer, npages);
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, npages);
+
+		m = buffer->mirror;
+		for (i = 0; i < npages; ++i)
+			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
+					HMM_DMIRROR_PROT_WRITE |
+					HMM_DMIRROR_PROT_PMD);
+
+		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+		ASSERT_GE(pagemap_fd, 0);
+
+		for (i = 0; i < npages; ++i) {
+			entry = pagemap_get_entry(pagemap_fd,
+					(char *)buffer->ptr + i * self->page_size);
+
+			ASSERT_NE(entry & PM_SWAP, 0);
+			ASSERT_FALSE(PAGEMAP_PRESENT(entry));
+		}
+
+		close(pagemap_fd);
+	}
+
 	/* Fault pages back to system memory and check them. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
_

Patches currently in -mm which might be from dev.jain@arm.com are

fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch
selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch
mm-khugepaged-generalize-alloc_charge_folio.patch

