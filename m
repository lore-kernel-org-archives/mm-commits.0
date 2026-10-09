Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DFD407CEF
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525480; cv=none; b=TfnI5YF8QFo9eOu+adRe4LV2QGPIV9SMmkgD32AALFCSFyS/N6DGjT2V5g9Mhdiyd9mLvP8VPCu4c6FT5XWPD2KooyLBNSnW0nDKju4k+mkIE05HzNR2kfWW2o7/kTGBICXS9PywPT6PO8mo+i+iQ+kC+BVRBMZSSODI1d8Zr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525480; c=relaxed/simple;
	bh=xJXhu4kmSMEEw4SGuIl3uu3ngFhPnvJhYVek2eRbEEY=;
	h=Date:To:From:Subject:Message-Id; b=DJm4OPxxz6yB00enHJ/RAgl+7EnOv5QOvlJF7wa70hAOlGnDb01QRK2WBbEbhn/QpVxum0ZEuDdToRuAnCd8RBvTGwyCAWrKvbCJNv1ML/dGBf0gMeBv5lxbKWfjUsG4rjysUdeh+G+53pGsI66haLMbYkzkKymYLFbpo/Ik8yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fdq5Tm4v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fdq5Tm4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC6E1F00898;
	Fri,  9 Oct 2026 05:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525477;
	bh=JIa3DqCLq6aR0EgPXRANMYAtJwWpa5QpefEk+5OOOjM=;
	h=Date:To:From:Subject;
	b=fdq5Tm4vdmzkFd4X1abUEKSqsgZrshiQ2BQML+TYbIJ8aAIYK3TTY3V11QuzFqc2g
	 CHBSHoS4WJFk+sFEdVuoI0r6xE3nhEhyvWikv8Yrnvs1CgmZsU1sJ35sJEmVmbJnPq
	 NGdNNXnZFOiAg3CmyKg9QosrezyLcmxHPESPaDpI=
Date: Thu, 08 Oct 2026 22:57:57 -0700
To: mm-commits@vger.kernel.org,gutierrez.asier@huawei-partners.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-support-prep_probes.patch removed from -mm tree
Message-Id: <20261009055757.CDC6E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: support prep_probes
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-support-prep_probes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: support prep_probes
Date: Wed, 9 Sep 2026 07:04:03 -0700

Patch series "mm/damon/vaddr: support {prep,apply}_probes".

DAMON supports data attributes monitoring.  However, only the physical
address space operation set (paddr) is supporting it.  Add the support to
the virtual address space operation set (vaddr).

Patch 1 adds prep_probes support to vaddr.  Patch 2 moves probe filter
handling code in paddr.c that can be reused by vaddr to ops-common.c.
Patch 3 adds minimum apply_probes support to vaddr.  Patch 4 extends the
support for hugetlb.  Patch 5 extends the support for pgidle_unset
filter.

Test
====

I confirmed it can capture ~48 mb working set of masim in vaddr mode,
like below.

First, start masim [1] to access ~48 mb memory at a time, in the
background.

    $ ./masim/masim.py run \
            --config_file ./masim/configs/stairs-50mb.cfg \
            --repeat 10 --quiet &

Note that the config says the working set is 50mb.  It is 50 million
bytes, so ~48 MiB.

Start traditional access monitoring of masim's virtual address space
using damo [2].

    $ sudo ./damo/damo start $(pidof masim)

