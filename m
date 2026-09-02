Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DD14B0C8D
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388934; cv=none; b=RWLsUZV+GAJWRhUGYxG3XlKOSbiXkMlFUnRCyOJWbnENhm8FcqkY9R2zNZpmxa5ScM/LSIg2VAZfcxeaUgIuQYGpL856kH+pC7dIfwtV7/HhOcZXGc9WlgzDC6t6lhMZpQE5e5zAe726UgR+JjCUDDY9S95gSUsox9BlV3fPP5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388934; c=relaxed/simple;
	bh=q27J0zWWOVgyJbRT3MA59B/3sgolayjEbcIcjegcvWs=;
	h=Date:To:From:Subject:Message-Id; b=HnNB+Bwjdf17wgPJXar92uzoYzoQ7EfCKjy/FWF+FpX4Iw34UE9CVTqH/wUSBgZw67nW2Y2HomTPzjO1hIttHCXi1yqdKxTUdhfaInFsDBP5ubug3Ke22Yqs+lrXYdS+6rOGPswOI4yLMiYMKua72Jf7WRO/KbaOOgGMyQXhXjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GFlKZtLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GFlKZtLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41CA1F00A3E;
	Wed,  2 Sep 2026 22:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388924;
	bh=ipf6mZB0P7mRqH7kFZZQe7rWIgW3hTdWE9cnKQ4QVmg=;
	h=Date:To:From:Subject;
	b=GFlKZtLTdpKLVSD/DZAobfMq69AZ5RqSEB72avZ+01x7poTLbj64k+q+Ivo5TitC0
	 2btOW37HO+OyI9HVyxGKZwW9ddMjPdtd2MnaotSaEQq5DTTsd+FJqWlvbUvF51gRfD
	 dNErEUz8FduyAtnyyDk5o5wi4QFVeTjMcCMSBCfg=
Date: Wed, 02 Sep 2026 15:42:03 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-remove-a-debug-message.patch added to mm-new branch
Message-Id: <20260902224203.E41CA1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: remove a debug message
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-remove-a-debug-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-remove-a-debug-message.patch

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
Subject: mm/damon/vaddr: remove a debug message
Date: Tue, 1 Sep 2026 22:47:36 -0700

There is a debug message in the DAMON virtual address space operation set.
It has not really been used in a meaningful way for the last few years,
though.  Remove it.

Link: https://lore.kernel.org/20260902054747.99370-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
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
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-a-debug-message
+++ a/mm/damon/vaddr.c
@@ -189,22 +189,12 @@ static int damon_va_three_regions(struct
  *   <BIG UNMAPPED REGION 2>
  *   <stack>
  */
-static void __damon_va_init_regions(struct damon_ctx *ctx,
-				     struct damon_target *t)
+static void __damon_va_init_regions(struct damon_target *t)
 {
-	struct damon_target *ti;
 	struct damon_addr_range regions[3];
-	int tidx = 0;
 
-	if (damon_va_three_regions(t, regions)) {
-		damon_for_each_target(ti, ctx) {
-			if (ti == t)
-				break;
-			tidx++;
-		}
-		pr_debug("Failed to get three regions of %dth target\n", tidx);
+	if (damon_va_three_regions(t, regions))
 		return;
-	}
 
 	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
 }
@@ -217,7 +207,7 @@ static void damon_va_init(struct damon_c
 	damon_for_each_target(t, ctx) {
 		/* the user may set the target regions as they want */
 		if (!damon_nr_regions(t))
-			__damon_va_init_regions(ctx, t);
+			__damon_va_init_regions(t);
 	}
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
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
mm-damon-tests-core-kunit-test-damon_commit_filter.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch
mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch

