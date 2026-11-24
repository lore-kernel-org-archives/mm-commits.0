Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541024;
	b=nzzU2vEeKKlpKeZqOrOxgTDkWuaUuB1qxw6aJsaXcPcOm+8IKWp/TvbxziCZxbxsLJa3
	 /XmldM1QSeFMLGnop6KXVhbuT7T8gG3ZPmHsKaPglunA01OxhLM+v6v4sSjkYwrT5S5xg
	 0B4AbnHjzAZAb9gZ9XkVf6X9/MsaDj0xJeAq8NKRMY2AKGvscec+8qC2H1uHkHEQpe0rA
	 x+tQCj8kOv4tkcM7wmF7nlZ9MegdT39iIrgAO4/brv4Mr6TWRZI/VBbAl/+1Q0TRVNKid
	 kiuZGYDgzl+aFdOajQ1TYIwdJ+Qc8Gf8HgOIPYvQzLr1kUJyqWK5zcuw0dau61gEYZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541024;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=pvys2uR21mLwa4o46sqWGSv+5ycaHPPLMGZkn4SoMwA=;
	b=xcFTw7cAiplPWOdsvTwbziB9Z3w3y2j8imDUaCEFqMth7PrXIGB72Q8+fQCzBKdrq6YK
	 Hv9dqSrMSV592xedI3z2QnBSsfTG3Vpsh6JBoMeoLMJYvgBFEpng8ZnkdMCzv2MNc84/z
	 Aq+mipY92l71ro5Kz3wntrgufocoNjmeiJP9BevoRsJdL6PNw0G/mFzCTy1FvIMfm9DBe
	 LJj6P+ASDbJYhvtej4gcg4dM4AJ+ABn4OwGJpzCulQ0jw1RlgZTnFveOHcYOOPwdLzWum
	 6+ilfOMyH2+c2GcL6nZaFgIcVcig/VNIvcj5BhsE9ANQjZc4mnVI30B4ZKwf5pT6T5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sbrDzR6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3098606A327
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sbrDzR6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581921F000C0;
	Tue, 24 Nov 2026 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795541024;
	bh=pvys2uR21mLwa4o46sqWGSv+5ycaHPPLMGZkn4SoMwA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=sbrDzR6zeg5njKjKcpQJUUdxNtzOabcFOMMxgzuPxSvN4I13Ejkpgys4a2ui/nzjn
	 jWdy9Au9eUKSpeUdJCyaz2+91L0sgwJjX3qybqA2DUOR9XZo5HX7NC0V/2p/KWxRGC
	 jVe5igHdreSvpQSuuA+FoxyKDINj4eWBV1AvgpEA=
Date: Tue, 24 Nov 2026 09:23:43 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,lianux.mm@gmail.com,jm5905938@gmail.com,corbet@lwn.net,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153636.91854-19-sj@kernel.org>
References: <20261124153636.91854-19-sj@kernel.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch added to mm-new branch
Message-Id: <20261124172344.581921F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
Date: Tue, 24 Nov 2026 07:36:24 -0800

Update DAMON usage document for the newly added REPORT_MADE type probe
filter support.

Link: https://patch.msgid.link/20261124153636.91854-19-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>

 Documentation/admin-guide/mm/damon/usage.rst |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max,filter_report_type
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -320,6 +320,10 @@ filter <sysfs_filters>`.  When the filte
 ``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
+When the filter ``type`` is ``report_made``, the :ref:`report
+<damon_design_attr_reporting>` type for the filtering should also be specified
+by writing the type name to ``filter_report_type`` file.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
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

