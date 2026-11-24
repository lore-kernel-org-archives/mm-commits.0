Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541043;
	b=zX9i87af72/AozT0mgMDwW/joFgLZ3BXb0wzuNTNeS0bV3O4bGz4i2xRfbEnrHuKElC9
	 OJRkSH0e8u7sIZkBPuDaSeRFjMrZeRABgnX9Cu2/fNpJjA4knExRovUeYDINMHn8GGpcY
	 YmzzzhnjLatW+y8zanQ57me1LEqOC8gMncFzwUIhkuXWtFHLPphE1YdtMWX16cDBRqO/M
	 cpGTzM9qutgJP7i0Th05rBzDcNlxH9uwkNbWS2wn/K40LDPmZOqHhe71m6ZXBGYfit+in
	 F3QURDeILyFZtuzqTRoSF+dnFBmaDYBDMndTS2vQ8SjzAZkDl5M7EyveIbvGSh1GpEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541043;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=bBiNHUhdis9154vXXKwBZRBTP3TnVluTKda9tVcugTw=;
	b=fF1v5JPOt83WeqIlssNar/VZlxAyx4PqveaI3Ln1T0x8KsA4ik8qcaWo4uPXrpCrDkcf
	 p1Ldcwu4+7IqmL5egmek79AxFvsANwAl6TLxxNkN2q2c2juCiIzDhr8vl2HgYTHzdUFCs
	 +1RWTH+HwYapkKdKjKwEoKc//EKIjG4Pe1MMvNiehU8YlElsA6kW6T5fjzJiwly8y460L
	 hXUJ52pmRdLc/JA7csEMbSEJohXbvUkO1G91VrPn1Z5lTgw3n0beTiy4Y+wsL+vjEUw1+
	 b7fjkYnYPRksjCu2h0H24T66hDoqjRpYLp2uQC1jqLtVocbTTOoMus+E6NVbQUDanRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LQ8JvzdK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E953606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LQ8JvzdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAB11F000D0;
	Tue, 24 Nov 2026 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541043;
	bh=bBiNHUhdis9154vXXKwBZRBTP3TnVluTKda9tVcugTw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=LQ8JvzdKwaiuWaUmnZnIPDUrAKlmgqs0LbIMUGJBhcF4Jj4DQZMXJxq4BesCP8o0G
	 /48hjqTszBJ01D13mQCWteHMKzCsA1c07tcB0PhQftSmWT0eb8SmLwHMda2mVhy6sg
	 Sj6dm8wO83F3pUulkguyKLO3GDKY6OqIb+LDfdXk=
Date: Tue, 24 Nov 2026 09:24:02 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,lianux.mm@gmail.com,jm5905938@gmail.com,corbet@lwn.net,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-26-sj@kernel.org>
References: <20261124153636.91854-26-sj@kernel.org>
Subject: + docs-mm-damon-design-update-for-user-report-support.patch added to mm-new branch
Message-Id: <20261124172403.3EAB11F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/design: update for user report support
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-update-for-user-report-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-user-report-support.patch

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
Subject: Docs/mm/damon/design: update for user report support
Date: Tue, 24 Nov 2026 07:36:31 -0800

Update DAMON design document for the newly aded user_report type data
attribute reports.

Link: https://patch.msgid.link/20261124153636.91854-26-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>

 Documentation/mm/damon/design.rst |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-user-report-support
+++ a/Documentation/mm/damon/design.rst
@@ -382,12 +382,25 @@ can generate and submit reports of the g
 submissions could be done automatically by the kernel or manually by the user,
 depending on the type of the report.
 
-For now, no report type is supported.
+Below report types are supported.
+
+- ``user_report``: User-provided report.  To use this, the user should set the
+  address range of the memory to report for.  This type of report is not
+  automatically generated and submitted to DAMON.  The user should manually
+  generate and submit each report using the interface.
 
 The data attribute probe supports the reports.  The probes can be configured to
 hit for a given memory region if a specific type of valid reports that are
 associated with the probing memory exist in the reports queue.
 
+For example, users can run DAMON in the classical page table accessed bits
+based access monitoring.  In addition to that, users could find hot data that
+might not be able to found by DAMON.  DAMON might not able to find that due to
+limitations in page table accessed bits or its overhead control mechanism.
+Users may be able to find that using their access to workload source code,
+experiment results or other tools.  Users can complement monitoring results by
+feeding the information as user reports.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
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

