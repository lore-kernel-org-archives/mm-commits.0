Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F53C139
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215472; cv=none; b=nx5g4ojMgfZh/X6IBUJ4wcWK+Ck9RLZpqA7HsmED5ATtp0XRVWvoGL9aRjVLhwa7CaZCI/q2qqCsHPiJB+fihqWvvOcDlA7JI/GDEnJggQszWb0qxxBVxfpNcvaHzxvqVsp6xfcMcxJGFKMFcnzZPIkp9cZlGD+zm0kIoOz/cOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215472; c=relaxed/simple;
	bh=juCeN5NpK9XO5O1zSu1McU6dxRl/Rhv4nOQC5nN6UE4=;
	h=Date:To:From:Subject:Message-Id; b=OTKMoLf54ZpY1gPUKm2rH+j5fzuoXfnM+9IxGNycksmJ36nizNnqukIH+LrHWHqHL/tWKh4tE5qW/v4XAsbugtD+LImDLO3CjtKQEJT1Dl+ZLjdauabCqVBKN0Htq+YWNBmeFLhTpZmQEEwfQmsUeEtm0lI7/xKeUHE4tBx81GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2YqKLuRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2YqKLuRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB497C4CEDD;
	Tue,  7 Jan 2025 02:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215471;
	bh=juCeN5NpK9XO5O1zSu1McU6dxRl/Rhv4nOQC5nN6UE4=;
	h=Date:To:From:Subject:From;
	b=2YqKLuRWRj7C/uayt1MhnGSPoci4ZTsL50wA31xgR2E1AGueAa9Ar4SemEtHvIvEm
	 R9UdyKU5Lx1Dg8sb1djFFyNI/TXbEhvyhS3z4uaB29T7T0sNbDMriT2KYGoCbnt9jg
	 I2j4DbqoPpZ3Sdy644fLgIB03YDSlLx6v6HK3ft4=
Date: Mon, 06 Jan 2025 18:04:31 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch added to mm-unstable branch
Message-Id: <20250107020431.AB497C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: report filter-passed bytes back for DAMOS_STAT action
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: report filter-passed bytes back for DAMOS_STAT action
Date: Mon, 6 Jan 2025 11:33:51 -0800

DAMOS_STAT action handling of paddr DAMON operations set implementation is
simply ignoring the region-internal DAMOS filters, and therefore not
reporting back the filter-passed bytes.  Apply the filters and report back
the information.

Before this change, DAMOS_STAT was doing nothing for DAMOS filters.  Hence
users might see some performance regressions.  Such regression for use
cases where no region-internal DAMOS filter is added to the scheme will be
negligible, since this change avoids unnecessary filtering works if no
such filter is installed.

For old users who are using DAMOS_STAT with the types of filters, the
regression could be visible depending on the size of the region and the
overhead of the installed DAMOS filters.  But, because the filters were
completely ignored before in the use case, no real users would really
depend on such use case that makes no point.

Link: https://lkml.kernel.org/r/20250106193401.109161-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action
+++ a/mm/damon/paddr.c
@@ -485,6 +485,39 @@ put_folio:
 	return applied * PAGE_SIZE;
 }
 
+static bool damon_pa_scheme_has_filter(struct damos *s)
+{
+	struct damos_filter *f;
+
+	damos_for_each_filter(f, s)
+		return true;
+	return false;
+}
+
+static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	unsigned long addr;
+	LIST_HEAD(folio_list);
+
+	if (!damon_pa_scheme_has_filter(s))
+		return 0;
+
+	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
+		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
+
+		if (!folio)
+			continue;
+
+		if (damos_pa_filter_out(s, folio))
+			goto put_folio;
+		else
+			*sz_filter_passed += folio_size(folio);
+put_folio:
+		folio_put(folio);
+	}
+	return 0;
+}
 
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
@@ -501,7 +534,7 @@ static unsigned long damon_pa_apply_sche
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		break;
+		return damon_pa_stat(r, scheme, sz_filter_passed);
 	default:
 		/* DAMOS actions that not yet supported by 'paddr'. */
 		break;
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch

