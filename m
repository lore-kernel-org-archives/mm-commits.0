Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290DF1EB5E6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119207; cv=none; b=gbIHu2Y+fn+CHX0c6cYwbgKScmpS+ZI9ZWew9DWJaBZYqcoX/BSjyW5m0dUBk7QSGMu+/tWyGDff8mu8ztQ7GmCbUdN0Y4Un4MxfOn5bW0DnTJbF36oBYObHDNcfhTw+rdEMnXbxqbEXheknU5znG/2DJeFArfxaRUyE04cBXLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119207; c=relaxed/simple;
	bh=XGvngc7RrjbTkYPwCcS7MSKKwtEI3XFj1H3Bs18HL6k=;
	h=Date:To:From:Subject:Message-Id; b=RsYHoSRe+4ODScyYvEL0iphGyJuOtg6K1+pdSASeg6kZCpIJxlh31xMwrfNgIx8vcF69Z8PI9QjNkl0CCwhzX0H2+aL87BQ43aw56GA10y3HbNt8p7JKVkRXdY8z4k8RY+t34b/kEmvGd0CNk5pXRFg9pNaeDCRYjwxMxCbSoik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qA0gYtVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qA0gYtVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82778C4CEE4;
	Tue, 13 May 2025 06:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119206;
	bh=XGvngc7RrjbTkYPwCcS7MSKKwtEI3XFj1H3Bs18HL6k=;
	h=Date:To:From:Subject:From;
	b=qA0gYtVdiu0q36RPpxySR3hOZ3tnSp4U/6P+XB4/kAMjUy6Jp34oZoT1+yDiVkVIZ
	 k3n84pkEbZk+ONpguMEAaiwjNOilK7s2yAjkdYa0dltcKCDkx2b67RQiQvMNuBl0ab
	 UajaZwyWiW90UL7T4X8F6z2MiZDOWlbC8dFk3N9A=
Date: Mon, 12 May 2025 23:53:26 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-nid-file.patch removed from -mm tree
Message-Id: <20250513065326.82778C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document nid file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-nid-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document nid file
Date: Sun, 20 Apr 2025 12:40:29 -0700

Add a description of 'nid' file, which is optionally used for specific
DAMOS quota goal metrics such as node_mem_{used,free}_bp on the DAMON
sysfs ABI document.

Link: https://lkml.kernel.org/r/20250420194030.75838-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-nid-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -283,6 +283,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the current
 		value of the goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/nid
+Date:		Apr 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the nid
+		parameter of the goal.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