Confirm it can capture the ~48 MiB working set as the 4-th region on the
snapshot.

    $ sudo ./damo/damo report access
    heatmap:
    11111111334[...]3000000000000000000000000000000000000000489999997777777743333333555556[...]8
    # min/max temperatures: -1,150,000,000, 80,009,499, column size: 6.963
    MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    0   addr 85.355 TiB   size 55.703 MiB  access 0 hz   age 9.500 s
    1   addr 85.355 TiB   size 18.984 MiB  access 0 hz   age 6.700 s
    2   addr 127.183 TiB  size 278.516 MiB access 0 hz   age 11.500 s
    3   addr 127.183 TiB  size 7.570 MiB   access 0 hz   age 900 ms
    4   addr 127.183 TiB  size 48.133 MiB  access 190 hz age 800 ms
    5   addr 127.183 TiB  size 54.977 MiB  access 0 hz   age 1.700 s
    6   addr 127.183 TiB  size 55.113 MiB  access 0 hz   age 6.700 s
    7   addr 127.183 TiB  size 37.902 MiB  access 0 hz   age 3.900 s
    8   addr 127.990 TiB  size 120.000 KiB access 0 hz   age 11.400 s
    9   addr 127.990 TiB  size 8.000 KiB   access 70 hz  age 0 ns
    10  addr 127.990 TiB  size 4.000 KiB   access 0 hz   age 11.200 s
    memory bw estimate: 8.931 GiB per second
    total size: 557.027 MiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Stop access monitoring and start probe-only mode access monitoring.

    $ sudo ./damo/damo stop
    $ sudo ./damo/damo start $(pidof masim) --probe_prep set_pgidle \
            --probe_filter allow pgidle_unset --probe_weight 1

Confirm it can also capture the ~48 MiB working set as the 11-th region
on the snapshot.

    $ sudo ./damo/damo report attrs
    heatmap:
    00000000113[...]40000000000000000000000000000000000000000000000001111114999999533333336[...]6
    # min/max temperatures: -840,000,000, 330,002,000, column size: 6.961
    MiB
    probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   8.000 KiB    127.990 TiB   8.700 s       0
    1   120.000 KiB  127.990 TiB   8.600 s       0
    2   55.543 MiB   127.183 TiB   8.400 s       0
    3   110.008 MiB  127.183 TiB   8.300 s       0
    4   55.352 MiB   127.183 TiB   8.100 s       0
    5   55.605 MiB   127.183 TiB   8 s           0
    6   55.691 MiB   85.355 TiB    7.900 s       0
    7   54.430 MiB   127.183 TiB   7.900 s       0
    8   50.391 MiB   127.183 TiB   6.900 s       0
    9   18.879 MiB   85.355 TiB    6 s           0
    10  52.844 MiB   127.183 TiB   3.500 s       0
    11  48.039 MiB   127.183 TiB   3.300 s       20
    12  4.000 KiB    127.990 TiB   8.500 s       20
    memory bw estimate: 0 B per second
    total size: 556.910 MiB
    record DAMON intervals: sample 5 ms, aggr 100 ms


This patch (of 5):

DAMON virtual address space operation set (vaddr) is not supporting
prep_probes.  Add the support.

Link: https://lore.kernel.org/20260909140408.104699-2-sj@kernel.org
Link: https://github.com/sjp38/masim [1]
Link: https://github.com/damonitor/damo [2]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
---

 mm/damon/vaddr.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-support-prep_probes
+++ a/mm/damon/vaddr.c
@@ -483,6 +483,45 @@ static unsigned int damon_va_check_acces
 	return max_nr_accesses;
 }
 
+static void damon_va_prep_probe_region(struct damon_ctx *ctx,
+		struct mm_struct *mm, struct damon_region *r,
+		struct damon_probe *probe)
+{
+	struct damon_prep *p;
+
+	damon_for_each_prep(p, probe) {
+		switch (p->action) {
+		case DAMON_PREP_SET_PGIDLE:
+			damon_va_mkold(mm, r->sampling_addr);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void damon_va_prep_probes(struct damon_ctx *ctx, bool set_samples)
+{
+	struct damon_target *t;
+	struct mm_struct *mm;
+	struct damon_region *r;
+	struct damon_probe *p;
+
+	damon_for_each_target(t, ctx) {
+		mm = damon_get_mm(t);
+		if (!mm)
+			continue;
+		damon_for_each_region(r, t) {
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+			damon_for_each_probe(p, ctx)
+				damon_va_prep_probe_region(ctx, mm, r, p);
+		}
+		mmput(mm);
+	}
+}
+
 static bool damos_va_filter_young_match(struct damos_filter *filter,
 		struct folio *folio, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, pmd_t *pmdp)
@@ -911,6 +950,7 @@ static int __init damon_va_initcall(void
 		.update = damon_va_update,
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
+		.prep_probes = damon_va_prep_probes,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
 		.apply_scheme = damon_va_apply_scheme,
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

