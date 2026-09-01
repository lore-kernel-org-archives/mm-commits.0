Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC1848167D
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283059; cv=none; b=XlI9Hwdp1saiQwxCz9Oy31k11Z82jvXRmcXVIEBFZFyIrzFRObdObpScWl9q4AS9wUsX2tGdJQzxabQUJKWc1edMqr6mW6crTia1pIEDdqVLbu1h2zN+HZVKjckWUepHIiE7nJPCVrDJgL7dNSPJhHrQaWZyxZSonrZ6iVeX1xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283059; c=relaxed/simple;
	bh=+XtL0Ezt0y1WW5xpczLH2plonPNfhLE5AjVDacHcNl8=;
	h=Date:To:From:Subject:Message-Id; b=Q+CxaLHEiEdwiz23JFt/WCeAKsf+0ToBIVXfvNhVz54llwKBMOJHceFdLx66BMBaqyzsOEI9ZLvfCMSR30Hxkuf3oyqyvbxlB+07XXHKpJ2BUd1ov4loTDYbSXCXuvKAH8dS8RQ92U7/yz1/MsHryfkEa8bTaH3wNhTCnEvOxYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TblCMAoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TblCMAoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CD61F00A3A;
	Tue,  1 Sep 2026 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283058;
	bh=kiOMAlhaTDy6/cAvkPpjpex0Ufb+Iz4FdHqA2TayotI=;
	h=Date:To:From:Subject;
	b=TblCMAoyGdthNPKD+GEPUMgJH79TNGZhzVGKYYxIlfYmhuyWEtu7Du0jEOJEdFH2A
	 VZoXNZwN/Gi9l5ZR8Re8//zoaNG1JY0/wztqmfHLD62tgmmO/C4/sHqKh2iNzamWig
	 ZVASlyCuIBZ3xkeBwihihrQjFfr1je7P3FZ/LinM=
Date: Tue, 01 Sep 2026 10:17:37 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch added to mm-new branch
Message-Id: <20260901171738.20CD61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support PGIDLE_UNSET probe filter type
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: support PGIDLE_UNSET probe filter type
Date: Tue, 1 Sep 2026 06:24:49 -0700

Implement support of DAMON_FILTER_TYPE_PGIDLE_UNSET in the physical
address space DAMON operations set.  It reuses damon_folio_young(), which
was being used for access monitoring.

Link: https://lore.kernel.org/20260901132506.99243-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-pgidle_unset-probe-filter-type
+++ a/mm/damon/paddr.c
@@ -132,6 +132,12 @@ static bool damon_pa_filter_match(struct
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio);
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch

