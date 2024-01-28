Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D166214263
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430789; cv=none; b=jpnV6QgnBTFX7yCF5gvfryuB1Jb2fwyEkeNgBHMy10QuRN+VtL7X91idetCQdMvGdcSJI7JBZmGUEg5H2jxGc3HvXMt9TLvbqVdP+Z4YjfyF9y4kDVSxWNJmUMm4cOAeLhl33PWWNOdFnlluT+bWaz4gZdSq93yr0ynQuNP2lE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430789; c=relaxed/simple;
	bh=d9qaeZfqblsT9c0kAKFTWBdlxJM8APNkWOA4lLftC+I=;
	h=Date:To:From:Subject:Message-Id; b=HVLawpnQs0FHpo0gQRMOyb65Z4vzDv77DgbueOI/aUbyFSdp7yEV1LvvlWv2o4sSrGthCtMll3zwZvVxc08pa+ZPLnhI93xZoI3o7v4CqN/w0oU3CS38wROsmNyEm1Ix8JLqcs8N57CWakNT4hmA6bBdv+K22g9Cm1VsYwhu6T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jd2GyRm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jd2GyRm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00A4C43399;
	Sun, 28 Jan 2024 08:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430789;
	bh=d9qaeZfqblsT9c0kAKFTWBdlxJM8APNkWOA4lLftC+I=;
	h=Date:To:From:Subject:From;
	b=Jd2GyRm6gCBNivFxHvHGB5vHiwBwHSMjo1TJwp9X/YzR713YO8bQw14PwEugjaTQp
	 OJ5YIQKKXXi/1w2oJwjsnl7O5Isio9sI+RLegTi3eFm7+o0Ab8xNBZCkcXj8ek0H0n
	 zC1JbBaU8EszNfzw91FN3Fo4pfmkRRc1qvGQaMks=
Date: Sun, 28 Jan 2024 00:33:06 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,jiaqiyan@google.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-config-add-missing-configs.patch added to mm-nonmm-unstable branch
Message-Id: <20240128083308.D00A4C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: config: add missing configs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-config-add-missing-configs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-config-add-missing-configs.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: config: add missing configs
Date: Fri, 26 Jan 2024 16:21:26 +0500

Add configurations which are needed for
- hugetlb-read-hwpoison
- ksm_functional_test and ksm_test

Link: https://lkml.kernel.org/r/20240126112129.1480265-7-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/config |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/config~selftests-mm-config-add-missing-configs
+++ a/tools/testing/selftests/mm/config
@@ -7,3 +7,6 @@ CONFIG_TEST_HMM=m
 CONFIG_GUP_TEST=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_MEM_SOFT_DIRTY=y
+CONFIG_MEMORY_FAILURE=y
+CONFIG_HWPOISON_INJECT=y
+CONFIG_KSM=y
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-ksm_tests-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

