Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB4640EB80
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525525; cv=none; b=Wb15LWCIXhA44iXM9IGX+rjnx91t8HyiG5hE1aPQS7648fuSetVnvKTbpWhrBpOTHSONUamPPc0VaCmZ1DwLkBZiNXyDdThFTMz0X8xyN47MKGKW7jEaGeN+TRUMFdA781PwrYRe6CPUu3CVUku8ao8618K38JGbiiX8wjAyDfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525525; c=relaxed/simple;
	bh=ru7J0R9mbpIoDVub5f7xM2JWddju7VHN3ZHoP9gnR9M=;
	h=Date:To:From:Subject:Message-Id; b=Bg8oqZaCbnWqoinZBPXyprhKKqnnup/KbGEMsi+d+TF8nHcwh0HPvDWwDGN/IjM2svTldMRbXWdvEiHaiJFtpe5bpayo9tStyGKEIaV5/9QQOxckUpzTDjavF81qgV8opDI8tEks3NEgE/hmB+kBlRJis7jT9j1qZHHaIKovrHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWdbZfwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWdbZfwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F501F000FF;
	Fri,  9 Oct 2026 05:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525524;
	bh=5NNNwHtvsbF4HJHhO2YX7vjO9He7lkCVzOKM11dAAXE=;
	h=Date:To:From:Subject;
	b=uWdbZfwdMrcDPrwtkqfBTCdEcMxgPHY6BITpiTHqtYGLi2lwLY8on0B9pUOTtt/7v
	 99LmF2+KqoLacv3SICrDYSll7xDXZC4oUW/lLeCTjYWZWsBRek9XLFek58ZvB/GzJV
	 L6A9VdORr/jsSZN5NxPAtTwNaouiO7faXMQdf3c8=
Date: Thu, 08 Oct 2026 22:58:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-damon_filter_type_pgidle_set.patch removed from -mm tree
Message-Id: <20261009055844.65F501F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: support DAMON_FILTER_TYPE_PGIDLE_SET
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-damon_filter_type_pgidle_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/paddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Thu, 10 Sep 2026 07:22:29 -0700

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the physical address
space DAMON operation set (paddr).

Link: https://lore.kernel.org/20260910142234.171562-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/paddr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-damon_filter_type_pgidle_set
+++ a/mm/damon/paddr.c
@@ -151,6 +151,12 @@ static bool damon_pa_filter_match(struct
 		else
 			matched = damon_folio_young(folio);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio) == false;
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

