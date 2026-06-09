Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B62F9C37
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968180; cv=none; b=D1Wa+ZvAoybGV5+7FuuaXKgHWaPnp/fBzwMDJfq1tqXJMEssTnpYhD1twKLOfGUmTwTTJ8D0ydAORmCNmc8mNI0QOj5lO5icz5BbDVyF3Kdbvyzi1K0ub5MSJCorCkjSFgwhjGBiX8QrTEZGyQgawHDhsS/jD/PkftrAORR9ArE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968180; c=relaxed/simple;
	bh=CQrQ0WImHSuyaRRa0Q9TLRCCmTO3I0xO8+MqTWl555A=;
	h=Date:To:From:Subject:Message-Id; b=F4oToVssp9Sxhd8UQMRqLPvTwQP7TQuysAMa8Jp3a71Ri95DOTH3icvN5dQ10v6PqxnfVHTME9cBVJSuBIyJnGkD9AjMmh4A7Ft0f2EvvOKBfPAgO59ZBflRUkuE+v0uvQ6Z+KDSQ+8Ug80DHuiFWVnE76vuMrDeENNYCXTkaLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bsUnedO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bsUnedO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590401F00893;
	Tue,  9 Jun 2026 01:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968179;
	bh=zQoVeAGJaruaEXKC6caNP9mvIy986SQdnTicPps+KV0=;
	h=Date:To:From:Subject;
	b=bsUnedO7BK6wEgSZuORxAUpBTqXTf8tjyaaG3HuCEEN7S7+pAzbw39Fe6AK8b2gpO
	 zwjw+N2S6dS4OE8BOjGDAdbEAU4QJyixtW+B0wJcGqtcLI6eJmn7kc1VLv0Za033d3
	 o068II9oZoTnvI3GcoxzryOBZZBHE/FzKZYkNmXk=
Date: Mon, 08 Jun 2026 18:22:58 -0700
To: mm-commits@vger.kernel.org,osalvador@kernel.org,ljs@kernel.org,david@kernel.org,balbirs@nvidia.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch removed from -mm tree
Message-Id: <20260609012259.590401F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
has been removed from the -mm tree.  Its filename was
     selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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

mm-khugepaged-generalize-alloc_charge_folio.patch

