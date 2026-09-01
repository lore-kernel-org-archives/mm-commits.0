Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A0486E4D
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283087; cv=none; b=DkeuCyEYBxmDxiR8O2XeMCb0KAww2rgClPyEnE0NIiKckmCysuxefJ6Px9x75K+Dbrkkg1w0RBr6OXJqdCPwKds0BHN9o4sUaOqINA8GDrsOJbEfM2gldH49C6siA+rdiF+v9eYUMuFD12OxXhPU+31TaFC1EcVsdQa+0S/Oevg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283087; c=relaxed/simple;
	bh=OJvq6kcVHl57FZmC5QIncD31S5wcoNLPDatlmWAlU+8=;
	h=Date:To:From:Subject:Message-Id; b=ihuWa975JTwgFpH363VHtDPG+NvoqbQGqXNERBLvgWOUK3VK88eDWVXY4IBu5tghjZ5g1r+yWHESNoMWBa/wByXdeTMF6Q/Ntdtw3tOgSNkwHcCgxW3U2EuxwXyLUpx6j28LnvshuFeTCsaGnMVd1DBI2/GqKLTUl5YkYdA+XMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rm0oKyI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rm0oKyI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112E01F00A3A;
	Tue,  1 Sep 2026 17:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283086;
	bh=SvQZbAgTCywqlySr/EAF1fRkyiny1xgxq13ofTE9BFA=;
	h=Date:To:From:Subject;
	b=Rm0oKyI9ro3gz27XlQdgYzeSCWnOEWO9peBRr8YQVhbDN0Esy89mGz1QrWIvMRXr7
	 pD0Iunxby1INMO1QIq0l+sdBMedRhZB2rd59Z9Tu9iTGZ4XBoMEpYCL4fq9KCfxExL
	 oNjfJQ0yxeutmI34X02rFJbbkGKXc07uVUWcG5bw=
Date: Tue, 01 Sep 2026 10:18:05 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-probe-preps.patch added to mm-new branch
Message-Id: <20260901171806.112E01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document probe preps
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-probe-preps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-probe-preps.patch

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
Subject: Docs/mm/damon/design: document probe preps
Date: Tue, 1 Sep 2026 06:25:02 -0700

Update DAMON design document for the newly added DAMON probe preps
feature.

Link: https://lore.kernel.org/20260901132506.99243-16-sj@kernel.org
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

 Documentation/mm/damon/design.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-probe-preps
+++ a/Documentation/mm/damon/design.rst
@@ -309,6 +309,13 @@ Users can therefore know how much of a g
 attribute by reading the per-region per-probe probe hits counter after each
 aggregation interval.
 
+Users can optionally register probing preparation actions per probe.  If such
+actions are registered, DAMON applies the actions to each region's sampling
+memory before starting the next sampling interval.  Currently only one action,
+``set_pgidle`` is supported.  The action marks the page for the probing target
+memory as access-idle.  This can be useful to be used together with
+``pgidle_unset`` probe filter.
+
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
 understanding of statistics.
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

