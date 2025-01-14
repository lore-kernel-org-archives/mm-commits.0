Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397861C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836913; cv=none; b=JgDLkTds2FK7uSyM2RMXfXV5LwpTu7kk1AWjRXkXBV+Ewhrxhqq1jFV6NY2i4CRD3ZpiwXBiIVm0Ca1+1Kb2VZd7A6A6BuDViMAeERvGKtaWPS0qILwczlXiyr2SIOTKlqBZ7sbg9oM+HpchZx46wz6QFgjXMd72eHGOGQI956M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836913; c=relaxed/simple;
	bh=tfs00p9fbr1tHTthdBWLp4EOQ/P1DraHPkVcQMSYdl0=;
	h=Date:To:From:Subject:Message-Id; b=bmBEma1xBod2mxK4j6RIVQYn+tIxYjjtl9bxY9DK7YQf4MtnX4PTQTtCZIsHIwAF3jioLrsNCqR6ic/vZgmhFl7m6nICIVEB3sNVx7FcHQ87VkdH9icYxILYONBbCc6D5x2r8CiBesCGJbtYy1lP2VxCr9OFxJC2lYE227/+RH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g6Ks6Aig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g6Ks6Aig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF6AC4CEDD;
	Tue, 14 Jan 2025 06:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836912;
	bh=tfs00p9fbr1tHTthdBWLp4EOQ/P1DraHPkVcQMSYdl0=;
	h=Date:To:From:Subject:From;
	b=g6Ks6Aig5A0TssxLZ46wVnHqAKs4C6JgETQaiWZrXQZ09OLPKFE9bebmtuoeNCK3Y
	 ZmNvWGx3n4/U61fLGvTlxrOjno+6LgIOxrD2PiQ4Y77thkOavquh8TN1qKaWZGZmrM
	 ptavrdMtukwegM/bv09V1qNSr8PuVihKv3PjbHso=
Date: Mon, 13 Jan 2025 22:41:51 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ritesh.list@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch removed from -mm tree
Message-Id: <20250114064152.6BF6AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: remove unused argument vma from migrate_misplaced_folio()
has been removed from the -mm tree.  Its filename was
     mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm: migrate: remove unused argument vma from migrate_misplaced_folio()
Date: Tue, 26 Nov 2024 09:56:54 -0600

Commit ee86814b0562 ("mm/migrate: move NUMA hinting fault folio isolation
+ checks under PTL") removed the code that had used the vma argument in
migrate_misplaced_folio.

Since the vma argument was no longer used in migrate_misplaced_folio, this
patch removes it.

Link: https://lkml.kernel.org/r/20241126155655.466186-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    6 ++----
 mm/huge_memory.c        |    2 +-
 mm/memory.c             |    2 +-
 mm/migrate.c            |    3 +--
 4 files changed, 5 insertions(+), 8 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio
+++ a/include/linux/migrate.h
@@ -144,16 +144,14 @@ const struct movable_operations *page_mo
 #ifdef CONFIG_NUMA_BALANCING
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
-int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
-			   int node);
+int migrate_misplaced_folio(struct folio *folio, int node);
 #else
 static inline int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
-static inline int migrate_misplaced_folio(struct folio *folio,
-					 struct vm_area_struct *vma, int node)
+static inline int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
--- a/mm/huge_memory.c~mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio
+++ a/mm/huge_memory.c
@@ -2003,7 +2003,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	spin_unlock(vmf->ptl);
 	writable = false;
 
-	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
+	if (!migrate_misplaced_folio(folio, target_nid)) {
 		flags |= TNF_MIGRATED;
 		nid = target_nid;
 		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
--- a/mm/memory.c~mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio
+++ a/mm/memory.c
@@ -5625,7 +5625,7 @@ static vm_fault_t do_numa_page(struct vm
 	ignore_writable = true;
 
 	/* Migrate to the requested node */
-	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
+	if (!migrate_misplaced_folio(folio, target_nid)) {
 		nid = target_nid;
 		flags |= TNF_MIGRATED;
 		task_numa_fault(last_cpupid, nid, nr_pages, flags);
--- a/mm/migrate.c~mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio
+++ a/mm/migrate.c
@@ -2683,8 +2683,7 @@ int migrate_misplaced_folio_prepare(stru
  * elevated reference count on the folio. This function will un-isolate the
  * folio, dereferencing the folio before returning.
  */
-int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
-			    int node)
+int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
 	int nr_remaining;
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


