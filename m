Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B43B673
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957131; cv=none; b=WM+3FjlvOXziKcV/P0byRE7Kv689Z3mGarys6HFObk4abTlt/g3FDYgCYIk0eMPVKJMS0Zbt+kptbKcTKQJjj9FAAu2UiVX9gjydfoVZ6qaxHxzhMRO7OQ37rQRzFnTfDKs/u3pfm3QHrIou0Vm/FYuWXbayBlSybyx5ViZG0eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957131; c=relaxed/simple;
	bh=J+3OpxhubEtVWkHz0QI3z8ZAl8DeazBbdTeME4Pu7WM=;
	h=Date:To:From:Subject:Message-Id; b=cJK7kzPS+R4GpMi6JuZQqZY8ExjuDzF+mJXSHTKkMKdb5O7Lr9y/yUzkD4Sj/1Ymc3euzc4JGYjGYD32qrkSejjxlbe7/4SzF1rBYmv25f/PInuFlYH/bs0lvls9KNOpEWM5Rb/T+RJbtph2fFLh/Qraws/9sri5b7sr36H+0fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c5/HMl63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c5/HMl63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EAAC116B1;
	Mon,  6 May 2024 00:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957131;
	bh=J+3OpxhubEtVWkHz0QI3z8ZAl8DeazBbdTeME4Pu7WM=;
	h=Date:To:From:Subject:From;
	b=c5/HMl63ihIiyz8cC5ge3s9g5nytUGLneuIfFCnTucl2K4W0Lwzgdf4dbEQRPmZVn
	 f1H7kvpoI2VHdrViYu/ym6IpFqVyUnZ+sw/bacTaklvm0GwPhfSHHKseg0WHiBZ7hn
	 UhUf9dl9vs8l5BGLLsMLv+K/MpGFu6tnBLWuukMQ=
Date: Sun, 05 May 2024 17:58:51 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-damos-filter-type-young.patch removed from -mm tree
Message-Id: <20240506005851.86EAAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add DAMOS filter type YOUNG
has been removed from the -mm tree.  Its filename was
     mm-damon-add-damos-filter-type-young.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add DAMOS filter type YOUNG
Date: Fri, 26 Apr 2024 12:52:42 -0700

Define yet another DAMOS filter type, YOUNG.  Like anon and memcg, the
type of filter will be applied to each page in the memory region, and see
if the page is accessed since the last check.  Based on the 'matching'
parameter, the page is filtered out or in.

Note that this commit is adding only the type definition.  The
implementation should be made by DAMON operations sets.  A commit for the
implementation on 'paddr' DAMON operations set will follow.

Link: https://lkml.kernel.org/r/20240426195247.100306-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |    2 ++
 mm/damon/sysfs-schemes.c |    1 +
 2 files changed, 3 insertions(+)

--- a/include/linux/damon.h~mm-damon-add-damos-filter-type-young
+++ a/include/linux/damon.h
@@ -297,6 +297,7 @@ struct damos_stat {
  * enum damos_filter_type - Type of memory for &struct damos_filter
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMOS_FILTER_TYPE_YOUNG:	Recently accessed pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
@@ -315,6 +316,7 @@ struct damos_stat {
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
 	DAMOS_FILTER_TYPE_MEMCG,
+	DAMOS_FILTER_TYPE_YOUNG,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	NR_DAMOS_FILTER_TYPES,
--- a/mm/damon/sysfs-schemes.c~mm-damon-add-damos-filter-type-young
+++ a/mm/damon/sysfs-schemes.c
@@ -343,6 +343,7 @@ static struct damon_sysfs_scheme_filter
 static const char * const damon_sysfs_scheme_filter_type_strs[] = {
 	"anon",
 	"memcg",
+	"young",
 	"addr",
 	"target",
 };
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

