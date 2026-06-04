Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1986F37646E
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 19:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600819; cv=none; b=QBkDXXLquzZEF4nQIfy/JtXPa8jGrcpLXOT+LYUhSRZ0TXfW830rtw488uEDHc2ize8+nH6DeKv0nHXIOeK7tF++2bbDNEIUPe2Jl5YJT619pR84nU7NEQmMRUaDXRBECOy+E9uPSWWTNf4tCN8E/X1gQPkHzylZlEaQ9H+5Dnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600819; c=relaxed/simple;
	bh=M6L18dkLtxOMUyDPE87FQPelSGOFFFNaXoRBf32eaAQ=;
	h=Date:To:From:Subject:Message-Id; b=u2Ahix22O+i53vDGgjlvLpsJvxhAXFrQCr9MI4aMytXaLgQdDQXPtCJUk0c58k9WpG/74htjA561fieeyivUBqbaKfj97ZaipDXp6HZxvTQjO/npE4FgGAull6HzG3CgmbdBAnGNiadmPiQasitQVynELSibmezlGEO7LqzI76s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KwLRMIS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwLRMIS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AE51F00898;
	Thu,  4 Jun 2026 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600817;
	bh=NLXXxvCIfCiun7DkSOFG8L3QWyTWFk/0ZDiNcJve4a8=;
	h=Date:To:From:Subject;
	b=KwLRMIS2RzZ81sR353u+a9eLjm5U2By+n88hxZ2lPVwZku0Vo7xyQgZpqgOacA4+O
	 Qz67RwbaKR8extIw182KIqwIk/VLR28PVgfZyaLp5FFBQ4+qBWTAzikRJfuU7un9A8
	 BGgqE+DwOAeCeWxuDqJeJTtbyZIyKqmmdOXmKq/U=
Date: Thu, 04 Jun 2026 12:20:17 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch removed from -mm tree
Message-Id: <20260604192017.B5AE51F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
has been removed from the -mm tree.  Its filename was
     selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
Date: Sat, 30 May 2026 08:54:12 +0000

To cover pagemap paths scanning PMD entries, add assertions to check
whether a device-private PMD entry has the correct pagemap information -
the PM_SWAP bit must be on in the pagemap entry.  Before that, we must
assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is at PMD
level and not PTE level.

Link: https://lore.kernel.org/20260530085413.1270139-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |   29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)

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
 
@@ -2316,6 +2319,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
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
+			ASSERT_EQ(entry & PM_PRESENT, 0);
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

