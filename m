Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C1B1C3BEB
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837162; cv=none; b=foD0Nc8cNpi4YtB9X598j1ubmf2FAdHK0etlOFsf8AJ4FdU4q6mbEDZP5NoMC5rrckWDUiq48UyrMW0TJahh9goaK/3mcCV2I79Q7F9Dn6H2INlbeufX90e6dcT7r4+PHyxK3NLNtlFTCA0r04GHvQSQ7ikZ3Izp2P7PszEF16w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837162; c=relaxed/simple;
	bh=WOPK/ik/3bu8md0SXIsWxUwrXUkgWG+E+EoeuxyAWmk=;
	h=Date:To:From:Subject:Message-Id; b=hwCZWao7/bj7sTEjabb2QGpBY1KiTTmtLpofhv8yIOGcSlGf84i75wQtRGuItpwQBrgjaSnqiFx4ByZ/8GJk9WRsq31jN5F1d0tEcxdMbaxsu0hNOhjx+qtynp1V4Z0qIRjeWftZN+QnaWPSep4hSOVlhchotKKgo4FlxRF2SmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0vrl1xer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0vrl1xer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C4DC4CEDD;
	Tue, 14 Jan 2025 06:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837162;
	bh=WOPK/ik/3bu8md0SXIsWxUwrXUkgWG+E+EoeuxyAWmk=;
	h=Date:To:From:Subject:From;
	b=0vrl1xerxWgL+yvA+991BK3+S7ulwSA2roj7RB3YtrBNXicHK7gNiP+TJdCB4GoYM
	 ct6f25WFZ07hQA01C88twvlRImjDmRSyptahf9CWBzvaAO94H9oQfdXao+S/yLtxL+
	 SqKhdDgY8sBx47chDU2HONcwDAZtQFwTq9UFPaDY=
Date: Mon, 13 Jan 2025 22:46:01 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch removed from -mm tree
Message-Id: <20250114064602.35C4DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: report filter-passed bytes back for DAMOS_STAT action
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

