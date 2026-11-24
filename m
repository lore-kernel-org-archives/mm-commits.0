Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541030;
	b=3XhahKDtkzng7EGwf+KqHX88adh7t+1vOFB8ObAwgypRgPRtMcOH3a0D9tSCFixSwMnm
	 i7DzS4Pi8tDjtrWNDhB/f7tQXzsh9LYjPTDwkW4rJSfqAv5Z+ZvdYnq/kfDBlu4M9EkB+
	 gxmB+d0MA68x0IJP1QzxNZ1b3wpvj/8Xw2CIZzH/byZ7LBI+CiKCDdAgLcv1QNuGyiBAG
	 niz+VLqiYcL3euhm6vUbrrD7AkcUYGwrlmSFCd/byoWaPlOSzh8GWBHodBn96tS3YE3+c
	 Ome0MNYjJ8J9p+DF+pLdQAu0RwX/0zG8n/ZKtmrzd5E6KuzFvxcdJJqwq08pm/LWXUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541030;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=fB4Ls/imHOySKNH5CMAIMSI/malhNm7CGMpkPXKn+JQ=;
	b=H499JKR8Bbr/W8Vn7kNEHPDhR7E2T4WfVvtu8PeEzcVv31icYVx4/ghaXU53SjhAEHCY
	 8dZTg3LWLvcB3T50uOPZqNCEsvbNFVY1xUxhnSellBS4UdAWE+B7O+pcbf8qMdoagRolk
	 btkwd7xU+6PY0MfHs4yORPmLL2HsMA+qlVy5d2r2FDHvVeTk9lKTaX1CdaA/asa/f9E0A
	 oyijuaMi1jB/fWg3TIwnSJ2bP9TspbKOnlrwQRodlngJ8l1NZGh5ED25U3iKMZ737AGdS
	 fc1kIcuZRZ6xSN5OpRKnGEBCSReTVD8T0d9dW3TUpL7+0Al6mBGr9wAO/MW0V9vqK0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o9SVyjVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404B5606A323
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o9SVyjVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EB81F000D0;
	Tue, 24 Nov 2026 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541029;
	bh=fB4Ls/imHOySKNH5CMAIMSI/malhNm7CGMpkPXKn+JQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=o9SVyjVmqj33P06YTK/UIVPeWaixCpiJpwnIGzaBl9bn7F3hJ6VO1QyAB79jy2EgS
	 lAi5VruLeqRxMrGeclHK/USmX2PDPMB0Q+L2qHGpYl92LW+zTUWUNNmyGNofM9MKBH
	 t5MqlFGa/Vz0gd9/6zkJvqDQBZCaamwB3h2M8T3E=
Date: Tue, 24 Nov 2026 09:23:49 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,jm5905938@gmail.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-21-sj@kernel.org>
References: <20261124153636.91854-21-sj@kernel.org>
Subject: + mm-damon-api-introduce-user_report-report-type.patch added to mm-new branch
Message-Id: <20261124172349.A2EB81F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/api: introduce user_report report type
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-api-introduce-user_report-report-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-api-introduce-user_report-report-type.patch

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
Subject: mm/damon/api: introduce user_report report type
Date: Tue, 24 Nov 2026 07:36:26 -0800

Users could know some data attribute information and willing to provide
that to DAMON.  Introduce a new damon_report_type,
DAMON_REPORT_TYPE_USER_REPORT, for such user-provided reports.

Link: https://patch.msgid.link/20261124153636.91854-21-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>

 include/linux/damon.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-api-introduce-user_report-report-type
+++ a/include/linux/damon.h
@@ -759,9 +759,11 @@ struct damon_intervals_goal {
 
 /**
  * enum damon_report_type - Type of &struct damon_report.
+ *
+ * @DAMON_REPORT_TYPE_USER_REPORT:	User-generated report.
  */
 enum damon_report_type {
-	NR_DAMON_REPORT_TYPES,
+	DAMON_REPORT_TYPE_USER_REPORT,
 };
 
 /**
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

