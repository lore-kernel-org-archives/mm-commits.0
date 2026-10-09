Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B8540F726
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525526; cv=none; b=FiBEkGpjfd9GKerPjygySSW17NkaSBqU/+iX6LFMq4nrrooZnOKXIlPQ6VNlNxcjH3GJzqOzbjLk2Bjn9ZJPi8gSURMIju5u2kToFChTk97LrRBfT7mifY6VLDLiFB8jTghIPgEmRF8U5Hr14vjJeqOldc8htwdTmYqzyOb4i60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525526; c=relaxed/simple;
	bh=LShfvDb5Dg5btd6g6XBU8aw5LO8eIcPzFntMBLHae5k=;
	h=Date:To:From:Subject:Message-Id; b=cL5a0Sa7x3OnX4o76Evm62xNPEqLOONlBdvMKLmUUGUSezCZL0RS/1EcXRzIzBWtaZrJD9kwu4PJNgcx6ytLHp07AtxMmAHntqkpaoZsJ5qsILhY/OknX44qTvqkYqTN5O5B7wXEkvTH2S3V5EYhBcsPflXCais3iZ9MYs+EtwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=goUG7Rtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="goUG7Rtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD9D1F00893;
	Fri,  9 Oct 2026 05:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525525;
	bh=Cw8AQygJE9686uXYo114lFNAaLu4AGJKMnk8oeMQvJ4=;
	h=Date:To:From:Subject;
	b=goUG7RtltHikmPg5kzaf3LxXKPen80UFPdrRs67igLV0AFAa1Zums1a4q29bCiy8q
	 0kdQhHfV0IH6Z4uWzvN1h4mUPn0s9MsvlYub1mnhDioHewvh4SG+tu9EI9l+s/f7fx
	 ELa9WnAGE9rqkj9Sy7dDMQeTdKujH/R3Vl57w11M=
Date: Thu, 08 Oct 2026 22:58:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch removed from -mm tree
Message-Id: <20261009055845.8DD9D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: support DAMON_FILTER_TYPE_PGIDLE_SET
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Thu, 10 Sep 2026 07:22:30 -0700

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the virtual address
space DAMON operation set (vaddr).

Link: https://lore.kernel.org/20260910142234.171562-4-sj@kernel.org
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

 mm/damon/vaddr.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-support-damon_filter_type_pgidle_set
+++ a/mm/damon/vaddr.c
@@ -550,6 +550,13 @@ static bool damon_va_filter_match(struct
 			matched = damon_va_young_addr(folio, pte, pmd, mm,
 					addr);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = !damon_va_young_addr(folio, pte, pmd, mm,
+					addr);
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

