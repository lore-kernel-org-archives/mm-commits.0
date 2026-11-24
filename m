Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541027;
	b=wAdpWbcpWGvVeIUFdyiJHcGo/1mj26NRnyy2/YRslVNZagpvZANAmnB11MvLRKgZ7Kl3
	 2dutX7AHuGh1hr7wZ2FtKDPHprX0XI0OAIkvg2/O7Y3l58KQ/sMVEpKlekoB+RppCn5wn
	 cU76XXKCXpC/r8Qbk0njnOBu45RGOAtBBxR93FVXkcydXws9+TQCTfjaVrYiQ5eOX3mIN
	 i+FK2Yl23Qx+gjPe8gJ6rVJM2ru3eLttQJC6SGOaAzQrF/2dV3GrMycTkHiaSm3qkA4P7
	 GtQClGqTdJB4oEWmLUB2Qk3UOhxbZ1mfJsczODi1fIvZYJzNDB4kQYpT8pIxuOXddZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541027;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=l3vAEolwoSySyU0nYQPdvhfvbu900Pymop9/o9Dt4WU=;
	b=dQu+4tyVVAt8sk2bYkZXsUkJclx9rPUE6eLieFFHu2lpx8UiZam/z2XvEnYcgbwvjEkZ
	 0XZG8WQ8PX67mPoQlr4dcmh+JVKRYcbBz3qdjdzNyrTGeMnJE3kV189LloTNsl6kUGI+N
	 V4Dke2Uwi4OBNTfVqw4j1v2xIk3ukA0AeTFubPpvD/vjJ9nR2YFwlKA13pt60+P1++Zt/
	 V/bsZImvl8szWGveb7aJ5tFw4aznXGjaEXJ6gbZ+cuS/6X3olXFV6if68fOTCMjAO5Rx7
	 TVttGirvrt1hgZBJPTCzG06iVLbJ/KW+wzEqQIipdRhaqnApLdyxvw9yMm/U0xTX05A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KQ9j4N68;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F3B606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KQ9j4N68
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC90C1F000C6;
	Tue, 24 Nov 2026 17:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541027;
	bh=l3vAEolwoSySyU0nYQPdvhfvbu900Pymop9/o9Dt4WU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=KQ9j4N68TAGAi5aR6v5WJs9AGxH5z/9fCcqmTTlIXdpKBuK+PybX/1uIHGrVJ3mRB
	 Bgbu8rpBdC/jeeM7AO29ekUWFV03wE+tFYYgJU+LU9pEXWjTV1DOac9gG+j5qCi4Yl
	 sjlbAaj4VqL7jtoEDfTu6X532xBvFqcd8wV6vblk=
Date: Tue, 24 Nov 2026 09:23:46 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-20-sj@kernel.org>
References: <20261124153636.91854-20-sj@kernel.org>
Subject: + docs-abi-damon-update-for-report_made-probe-filter.patch added to mm-new branch
Message-Id: <20261124172346.DC90C1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/ABI/damon: update for REPORT_MADE probe filter
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-update-for-report_made-probe-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-report_made-probe-filter.patch

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
Subject: Docs/ABI/damon: update for REPORT_MADE probe filter
Date: Tue, 24 Nov 2026 07:36:25 -0800

Update DAMON ABI document for the newly added REPORT_MADE type probe
filter support.

Link: https://patch.msgid.link/20261124153636.91854-20-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-report_made-probe-filter
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -233,6 +233,13 @@ Description:	Writing 'Y' or 'N' to this
 		hitting the probe for the memory that satisfies the 'type' and
 		the 'matching' of the directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/filter_report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'report_made' is written to the 'type' file, writing to and
+		reading from this file sets and gets the 'report_type' of the
+		reports that this filter is working for.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
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

