Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541022;
	b=XMSw9cB0CIiFIaCKT+9GMgE5nTb/VKDV7HJbRSJmqIlxZB9HYlJww53pATFNngsoKQuY
	 X4Qnwi9QXKCmp19C3539h5Hb/krOCVcqsaK20fUTAuLQ+hWXhxzk54DcmKSCSz1UtSGjn
	 JxFtA6KW/OVvCO/r68aax/WAPQuvPu/UbcguFeVG0WHNEXo+bnl7pfwAchG53wM+JmjIP
	 ox8wNuMzy3d4f1qNKrBB7dGm6uxhAKLFohlzPjJAoODU0hHLK8i7SnsX4MH71N3qmvg35
	 IOE7lNTCbOrd1ToBIb8v5KdQmN5+SzMuuorltev83c98itdo2bFcj6epwS+F0Wv/ltQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541022;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=J3ZQZbh09bgC8tW/SctThmcU72c3/EfbD/foZK4Ip+I=;
	b=GOkVGWR28xkLWMVmHUuxN59G2gsX7Pjo7Gu3CHLgkQqsVzTI09MHeBFjlxYlcD05UDR1
	 ZFV6Xr7m/zWVsOmMFIv+MUC0ShgoAH5PELlePK3Hlf9ewKPSI7jdCgfg5k2wteOwjuA0f
	 7MLoujQEuQP2a7J5w7lp5CngWFg+1YSSuJUM+3KjG3oG3W67kz9xqGbtcD2Mjw+j5TMZA
	 PprXsHML4X4OgQaxQ+wCsUS4hb3rRwxMO2fTe+qOQL24//BC60Q/lFqF8l6cosg/jeyEA
	 v+HNi4+pEPY9KyqP9XVHEUGaGKGM3QpE9LuG6jFKKtYZerVwxKNvgIY+kqCxW6Nbe2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iuhauT4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880F8606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iuhauT4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E6A1F000C0;
	Tue, 24 Nov 2026 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541021;
	bh=J3ZQZbh09bgC8tW/SctThmcU72c3/EfbD/foZK4Ip+I=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=iuhauT4KXmlz/9w9HC1oePPixPe0l/m+5kEj/Ajl9jBIiRt5gRzip9YeDeZ4du3xH
	 tvJoGWwNJdITDSwOw00PDxeSmPUrkFdAetIzfTx/xc1X0T9zBL0BuIfTc8LiMfT5Oe
	 XLTU0yqssGoOR4ubcEi+bQpMrFyRvZiHugLDdBqE=
Date: Tue, 24 Nov 2026 09:23:41 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,lianux.mm@gmail.com,jm5905938@gmail.com,corbet@lwn.net,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-18-sj@kernel.org>
References: <20261124153636.91854-18-sj@kernel.org>
Subject: + docs-mm-damon-design-update-for-report_made-probe-filter-type.patch added to mm-new branch
Message-Id: <20261124172341.82E6A1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/design: update for report_made probe filter type
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-update-for-report_made-probe-filter-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-report_made-probe-filter-type.patch

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
Subject: Docs/mm/damon/design: update for report_made probe filter type
Date: Tue, 24 Nov 2026 07:36:23 -0800

Update DAMON design document for the newly added data attribute report
existence type probe filter.

Link: https://patch.msgid.link/20261124153636.91854-18-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lian Wang <lianux.mm@gmail.com>

 Documentation/mm/damon/design.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-report_made-probe-filter-type
+++ a/Documentation/mm/damon/design.rst
@@ -303,6 +303,8 @@ supported filter types.  Currently below
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
 - ``active``: Same as that for DAMOS filters.
+- ``report_made``: Matches if a :ref:`report <damon_design_attr_reporting>` for
+  the memory is made in last sampling interval.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -382,6 +384,10 @@ depending on the type of the report.
 
 For now, no report type is supported.
 
+The data attribute probe supports the reports.  The probes can be configured to
+hit for a given memory region if a specific type of valid reports that are
+associated with the probing memory exist in the reports queue.
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

