Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C885134A8
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 22:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751667116; cv=none; b=VU1ee2Wli6YWrv6z6Q9r4yTNwaor23gamaIchKsJGlesmahSp1ZMdE9pPJZkpBlaY/Klbz2gkaHd0oM0tcRUkklCz1N75NqponSFjMnniL0w5TYJB9cQ+8MDdUf0v62QZvONGzwKzgpmF+oeEJVZ5e/t3p1FR1JDuGvfRvS/Pso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751667116; c=relaxed/simple;
	bh=ZwBMUPrFp8Y+j328G488tsv3pgVHb9H6/inz3dYbt2k=;
	h=Date:To:From:Subject:Message-Id; b=MYo+gR+62oteD2zr++dOvHdTIhc0HPzHbSndErAwSWm7MqWzTiIUXrq1HHNpbobXo8S4aeJGHy/p+lG36jy/14Ov61I35FBRRPl3kEu3xIwWAbIVZpsnLczT90pFxnBVaAxUsioYI+96VZsmLjRZzKR75+ZpXAtIsK2bMz6kED4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wmapJKgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wmapJKgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B021AC4CEE3;
	Fri,  4 Jul 2025 22:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751667115;
	bh=ZwBMUPrFp8Y+j328G488tsv3pgVHb9H6/inz3dYbt2k=;
	h=Date:To:From:Subject:From;
	b=wmapJKgHGq/rZYlMBiW6b2gJGTYCrG3lwItOLpTa4S1pnxju3pOlzRUNl7RrpIFMx
	 3X/rOU6QbvKRoQZTx/S/Euf4yFTef6kNK3Uz/DmSpfRB8aPlWM093vpXCJsc+Ago5z
	 EIYkOh4tGfHlHpDfik885FM5S8esShNQ3v8ETY64=
Date: Fri, 04 Jul 2025 15:11:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,osalvador@suse.de,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch added to mm-new branch
Message-Id: <20250704221155.B021AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: reduce race probability between migration and khugepaged
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dev Jain <dev.jain@arm.com>
Subject: khugepaged: reduce race probability between migration and khugepaged
Date: Fri, 4 Jul 2025 09:34:17 +0530

Suppose a folio is under migration, and khugepaged is also trying to
collapse it.  collapse_pte_mapped_thp() will retrieve the folio from the
page cache via filemap_lock_folio(), thus taking a reference on the folio
and sleeping on the folio lock, since the lock is held by the migration
path.  Migration will then fail in __folio_migrate_mapping ->
folio_ref_freeze.  Reduce the probability of such a race happening
(leading to migration failure) by bailing out if we detect a PMD is marked
with a migration entry.

This fixes the migration-shared-anon-thp testcase failure on Apple M3.

Note that, this is not a "fix" since it only reduces the chance of
interference of khugepaged with migration, wherein both the kernel
functionalities are deemed "best-effort".

Link: https://lkml.kernel.org/r/20250704040417.63826-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~khugepaged-reduce-race-probability-between-migration-and-khugepaged
+++ a/mm/khugepaged.c
@@ -977,6 +977,14 @@ static inline int check_pmd_state(pmd_t
 
 	if (pmd_none(pmde))
 		return SCAN_PMD_NONE;
+
+	/*
+	 * The folio may be under migration when khugepaged is trying to
+	 * collapse it. Migration success or failure will eventually end
+	 * up with a present PMD mapping a folio again.
+	 */
+	if (is_pmd_migration_entry(pmde))
+		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
 		return SCAN_PMD_NULL;
 	if (pmd_trans_huge(pmde))
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch
maple-tree-use-goto-label-to-simplify-code.patch
maple-tree-add-some-comments.patch
khugepaged-generalize-alloc_charge_folio.patch
khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch

