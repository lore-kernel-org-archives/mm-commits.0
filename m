Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978E647A0DD
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 20:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782851732; cv=none; b=W/u+T+fB8XorzRqDf/D6mRlCoIJd1m+mgFebyNWmADFbjXNlXmkawikWCtydd8Ba6HyStIlB046vtRxRfv0v4M1Yc1iv+vxPECjGdtkumyOggPj0NmYB9NETgzRUL9iTOhHirxzqGTIk4/IkzDYZdvBJxtQxqRiCwTXyOgfeKtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782851732; c=relaxed/simple;
	bh=G9M4XvFBGEahy7JIxopJ52dxijW8vEhpxF+RYuXQ7zI=;
	h=Date:To:From:Subject:Message-Id; b=TE1YunRWLY9kyqMXxq2W2p0OPPddp24/chKrLGNE+Cu8IV8ab+8Z7fcq+/E/vgXaQEO70DiN1OnfR6J+EwfiZIvY06G9TufOtiXVOEgqpyNR99yh0kXWHOQv3LtVHSvVhIAMqM4EgyXrzzXTGDojhiT0wbXy9ORyq6Q0dgRedJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SbudxtWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SbudxtWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8C31F00A3E;
	Tue, 30 Jun 2026 20:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782851730;
	bh=mQ4lPBg81O6rftl/R30qck6X7EWkCv8UbgWD/0dS75c=;
	h=Date:To:From:Subject;
	b=SbudxtWMXCuRiS7+dzTTAxseD+Qzlg1nOZXm9LtfJri0NEpKz0gchC0jCcibOX3dj
	 rRPR0FAohN08c5ufNBVIaZy3iORfQ/x5BqtLKWccr41e2fBNa6XvG9Xf/D+o79VTMP
	 zpUe8yFPmUv3xSPATNrBJKGqnT5c9HP+ggdxb6xk=
Date: Tue, 30 Jun 2026 13:35:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfssh-test-coreops_filters-directories.patch added to mm-new branch
Message-Id: <20260630203530.4F8C31F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfssh-test-coreops_filters-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfssh-test-coreops_filters-directories.patch

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
Subject: selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
Date: Tue, 30 Jun 2026 07:17:19 -0700

DAMON sysfs interface essential file operations test (sysf.sh) is not
testing DAMOS {core,ops}_filters directories.  Add the tests.

Link: https://lore.kernel.org/20260630141726.92246-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |   28 +++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfssh-test-coreops_filters-directories
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -103,10 +103,28 @@ test_filter()
 {
 	filter_dir=$1
 	ensure_file "$filter_dir/type" "exist" "600"
-	ensure_write_succ "$filter_dir/type" "anon" "valid input"
-	ensure_write_succ "$filter_dir/type" "memcg" "valid input"
-	ensure_write_succ "$filter_dir/type" "addr" "valid input"
-	ensure_write_succ "$filter_dir/type" "target" "valid input"
+
+	local dir_name=$(basename "$(dirname "$filter_dir")")
+	if  [ "$dir_name" = "filters" ] || [ "$dir_name" = "ops_filters" ]
+	then
+		ensure_write_succ "$filter_dir/type" "anon" "valid input"
+		ensure_write_succ "$filter_dir/type" "memcg" "valid input"
+	fi
+	if  [ "$dir_name" = "filters" ] || [ "$dir_name" = "core_filters" ]
+	then
+		ensure_write_succ "$filter_dir/type" "addr" "valid input"
+		ensure_write_succ "$filter_dir/type" "target" "valid input"
+	fi
+	if [ "$dir_name" = "core_filters" ]
+	then
+		ensure_write_fail "$filter_dir/type" "anon" "ops type"
+		ensure_write_fail "$filter_dir/type" "memcg" "ops type"
+	fi
+	if [ "$dir_name"  = "ops_filters" ]
+	then
+		ensure_write_fail "$filter_dir/type" "addr" "core type"
+		ensure_write_fail "$filter_dir/type" "target" "core type"
+	fi
 	ensure_write_fail "$filter_dir/type" "foo" "invalid input"
 	ensure_file "$filter_dir/matching" "exist" "600"
 	ensure_file "$filter_dir/memcg_path" "exist" "600"
@@ -208,6 +226,8 @@ test_scheme()
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
 	test_filters "$scheme_dir/filters"
+	test_filters "$scheme_dir/core_filters"
+	test_filters "$scheme_dir/ops_filters"
 	test_stats "$scheme_dir/stats"
 	test_tried_regions "$scheme_dir/tried_regions"
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-probes.patch
mm-damon-add-a-kernel-doc-comment-for-damon_ctx-rnd_state.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch

