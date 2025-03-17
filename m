Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC122155757
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188537; cv=none; b=YrZptviIhwTClSHi1OB8bMd6HsgJHQUBfkz2AGdvFvBVJcHIsvrceVljs/8AS3lPXpIWC2i+vlbi34kVyoSGWTYGdSBwpiakl/rZOGgVK5C/OAnmCUtModvyIOYjwy1oRjnrhsNsXQ5zNzAscLFxsia7e9CYSaIibKd44xgzqIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188537; c=relaxed/simple;
	bh=kaUtoW5Gt0G00jCZinWUyaSmpwE26Ibhk4OipYup2B0=;
	h=Date:To:From:Subject:Message-Id; b=cuyx7dZrywzpQ0aXCcmMj8e+xAysjm36af2ZIZjUTPtsx5VajXU+C+U3XIoZpUfoBIV0bYEzu1rGS3LVyeCyME+8cGVOZq3rV9xEGvlWNO55S5oJly+EGNtKEH57cvFow36oK35pHM1ZDJ9nvoNavhy9tTTgNGlsjJ0DSvCFHK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yLFBsClO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yLFBsClO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0C2C4CEEC;
	Mon, 17 Mar 2025 05:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188537;
	bh=kaUtoW5Gt0G00jCZinWUyaSmpwE26Ibhk4OipYup2B0=;
	h=Date:To:From:Subject:From;
	b=yLFBsClOkPaLH3b2dQqA0FD7m6XzUT23OIOVESGvCIgy7yd4QZCdgFpIDNuRZPdqB
	 wyx97cB99C4Oz+RwNzhkdTL2nPlVs/zFbMAHCi1TPsBh8P3CSq4zIgKoQQHu4+LQWS
	 azVwXz43BoTzCPi+4I6KLb7ebNMZ6GoM2noi/jSk=
Date: Sun, 16 Mar 2025 22:15:37 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-ops_filters.patch removed from -mm tree
Message-Id: <20250317051537.7D0C2C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: support ops_filters
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-ops_filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: support ops_filters
Date: Tue, 4 Mar 2025 13:19:06 -0800

DAMON keeps all DAMOS filters in damos->filters.  Upcoming changes will
make it to use damos->ops_filters for all operations layer handled DAMOS
filters, though.  DAMON physical address space operations set
implementation (paddr) is not ready for the changes, since it handles only
damos->filters.  To avoid any breakage during the upcoming changes, make
paddr to handle both lists.  After the change is made, ->filters support
on paddr can be safely removed.

Link: https://lkml.kernel.org/r/20250304211913.53574-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-ops_filters
+++ a/mm/damon/paddr.c
@@ -260,6 +260,10 @@ static bool damos_pa_filter_out(struct d
 		if (damos_pa_filter_match(filter, folio))
 			return !filter->allow;
 	}
+	damos_for_each_ops_filter(filter, scheme) {
+		if (damos_pa_filter_match(filter, folio))
+			return !filter->allow;
+	}
 	return false;
 }
 
@@ -290,6 +294,12 @@ static unsigned long damon_pa_pageout(st
 			break;
 		}
 	}
+	damos_for_each_ops_filter(filter, s) {
+		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
+			install_young_filter = false;
+			break;
+		}
+	}
 	if (install_young_filter) {
 		filter = damos_new_filter(
 				DAMOS_FILTER_TYPE_YOUNG, true, false);
@@ -538,6 +548,8 @@ static bool damon_pa_scheme_has_filter(s
 
 	damos_for_each_filter(f, s)
 		return true;
+	damos_for_each_ops_filter(f, s)
+		return true;
 	return false;
 }
 
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

