Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2825A2BB13
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188406; cv=none; b=hUfLP+HOC49VZyaG05RBFmDDGWui8uAcPyVs0IScTk14pXaw+8TDjNPG7sFyvEYy1Gz+OU26QnNvQ8wVyKb9vbC0rg8w+WK+P5nskDCoTzf6W6zYZzgiwyHsrcbrJEQDrdRI8bx4cM34ZshZbnfNTA/PJLFOgLu0ylYmz/66Pbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188406; c=relaxed/simple;
	bh=8uFo8cgJLoJMuzrF4r/VCOhVOoHyXXa2oArKKXTCduk=;
	h=Date:To:From:Subject:Message-Id; b=suh5KfGlrhAD+luuoAvLIXt48MR6Lu8wUngIF0zklA5ygCUu96wdGIC7j2+Fi6R/8HSZUesX6ZPwNxDPjFSDrOh/6zBJldFnosRZV0DD0Fo0uMNrXIHTGNriXqNk1CeWwzcSZuILHORCUWUzWbQkQWw2GV2GRcV5ytz1tnY4NXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U3DpOkTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U3DpOkTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E70C4CEEC;
	Mon, 17 Mar 2025 05:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188406;
	bh=8uFo8cgJLoJMuzrF4r/VCOhVOoHyXXa2oArKKXTCduk=;
	h=Date:To:From:Subject:From;
	b=U3DpOkTUUCcqUdoO3kGiaX1y0+wNJ5yrZBu56+PEf77JNE1XvDktz4TuQ7hBHIrD+
	 f5QVtXOhl5IBlirhNnU7ATXDAcZgCuthdawuX/6fvpVmM93TolPqqVMTocsBh0LP39
	 oalGbAPNPr4thHpygpHNB3Ov93SxYp+D/7OaIi/M=
Date: Sun, 16 Mar 2025 22:13:25 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch removed from -mm tree
Message-Id: <20250317051325.F2E70C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: implement a new DAMOS filter type for unmapped pages
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: implement a new DAMOS filter type for unmapped pages
Date: Wed, 19 Feb 2025 14:01:45 -0800

Patch series "mm/damon: introduce DAMOS filter type for unmapped pages".

User decides whether their memory will be mapped or unmapped.  It implies
that the two types of memory can have different characteristics and
management requirements.  Provide the DAMON-observaibility DAMOS-operation
capability for the different types by introducing a new DAMOS filter type
for unmapped pages.


This patch (of 2):

Implement yet another DAMOS filter type for unmapped pages on DAMON kernel
API, and add support of it from the physical address space DAMON
operations set (paddr).  Since it is for only unmapped pages, support from
the virtual address spaces DAMON operations set (vaddr) is not required.

Link: https://lkml.kernel.org/r/20250219220146.133650-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250219220146.133650-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |    2 ++
 mm/damon/paddr.c         |    3 +++
 mm/damon/sysfs-schemes.c |    1 +
 3 files changed, 6 insertions(+)

--- a/include/linux/damon.h~mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages
+++ a/include/linux/damon.h
@@ -337,6 +337,7 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  * @DAMOS_FILTER_TYPE_YOUNG:	Recently accessed pages.
  * @DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
+ * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
@@ -357,6 +358,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_MEMCG,
 	DAMOS_FILTER_TYPE_YOUNG,
 	DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+	DAMOS_FILTER_TYPE_UNMAPPED,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	NR_DAMOS_FILTER_TYPES,
--- a/mm/damon/paddr.c~mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages
+++ a/mm/damon/paddr.c
@@ -236,6 +236,9 @@ static bool damos_pa_filter_match(struct
 		matched = filter->sz_range.min <= folio_sz &&
 			  folio_sz <= filter->sz_range.max;
 		break;
+	case DAMOS_FILTER_TYPE_UNMAPPED:
+		matched = !folio_mapped(folio) || !folio_raw_mapping(folio);
+		break;
 	default:
 		break;
 	}
--- a/mm/damon/sysfs-schemes.c~mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages
+++ a/mm/damon/sysfs-schemes.c
@@ -331,6 +331,7 @@ static const char * const damon_sysfs_sc
 	"memcg",
 	"young",
 	"hugepage_size",
+	"unmapped",
 	"addr",
 	"target",
 };
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

