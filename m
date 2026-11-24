Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541032;
	b=nKicJBr8tnMFNAL72f2bBHSlehUcCqFh6uyXDVUEr1vOv8H42X+q2MTXTsTSnlW4K45m
	 vLkAtlbn43jP4L0yMTLcLLr+MoC59N28ZCpP8k646Ipt+IoJPVkBwQZZ+Y5Gl1mtn4iLR
	 /GbuUb29rQPGeeHJPq9nRdokikvUJd9us4weykpfQHwbi/8iqWckPhNHZoRFqsR9osVnT
	 iDyURu24hcL4MO7q9kdaNG1l0UoX2HTaBPT4rUThKMLfV+1LFG1Nba72q3wK0Xh0hSLvS
	 WMde5DuuXXWRw/IXFsPwTLzGYutzED4/MpaW/tupEdLzBDw0xOVhY1VPtkrwwst2PsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541032;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=FBH7zCL8uD64WwWbQfJuslyDKxhGDKZZRoLowjfDA1Y=;
	b=bCra3hEpQDiNfBY1M/TmLw/Yxtwyh92mFcV9VYJRsCzBYGxIQiq8XzRJP+Zqh7HDuljB
	 7iyZ9iJf5mtnNUxQi3u0zOkLO0E0Km8JuqODgPt1+gur4+gZIg3ZKJHA6wE/zO65dqk1F
	 PO+Gp4SAXTU8AhIAwUljZvToXVk/gNxqdhqRkp6DF9MTSupy9Jh0zUWdVoDko0YhRmQtk
	 +mubUBc9e49hq3Xe/oIqsV7qAbJC1pNlSMvGRzsNtIEXteCv8CZHg9/sDa/FxZuXZthCe
	 MkELvqnT4aG117AGgZ3u+RT9NhjbrIBhhBoFiUCxc+V/9eC7brdWTMmQktJSFO2MeGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GmYsp34p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B3606A32E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GmYsp34p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D1D1F000EB;
	Tue, 24 Nov 2026 17:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541032;
	bh=FBH7zCL8uD64WwWbQfJuslyDKxhGDKZZRoLowjfDA1Y=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=GmYsp34ppf9I01ic79M70HfAR7ELB3e28HzOKgdrS5Q3pp0qaEcyYgqEma1RjsaKb
	 iHssaHk3IkUHh3aV7itAiT78yU/lPNeA5Y+ZF5wJji4Hnt0T4M2HygsymJQhqAz4sy
	 1+Zj+mdfudPrAZbUY2NO2aLxvGIUUzt8M4LkAsOM=
Date: Tue, 24 Nov 2026 09:23:51 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-22-sj@kernel.org>
References: <20261124153636.91854-22-sj@kernel.org>
Subject: + mm-damon-sysfs-add-user_report-support-for-report-type-input.patch added to mm-new branch
Message-Id: <20261124172352.54D1D1F000EB@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/sysfs: add user_report support for report type input
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-add-user_report-support-for-report-type-input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-add-user_report-support-for-report-type-input.patch

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
Subject: mm/damon/sysfs: add user_report support for report type input
Date: Tue, 24 Nov 2026 07:36:27 -0800

Extend the mapping list for data attribute report types and user
keywords, for the USER_REPORT report type.  Use "user_report" as the
matching user keyword.

Link: https://patch.msgid.link/20261124153636.91854-22-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

 mm/damon/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-add-user_report-support-for-report-type-input
+++ a/mm/damon/sysfs.c
@@ -1187,6 +1187,10 @@ struct damon_sysfs_report_type_name {
 
 static const struct damon_sysfs_report_type_name
 damon_sysfs_report_type_names[] = {
+	{
+		.type = DAMON_REPORT_TYPE_USER_REPORT,
+		.name = "user_report",
+	},
 };
 
 static ssize_t filter_report_type_show(struct kobject *kobj,
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

