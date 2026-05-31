Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E201C2367CF
	for <mm-commits@vger.kernel.org>; Sun, 31 May 2026 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255556; cv=none; b=ZqaM3sGOua9Hq1ouQ4jrha6o032gQhzVNTt21Uhjxy6EZiCMekg6YfZFO1XmmrEe1Nc5qzE8IDWKQl3MPo2pz5NclE/55NYntuPkI95pnAbJ9b3FrjKaV2yZ1VuWoJjT8pVE1S2n8X/XW04Ebig0MknVvDOsxnoDj96pBfsoz5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255556; c=relaxed/simple;
	bh=kZWyZNIDAllDvhliDgpjVzs+zSmZgEK4j8n0P1/6LKM=;
	h=Date:To:From:Subject:Message-Id; b=Q2+Voljua8MW4HilXEC5K7WLb7hRWyGNJcnEF6LsuT3+C0vBJCGze0b1mc2oA8mUiNnGy+r7Bwa0LMQ9cdi3Duu2FzoVn0laW8adKwYTYI+uj3Pyjq2yCu4FjkkX4tXNEl4TyDO/7lMXZ7x9K5Ci0Mfplc0iwwWhlx+cp7oxIUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k16r+g5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k16r+g5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30CD1F00893;
	Sun, 31 May 2026 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780255554;
	bh=XLleWccVm9Bm1dqKsGv3/hGJ6GeFKKbXbm/kijaAYRY=;
	h=Date:To:From:Subject;
	b=k16r+g5YoUd4XpKRptlBiuRh67y1qQKA2yma8x6sHJmFfRCafWrFTyw5fymbVUIWd
	 KvoLXHIQtS/3dBwj2No3UZXLRdYPBm08U620gfCUT09cM231BXqkrfdJKH+FjqmE83
	 R89XhtqqcRJJRHmG6xT+hS1a8RWcNWZBP4CQtQsw=
Date: Sun, 31 May 2026 12:25:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,jannh@google.com,david@kernel.org,balbirs@nvidia.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch added to mm-new branch
Message-Id: <20260531192554.B30CD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |   29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
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
 
@@ -2318,6 +2321,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
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
fs-proc-task_mmu-do-not-warn-on-seeing-non-migration-pmd-entry.patch
selftests-mm-hmm-tests-test-pagemap-reads-of-pmd-device-private-entries.patch

