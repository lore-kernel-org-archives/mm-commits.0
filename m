Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541041;
	b=T7jBli3f1Tod7HbcwHNNx84mcYAtvIIDYN5Kzd7vH4L/nfeWov89l+0mUZ9rLEQev4sA
	 +vdlDwKqTLkoTid3jgQmdlHpoFgFKrCdsAvzvAyMNkgIJ2U835qyXR9oRQtPUWhSy7ZFY
	 o0WGKrtZ+rcKlz0Sgeionnzwz3WjbasTJbWWHd2Eqp/V0JINx5DNi1FY17lmRQlKaixMo
	 vrz6Ht/swnbEWzEAV6u8cRWlzRbsJN2uWwDhBE4T8tLxZRldQQ+4+gE+aXViMVdy0yTQZ
	 Fmf/d6wMg84QardLCc7KzPa3HpmuRh+oe9TTlmFTJJbID38pYD411N+AGaPMLIghfGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541041;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=V/LpG+QurkK2SyZN0SASAnrejDJM2ioF/p6Uo5ElLHw=;
	b=VfMKSxJigAqp3jllSVCsGm3DqoAmeuWHYaVdFJ2hzp+SNPCkPoAtwqbPddinIq5Wr31l
	 dw5q2Q4hG05AVQyQhGcfu3ZJ669W/GfNC+bqTD+IKo8p9+F4XhM/ov8byLNGn4vYvxCSb
	 JZ5pykwgBUAs/WJJOuFep6644KHzVR5P6j/zgMEI0qNnKDzElKqo6m1sNgagQLUtNElH9
	 pWjkSlBVhRkTq53V+5WbojQQdYEcs9c41SSs+4NDFtyU6ezXp4agrFqwHD0fbvX/7JBVI
	 sy8j591wKioZNAmgX672yKI6MylIZuFLpQS0A7TjpmtOHgQt7WvnObpMZvu9DlLAi4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gGbUxq4Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCE2606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gGbUxq4Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E345F1F000EB;
	Tue, 24 Nov 2026 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541041;
	bh=V/LpG+QurkK2SyZN0SASAnrejDJM2ioF/p6Uo5ElLHw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=gGbUxq4YxsTK25mjo3tcLfeXY84e7038NpK9sM2scx7BYAi021O4HAxZ3utn72Xw9
	 8198l8GxyK8UU0IS43UY+2CfaIbvjpAU/fDRRC86SfC1LjuQwXtdypTTDf40sBx2rS
	 OSs9xoP/wU1DkFIc2TAh3vhkt1p7gwpjjwfv5BSs=
Date: Tue, 24 Nov 2026 09:24:00 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,lianux.mm@gmail.com,
	jm5905938@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-25-sj@kernel.org>
References: <20261124153636.91854-25-sj@kernel.org>
Subject: + selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch added to mm-new branch
Message-Id: <20261124172400.E345F1F000EB@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/damon/sysfs.sh: add basic tests for admin/reports/
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch

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
Subject: selftests/damon/sysfs.sh: add basic tests for admin/reports/
Date: Tue, 24 Nov 2026 07:36:30 -0800

Update sysfs.sh DAMON selftest to cover basic file operations for the
sysfs files under the admin/reports/ directory.

Link: https://patch.msgid.link/20261124153636.91854-25-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>

 tools/testing/selftests/damon/sysfs.sh |   52 +++++++++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfssh-add-basic-tests-for-admin-reports
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -510,6 +510,57 @@ test_kdamonds()
 	ensure_dir "$kdamonds_dir/1" "not_exist"
 }
 
+test_producer()
+{
+	producer_dir=$1
+	ensure_file "$producer_dir/report_type" "exist" "600"
+	ensure_write_succ "$producer_dir/report_type" "user_report" \
+		"valid input"
+	ensure_write_fail "$producer_dir/report_type" "foo" "invlid input"
+
+	ensure_file "$producer_dir/producer_state" "exist" "600"
+	ensure_write_succ "$producer_dir/producer_state" "on" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "submit" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "off" "valid input"
+	ensure_write_fail "$producer_dir/producer_state" "foo" "invalid input"
+
+	ensure_file "$producer_dir/addr_start" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_start" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_start" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_start" "1.23" "uinvalid input"
+
+	ensure_file "$producer_dir/addr_end" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_end" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_end" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_end" "1.23" "uinvalid input"
+}
+
+test_producers()
+{
+	producers_dir=$1
+	ensure_dir "$producers_dir" "exist"
+
+	ensure_file "$producers_dir/nr_producers" "exist" "600"
+
+	ensure_write_succ "$producers_dir/nr_producers" "1" "valid input"
+	test_producer "$producers_dir/0"
+
+	ensure_write_succ "$producers_dir/nr_producers" "2" "valid input"
+	test_producer "$producers_dir/0"
+	test_producer "$producers_dir/1"
+
+	ensure_write_succ "$producers_dir/nr_producers" "0" "valid input"
+	ensure_dir "$producers_dir/0" "not_exist"
+	ensure_dir "$producers_dir/1" "not_exist"
+}
+
+test_reports()
+{
+	reports_dir=$1
+	ensure_dir "$reports_dir" "exist"
+	test_producers "$reports_dir/producers"
+}
+
 test_damon_sysfs()
 {
 	damon_sysfs=$1
@@ -520,6 +571,7 @@ test_damon_sysfs()
 	fi
 
 	test_kdamonds "$damon_sysfs/kdamonds"
+	test_reports "$damon_sysfs/reports"
 }
 
 check_dependencies
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch
maintainers-change-damon-scm-tree-to-mm-damongit.patch
docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch
docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch
docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch
mm-damon-api-introduce-struct-damon_report.patch
mm-damon-core-implement-data-attribute-report-queue.patch
mm-damon-core-introduce-damon_submit_report.patch
mm-damon-sysfs-add-admin-reports-directory.patch
mm-damon-sysfs-add-reports-producers-directory.patch
mm-damon-sysfs-add-producers-nr_producers-file.patch
mm-damon-sysfs-implement-report-producer-directory.patch
mm-damon-sysfs-implement-report-producer-type-and-state-files.patch
docs-mm-damon-design-update-for-report-system.patch
docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch
docs-abi-damon-update-for-report-producer-sysfs-files.patch
mm-damon-core-introduce-damon_filter_type_report_made.patch
mm-damon-core-introduce-damon_report_exist.patch
mm-damon-paddr-support-report_made-type-probe-filter.patch
mm-damon-sysfs-add-filter_report_type-file-under-probe-filter-directory.patch
mm-damon-sysfs-support-report_made-type-probe-filter-setup.patch
docs-mm-damon-design-update-for-report_made-probe-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch
docs-abi-damon-update-for-report_made-probe-filter.patch
mm-damon-api-introduce-user_report-report-type.patch
mm-damon-sysfs-add-user_report-support-for-report-type-input.patch
mm-damon-sysfs-implement-report-producer-addr_startend-files.patch
mm-damon-sysfs-implement-submit-command-for-report-producer.patch
selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch
docs-mm-damon-design-update-for-user-report-support.patch
docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch
docs-abi-damon-update-for-user_report-report-support.patch

