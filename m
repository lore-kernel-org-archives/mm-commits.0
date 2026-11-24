Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541046;
	b=3w86Gd0bS5FxSj48C2UjAcqdF7RFuXMYQzAuDJIz2/a9zK5TKgLUZ+mwq/ZtXwaTxBGt
	 28Wf0jFx8dBGE2fhvj/WYdF20K6m8zmLULqi2K72bepCwBVRJSjH0P12YhCMlU8mwgGqg
	 /8TkAdd6ogrDVF7uBjhyajxeLOv9iVnPCeXJitEWMnad3kw9NC4N4FUmC9TKzr6tC6BkP
	 nu1Pj723TLuSGnSzZs3rM2rGHtJVO3DC2m6BD4mvF+nS59XwJS/MpRM4vAEG7KtAKsfRB
	 xQj1K/ut8o1+1VV9VVbx1EwNnwAsAwj0NwxiGplIKpa2MmiHDRqugC/tmGaQj8b+vwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541046;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=fBT+3OqRfEDOMEdNj2ZyCI1ejLscal1CLnVEih3e0pU=;
	b=PCX2SFUNZFvagI7Dx3Gh1SO8uDwFZZBawPb/WX++JbaXlQeoMLZ7dupxNWqzRV8dVc8s
	 QEaWPylGMWDP0e/VXm/02Ftz1dlUbLpUVgtQiMOMz4BvMWXg3AtZEbCk9wmx5p2l/YIYr
	 w/+QWe/8bd4+JWmWVhFHE1BvWvPiAl35I6wwzybsN0heDklNwCWx6rXQuxG4VW8P+WcVq
	 AYxPfXa4xi/MXa7jOi+rS+PfDMRjM5ooEHw39/hJFm6JaejGluBMrCFJ+IeXHLsSM1ldh
	 JLJ9axdxT7llrq7bLBr0jJuGmEPdQezO66+86j2jHluw/NZKQKU0xVpGNgOPfHhIzDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S1AjeENW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398D9606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=S1AjeENW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992D41F000CA;
	Tue, 24 Nov 2026 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541045;
	bh=fBT+3OqRfEDOMEdNj2ZyCI1ejLscal1CLnVEih3e0pU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=S1AjeENWL6oFM2jxvbo63rFi4wnTUb4+h8tloKGvTaJ8LXlQbBly+wQxGq2kqR3SV
	 JG8NdA8tU0TNAOny4uoWj5+G3Ffrc3Gg5yWbvK+BW3/OeftHeJ74J/xGkGpSp94t6Q
	 PwsPEb7AKqG5L9j354CUHQnTehTbYoz6iyk+JSbc=
Date: Tue, 24 Nov 2026 09:24:05 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,lianux.mm@gmail.com,jm5905938@gmail.com,corbet@lwn.net,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-27-sj@kernel.org>
References: <20261124153636.91854-27-sj@kernel.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch added to mm-new branch
Message-Id: <20261124172405.992D41F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for user_report report support
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for user_report report support
Date: Tue, 24 Nov 2026 07:36:32 -0800

Update DAMON usage document for the newly added user_report type data
attribute report support.

Link: https://patch.msgid.link/20261124153636.91854-27-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lian Wang <lianux.mm@gmail.com>

 Documentation/admin-guide/mm/damon/usage.rst |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-user_report-report-support
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -120,7 +120,7 @@ comma (",").
     │ │ ...
     │ reports/
     │ │ producers/nr_producers
-    │ │ │ 0/report_type,producer_state
+    │ │ │ 0/report_type,producer_state,addr_start,addr_end
     │ │ │ ...
 
 .. _sysfs_root:
@@ -770,6 +770,15 @@ Users can write below keywords for the p
 
 - ``on``: Enable the producer.
 - ``off``: Disable the producer.
+- ``submit``: Generate and submit a new ``user_report`` type report, if
+  ``report_type`` is ``user_report``, and the producer is enabled.
+
+``addr_start`` and ``addr_end`` files are used only for ``user_report`` report
+type.  Those set the address range of memory to manually report .  Users can
+set the start and end address of the address range by writing the addresses to
+the files.  Note that it is open-end range (``[addr_start,addr_end)``) and
+therefore the end address is exclusive.  Reading the files shows the last
+successfully written input.
 
 .. _tracepoint:
 
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

