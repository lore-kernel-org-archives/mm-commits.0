Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDECD27E
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 00:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754543; cv=none; b=aaqRyt/SGWz1oDRn6cK9izK9G5cOSaS7oKIYEFKwlXeDB6ZrbuQAixQrp05lvaHG8x2VOuq6PdRB/YrdT8yCoe8wWySp/Dg6h6fgwZ67+VWfzlhfZNkSWs3MOsmGN79qz9ezokqkDUycvZ0mqrI5QkSWMkz/AY7K3tchU2jcGPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754543; c=relaxed/simple;
	bh=9WJKJgUS9XNMSXivSTCm+iSop13ZQVA5oFQGOMGX1es=;
	h=Date:To:From:Subject:Message-Id; b=OZekP2xDuiyjZo66LEYN4Qeex1lW5+W10ibifTaY/KM2R8dxffYggMKhuzdFNW59RZVTER2UPAtEJ0SqSNGQ+jAApZkAbd3F2qfoHHwOJJGOcHnB8N8s0ozaEScsCPFbl/6wIhai3moh6af4s4uQKl35kskB0sxQW63qzW/AXaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yLZLiuT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yLZLiuT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650FEC4CECC;
	Thu, 28 Nov 2024 00:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732754543;
	bh=9WJKJgUS9XNMSXivSTCm+iSop13ZQVA5oFQGOMGX1es=;
	h=Date:To:From:Subject:From;
	b=yLZLiuT99PuJoHDJ4I/BNncGXka6Xui4q6sFl1G8BBV6X0FIoj+N2Db/C5J1HYA1c
	 jOywM5IPV/Lc+O1pZnih/+3SBNmHGeKaC7xIQwcsrp6impEwLyiGVB+0/PsQLDBrOG
	 aKlb0810B6NaVmG7RqujnYzLs3Asdkv936WGiZKo=
Date: Wed, 27 Nov 2024 16:42:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ritesh.list@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch added to mm-unstable branch
Message-Id: <20241128004223.650FEC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: remove unused argument vma from migrate_misplaced_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2002,7 +2002,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
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

mm-migrate-removed-unused-argument-vma-from-migrate_misplaced_folio.patch

