Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE166B673
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957133; cv=none; b=WEhR8tMgTeQUuaSegY6QZwE1Wuj6lz4Sp/mGbyUqFPxkQiE1rHMJbnTu4Oo4DmIvU17+oH525r/snUg/gvO79EeXoNEVVX+RpK4OVdqTeabH5XGWCrwPj8VdlVLecNrxLtE6fuPiZphrKPQBcx30u/EcnU3Mc39vgGmaJaFscSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957133; c=relaxed/simple;
	bh=FSQ+91J+vjjQwan1g2S2YrTQ9U4I4WUfXVvMHHlrt7w=;
	h=Date:To:From:Subject:Message-Id; b=ORl24UvhsJZjglEk5j0AEGx6ei+vhTl/JyuNDHOB1/tGbpj1xeGr3+YtAR4DHL2wVw8x04sfgJGzExn5RPhkRnWE+7YlhXh6dXU9mlp61kI6S8mchGaqplpyDsx8B9u/qMkgGUtBfBEDxhiGAR/1fZ/gyLoMp6qSMFchKZI8SIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZdiIDH1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZdiIDH1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857B8C113CC;
	Mon,  6 May 2024 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957133;
	bh=FSQ+91J+vjjQwan1g2S2YrTQ9U4I4WUfXVvMHHlrt7w=;
	h=Date:To:From:Subject:From;
	b=ZdiIDH1ye8cX8+O1ERd0tLaJ6yH8DUh4mJkJ4OYuLgREIJZjR48KBMNFknWxIO7Kf
	 x9qbAkQaq3S1GbCo5wNV4EMt/QD6sQF926V1EDWwNWgdRsdCuQenZAKzAtzycEXZ7I
	 EfP3j5COOTiKVNXSD4x4yRwVB0EjbSm9I0pibI3A=
Date: Sun, 05 May 2024 17:58:53 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-young-page-type-damos-filter.patch removed from -mm tree
Message-Id: <20240506005853.857B8C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document 'young page' type DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-young-page-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document 'young page' type DAMOS filter
Date: Fri, 26 Apr 2024 12:52:44 -0700

Update DAMON design document for the newly added DAMOS filter type, 'young
page'.

Link: https://lkml.kernel.org/r/20240426195247.100306-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-young-page-type-damos-filter
+++ a/Documentation/mm/damon/design.rst
@@ -461,15 +461,17 @@ number of filters for each scheme.  Each
 memory, and whether it should exclude the memory of the type (filter-out), or
 all except the memory of the type (filter-in).
 
-Currently, anonymous page, memory cgroup, address range, and DAMON monitoring
-target type filters are supported by the feature.  Some filter target types
-require additional arguments.  The memory cgroup filter type asks users to
-specify the file path of the memory cgroup for the filter.  The address range
-type asks the start and end addresses of the range.  The DAMON monitoring
-target type asks the index of the target from the context's monitoring targets
-list.  Hence, users can apply specific schemes to only anonymous pages,
-non-anonymous pages, pages of specific cgroups, all pages excluding those of
-specific cgroups, pages in specific address range, pages in specific DAMON
+Currently, anonymous page, memory cgroup, young page, address range, and DAMON
+monitoring target type filters are supported by the feature.  Some filter
+target types require additional arguments.  The memory cgroup filter type asks
+users to specify the file path of the memory cgroup for the filter.  The
+address range type asks the start and end addresses of the range.  The DAMON
+monitoring target type asks the index of the target from the context's
+monitoring targets list.  Hence, users can apply specific schemes to only
+anonymous pages, non-anonymous pages, pages of specific cgroups, all pages
+excluding those of specific cgroups, pages that not accessed after the last
+access check from the scheme, pages that accessed after the last access check
+from the scheme, pages in specific address range, pages in specific DAMON
 monitoring targets, and any combination of those.
 
 To handle filters efficiently, the address range and DAMON monitoring target
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

