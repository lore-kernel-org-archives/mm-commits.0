Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA72A38DC72
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790404320; cv=none; b=cUTuIZm7jQpd0tPklH6O3H1xfPn1ufxRN5/vc+ETFOf2ZTS/h3OdJuOqA8qmplNvLQmLpPms3zTP+m1B6dw0zKGlV414/ni0vVomBJC6ksT5UhMr5hO15IT+/pZAwRIv7ivR92JjqYhKRdcN+whaAeCTiQYQgGS6vvEBh8B34uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790404320; c=relaxed/simple;
	bh=hNhW88o+F8PRtFFchopFm8ENx79v515HWBvKZtXlBm4=;
	h=Date:To:From:Subject:Message-Id; b=DvUBWNvnTDXSE+C+7UJOgjGFF4tuRKeb8vVk+PXoCqs4qpR4PsubzecW5aLx+E6OCxX/hot85ZN9+pXwnp1OvHCkOtNbcfLJbOwSTFTSpZ7CDdeNHFuQYhzl5yGu/PPscS3LTb3no69E00hsN5yvndMTCDXta6C0b2VhJRDfzHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k9HVTlHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k9HVTlHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FF61F000FF;
	Sat, 26 Sep 2026 06:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790404317;
	bh=TMm4DR9X00DVTZcNLlavpME9NT50rihusZlUmh2xnls=;
	h=Date:To:From:Subject;
	b=k9HVTlHusq+gI+sBsZ/9FI+r+971O4o0dGVvh6QyTMAhDlK+79MMMj8eYqC8oCCUy
	 TiB/H+MWTF1aukMm6MqS7/qEeADxlGXgoSsQioBbw+NKh8RExHU1yVW7MfDRoRtEn+
	 pFgijWp3CW1RKXHSFfeSsseaC9s3DddoYtC4GO+0=
Date: Fri, 25 Sep 2026 23:31:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch removed from -mm tree
Message-Id: <20260926063157.41FF61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
Date: Fri, 11 Sep 2026 14:45:17 +0200

The XFS setup for ./khugepaged all:file checks that the kernel supports
XFS but not that mkfs.xfs is installed.  When CONFIG_XFS_FS=y and xfsprogs
is missing, mkfs.xfs and mount both fail, but
SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set. 
The test then runs against plain tmpfs and six subtests fail.

The script already has a skip path for this test, but it never runs
because the path variable is always set.  Check that mkfs.xfs exists
before attempting the XFS setup.

Link: https://lore.kernel.org/20260911124517.63714-1-jaeyeon.lee.dev@gmail.com
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -433,7 +433,8 @@ CATEGORY="thp" run_test ./khugepaged -c
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-	if grep xfs /proc/filesystems &>/dev/null; then
+	if grep xfs /proc/filesystems &>/dev/null &&
+	   command -v mkfs.xfs &>/dev/null; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
 	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch

