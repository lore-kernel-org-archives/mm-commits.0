Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033DF1640B
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xWItOnaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E958C433C7;
	Fri, 12 Jan 2024 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705088284;
	bh=j02xpjgrRVBQPAB8YzX98Omp2QldqIJwvtlFv/swZ/s=;
	h=Date:To:From:Subject:From;
	b=xWItOnaIQ3TBwzZURl0I4UdHa8c765JeVbIsJvFkq/etUtbz+3KglBdkJxqSfBOfe
	 oGmEoC5O4b9W+aBpZXRxTNAAI4Ax1/JQiAGbhByDcxkRZ6KdXv2E+yNAdC4nn6EaO8
	 BEoDj/YEzy30VccX0dPQHRF+ZYt01bBdvKsq9euo=
Date: Fri, 12 Jan 2024 11:38:04 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-config-add-missing-configs.patch added to mm-unstable branch
Message-Id: <20240112193804.9E958C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: config: add missing configs
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-config-add-missing-configs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-config-add-missing-configs.patch

This patch will later appear in the mm-unstable branch at
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
Date: Fri, 12 Jan 2024 12:21:40 +0500

Add configurations which are needed for
- hugetlb-read-hwpoison
- ksm_functional_test and ksm_test

Link: https://lkml.kernel.org/r/20240112072144.620098-7-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
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

fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock.patch
selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-ksm_tests-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch

