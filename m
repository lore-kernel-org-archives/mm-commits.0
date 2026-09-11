Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7363DD523
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 23:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789170841; cv=none; b=o2XvxWV0nhVMDR2uyLHRrsumNxk18WJ4fZYDZbR2ill7x2xiX/r5qqlteFC13DTKqjVFUl6QxUlewoeCG0q7RP0a9qsn96PrEdJBCb8pzC8sz/k8lQaSVCY+O1HzU9Ahbn7CE7X6217THSchHXy7+C/FfX86H6MD1GxA8htso08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789170841; c=relaxed/simple;
	bh=fg/K7+JIErlblof3aiqTaNLQlPUzIyA3ZcOzB/WxPN4=;
	h=Date:To:From:Subject:Message-Id; b=RiqD9JoaAfy5f/cRS91YXsT7wCGicALWY9khwUTCCauiMSPX0558k98kZuLCZBHnTWkvE5L/OAEXdPFZDQW+5hOqMtQnnnrwaLbJcoeg84+ZD87m92ilJ3x4bRoKOSevhwwgbl0dJM8DJ8YGKd1nr0DnJ64LS9io87FnOMOFll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5GQ4UtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5GQ4UtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06EE1F000FF;
	Fri, 11 Sep 2026 23:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789170836;
	bh=gegVBcawhsjMV6DqW3tdWFd3Ll2pIeZJH440+MviDew=;
	h=Date:To:From:Subject;
	b=Z5GQ4UtDSFC82RZ/bXrlPMTNjey8yp5o5ATeEU5IjnjXRc14UQkiDW6+3Opt4lgwb
	 ge5XoqG0IUcnbLseyU7WH2yeoui9edBolMJoUyOKmgRauLIDkrOFcn7bfkelO/niqM
	 +r9L9Tb8SuOZ9ADdeH5eEUamIPU0CP8+F9vbNSWM=
Date: Fri, 11 Sep 2026 16:53:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch added to mm-new branch
Message-Id: <20260911235356.C06EE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

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

Assisted-by: LLM
Link: https://lore.kernel.org/20260911124517.63714-1-jaeyeon.lee.dev@gmail.com
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch

