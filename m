Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B8E1C32
	for <mm-commits@vger.kernel.org>; Sat, 22 Jun 2024 02:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719022762; cv=none; b=m3WH1Jr7Vy1GkpuD9bkXDWfcszTtMcj1+TlUcZLskYZZ/gWSsKyH3eNBmAvUuKF3InNapMdoLfgB2MG7zYZUMGn9AWXjS+cXCEgcR9owUTwT8RVo8E56IiseecuPL86SeoZfgRstJELcS/scepMySoVpbUzY//IXc3fRLxlIE90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719022762; c=relaxed/simple;
	bh=LUuOotLQEL+pxIdLxohz2nQO2r+jUSiN5h1ULHOnKFA=;
	h=Date:To:From:Subject:Message-Id; b=msnsWAZmNiljpdcmDvhN10Ze9lG16DCg0QIxNg/4+erZtSh7pwZ69X9MLwOPzLubD7Zitst0UKbznj7lHausgMAmi4W6R36t+pnTqeFXvxtFRXdp9+uNGBaAviZONirHrkIACMQI0btMElwmfBHLx2HdcgNS3ibID1zwFoX2pQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f+JVNPL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f+JVNPL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3A7C2BBFC;
	Sat, 22 Jun 2024 02:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719022761;
	bh=LUuOotLQEL+pxIdLxohz2nQO2r+jUSiN5h1ULHOnKFA=;
	h=Date:To:From:Subject:From;
	b=f+JVNPL3ae7JnDvjYFePfdK2ZBWXScJdxkCMtBCXceucvvZTfdPKN70oxbQ9EgzZQ
	 /fPZgRXS7FfHIKU49fzxMxhbv5aNBSgY8TvLSRS0ENJPw/RQXxjfrbPM9xtYtYRCes
	 ThfCZ+DqWviCp8mHGk33vP4WfYjFWoC2n6drAwpk=
Date: Fri, 21 Jun 2024 19:19:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,donettom@linux.ibm.com,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch added to mm-unstable branch
Message-Id: <20240622021921.7A3A7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: make migrate_misplaced_folio() return 0 on success
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: make migrate_misplaced_folio() return 0 on success
Date: Thu, 20 Jun 2024 23:29:34 +0200

Patch series "mm/migrate: move NUMA hinting fault folio isolation + checks
under PTL".


Let's just return 0 on success, which is less confusing.

...  especially because we got it wrong in the migrate.h stub where we
have "return -EAGAIN; /* can't migrate now */" instead of "return 0;". 
Likely this wrong return value doesn't currently matter, but it certainly
adds confusion.

We'll add migrate_misplaced_folio_prepare() next, where we want to use the
same "return 0 on success" approach, so let's just clean this up.

Link: https://lkml.kernel.org/r/20240620212935.656243-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240620212935.656243-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++---
 mm/memory.c      |    2 +-
 mm/migrate.c     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-make-migrate_misplaced_folio-return-0-on-success
+++ a/mm/huge_memory.c
@@ -1652,7 +1652,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	int nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid = (-1 & LAST_CPUPID_MASK);
-	bool migrated = false, writable = false;
+	bool writable = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -1696,8 +1696,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	spin_unlock(vmf->ptl);
 	writable = false;
 
-	migrated = migrate_misplaced_folio(folio, vma, target_nid);
-	if (migrated) {
+	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATED;
 		nid = target_nid;
 	} else {
--- a/mm/memory.c~mm-migrate-make-migrate_misplaced_folio-return-0-on-success
+++ a/mm/memory.c
@@ -5354,7 +5354,7 @@ static vm_fault_t do_numa_page(struct vm
 	ignore_writable = true;
 
 	/* Migrate to the requested node */
-	if (migrate_misplaced_folio(folio, vma, target_nid)) {
+	if (!migrate_misplaced_folio(folio, vma, target_nid)) {
 		nid = target_nid;
 		flags |= TNF_MIGRATED;
 	} else {
--- a/mm/migrate.c~mm-migrate-make-migrate_misplaced_folio-return-0-on-success
+++ a/mm/migrate.c
@@ -2629,11 +2629,11 @@ int migrate_misplaced_folio(struct folio
 					    nr_succeeded);
 	}
 	BUG_ON(!list_empty(&migratepages));
-	return isolated;
+	return isolated ? 0 : -EAGAIN;
 
 out:
 	folio_put(folio);
-	return 0;
+	return -EAGAIN;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

