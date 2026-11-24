Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541049;
	b=oNGc2NJgpCmIiGN6heLL+HAbGxTbikXfczUOjhGtRLPG8dky5AdUwrGqW7+q6bDe6IR4
	 Hvef+2ZdevAgY9Rw5f9k/KbfCsPjFG/lXuQ3fd2x7khGQ8qOls5f9lCrarv1uRl6UUke2
	 rm9x8J0QPfo8GbXAqlLawmbg4wQj2LzJCgZpWw11i/EUnVCwR/YOBbgH60rlvEmFpEGP7
	 3GYv39PCXHc3qwd0epypYjCSQESftNxULvUtNrEwzBECAtfZAztUtlaF0J2AVHGkKsysy
	 WuEDySpoyvn3KtpijV8Ab2oVUxrOQWnw+CpAva3uye9/fATLO2krzWsQV4gCsyB28pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541049;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=u/oVUmiTmYhiFLZdhkhi78iU1CXOG18snFOSfbBrtc0=;
	b=T6kmh28cyZbZ89hDygV4+Z462kihXkkfJsdZVUgT05Avv67v2fComIj7KKb6LNLF6cqK
	 Z4Xm2itURZqnsYRrAi8in5izHilpBg5a+rB5IOWSSzQLfVsDtEuAeZJ55EXnMjJglyELe
	 Al+EtcBIUg7h7bUl7kR36KGT/VLyNLnQ5M7u0zWycmV0PiDrElviGcysPBxQzFqq3yZOn
	 lpY7k9oHojR4BgqUnbaJcbdeMvX+Oit/gME1hhcqIGoDky4kPtX7CVE4MNfqBe2h2XQYe
	 Dtzbvo3cf/QgPOvN7Y1auB5zWw7HhLHOfDjHYMAKSbgR2e9qO2JTBjCIp6mRRabRZpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AUoA0Jef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CBE606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AUoA0Jef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601751F000CA;
	Tue, 24 Nov 2026 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541048;
	bh=u/oVUmiTmYhiFLZdhkhi78iU1CXOG18snFOSfbBrtc0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=AUoA0JefyTjHtuQ+i/ksWVBD/Uwcysa7r/VUImXNACExGYSRbvBBWj46s552V3SBW
	 QCsFr5JFTy6eqVmnnMUPSu92LN6BysypujspuVRGoPKfORXiyOllrXITh3NM4J6IB5
	 9GeTr7eTzTnpl4EvC76f4aPnvXnFN0K9pndkxOk0=
Date: Tue, 24 Nov 2026 09:24:07 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-28-sj@kernel.org>
References: <20261124153636.91854-28-sj@kernel.org>
Subject: + docs-abi-damon-update-for-user_report-report-support.patch added to mm-new branch
Message-Id: <20261124172408.601751F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/ABI/damon: update for user_report report support
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-update-for-user_report-report-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-user_report-report-support.patch

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
Subject: Docs/ABI/damon: update for user_report report support
Date: Tue, 24 Nov 2026 07:36:33 -0800

Update DAMON ABI document for the newly added user_report type data
attribute report support.

Link: https://patch.msgid.link/20261124153636.91854-28-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Cc: Lian Wang <lianux.mm@gmail.com>

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   16 ++++++++++++++
 1 file changed, 16 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-user_report-report-support
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -729,3 +729,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	A file for requesting actions including enablement and
 		disablement of the producer.  Refer to
 		Documentation/admin-guide/mm/damon/usage.rst for more details.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_start
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the start address of the report to manually generate and
+		submit, depending on the type of the report producer.  Note
+		that the start address is inclusive.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_end
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the end address of the report to manually generate and submit,
+		depending on the type of the report producer.  Note that the
+		end address is exclusive.
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

