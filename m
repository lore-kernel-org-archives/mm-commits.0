Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541001;
	b=oArO7BwlDkavUAvOe/Ewe4DKzfjoD6lYrZQkw3/zGtRsfb2cK/aGnFh7ZXbAELxeel++
	 JI6EvnQxNK3shKOMJkNRikliPe4DV3QBv55GKO/BmrzUhQ3gsQOUuU88XhyXi5wrYYiSm
	 vtOA6GZCxKw0WvrGBkzuhfiUXf7LJm2i09N2VqHCDs5/CBbXIKOzMYGZc08bZ0jagyB6O
	 GaB/NID9qrIOz1fy33Difm8a6aeOJfI18gdau8lExJznxL7sR0dK2p4FdyWJQpZVEjPDE
	 tMw9LtNHRqGoQotIcGizQvpWoRM9WdeJ5+J0DY815+o4DGnq8ztWhr29xkBHtPSz3pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541001;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=XzaSqdq5YAujlo+HYojox1+GWaWmU0jt2k8AfgpCNXo=;
	b=yx9oM6+o5nW+wSJGCfAYaYHkhhHmIM7qK5ep/2NqSePtcvq/Cwmc50DCFlUkatw++oL8
	 2Az27ft4adNaaC0H7lEZ/RupQgv5Trw9MOTDAKVfl5+HY3tzRBWgN/+hHWtDLfIB4cPje
	 WOxCb7p6AAGFK20sU2dakomfM1E0OG5m3m4OT8yc3Br1qlaJPq6vH8Gtuk6SYWKLEdviU
	 kZbtOPLlNu5D088LkARYjx8V/vAAMy/zSbPgAyTNDyoCfDqC37kRyJ+2CPoCjztkchSLp
	 wJyXiamn7jUGQBHs5TyzyD1apL6BSnNSFCxTbZY2wCH//m18HRA5HTzt7FSabfWPj+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UWgJbW8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96654606A330
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UWgJbW8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D931F000D1;
	Tue, 24 Nov 2026 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541001;
	bh=XzaSqdq5YAujlo+HYojox1+GWaWmU0jt2k8AfgpCNXo=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=UWgJbW8Ydk3d2ZnsQXljYnBEt1SgWeDzNBNrTPjGSEcrbzj6VST1zhcrCMrRWasiS
	 EmaMnGPlw/eTUkw5M9R1szeRloywaCGuyRmhAWNBTht/FYFk3dF5+lpx9ozTwLL3FM
	 NrObFohFYUcvDVlwCbsh10SHc9/RQlhvKPw8z4Mg=
Date: Tue, 24 Nov 2026 09:23:20 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,lianux.mm@gmail.com,jm5905938@gmail.com,corbet@lwn.net,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-11-sj@kernel.org>
References: <20261124153636.91854-11-sj@kernel.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch added to mm-new branch
Message-Id: <20261124172321.43D931F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for report producer sysfs
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for report producer sysfs
Date: Tue, 24 Nov 2026 07:36:16 -0800

Update DAMON usage document for the newly added report producer control
sysfs files.

Link: https://patch.msgid.link/20261124153636.91854-11-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>

 Documentation/admin-guide/mm/damon/usage.rst |   35 +++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -118,6 +118,10 @@ comma (",").
     │ │ │ │ │ │ ...
     │ │ │ │ ...
     │ │ ...
+    │ reports/
+    │ │ producers/nr_producers
+    │ │ │ 0/report_type,producer_state
+    │ │ │ ...
 
 .. _sysfs_root:
 
@@ -732,6 +736,37 @@ Please note that it's highly recommended
 <https://github.com/damonitor/damo>`_ rather than manually reading and writing
 the files as above.  Above is only for an example.
 
+.. _damon_usage_sysfs_reports_producers:
+
+reports/producers/
+------------------
+
+Under the `admin/` directory, ``reports/producers/`` directory exists.  This
+directory is for configuring :ref:`DAMON report producers
+<damon_design_attr_reporting>`.  The file below exists in the directory.
+
+``nr_producers`` file is for generating report producers setup files.  Writing
+an integer ``N`` to the file creates the number of directories named ``0`` to
+``N-1``.  Each number-named directory is for configuring each report producer
+and called "producer directory".
+
+reports/producers/<N>/
+----------------------
+
+Files below exist in each producer directory.
+
+``report_type`` file is for setting the type of the report to produce.  Users
+can set the type by writing the type name to the file.  Reading the file shows
+the last successfully written input.  Refer to the :ref:`design document
+<damon_design_attr_reporting>` for the list of supported report types.
+
+``producer_state`` file is for reading and updating the state.  Reading it
+shows ``on`` or ``off`` if the producer is enabled or disabled, respectively.
+Users can write below keywords for the producer to the file.
+
+- ``on``: Enable the producer.
+- ``off``: Disable the producer.
+
 .. _tracepoint:
 
 Tracepoints for Monitoring Results
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

