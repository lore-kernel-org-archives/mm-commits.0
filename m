Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F0C30F95F
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100780; cv=none; b=Z4WQPbx9WMZLH4UCfMKICwdS6SvkQT3+mH/LbSWlRuagE95RzmNx5jlk1QAokMM9enp7qnEk4a1CIRdXJKAuMBLnQ2dtjDUWYviXlpwcSpQO6lHNOiDq1nDDrJMp9l5qocEc8HDFmM8VQCh2aEEjTOSea+Pxns3wOdOwmi+Y7eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100780; c=relaxed/simple;
	bh=KeU6jiOdyjByH56taQAiE+TGoNkBWTGmzGox1nt+Jeo=;
	h=Date:To:From:Subject:Message-Id; b=Oj5BWgcBwCxM22bu0ZRsZXFCi9rZs7dVN5IA5LyjAvmMQx0LZ7xGTJ5ZMUXYbz5CeUxBY84aG1RKP7NKPOCpRUmBlyzVa1Q3HdvPqkgQgTp+Xchey6y5E2fCag1SKtY1FK1dIqJp3zdFDsRLxuAHk/cYVdjDr+LKOWfBFI7z7Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YRSeBBN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YRSeBBN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C63C4CEF7;
	Thu,  2 Apr 2026 03:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100780;
	bh=KeU6jiOdyjByH56taQAiE+TGoNkBWTGmzGox1nt+Jeo=;
	h=Date:To:From:Subject:From;
	b=YRSeBBN5w10vqr9REE6A+z4ygYDAV4toRhWAbwAt14cn5dBl5r4jEsjXdbpDo/7hY
	 1TsZlVuK++GCnpi+ClpAJef8lHJuS17qFCVShVuD3ihIzIzER/4Gs9JS9kwfU5Y2p7
	 SxKU9XCop1EzV396ODLvRGCsAfCGTtkf305mmDbE=
Date: Wed, 01 Apr 2026 20:33:00 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch added to mm-unstable branch
Message-Id: <20260402033300.A0C63C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: split_huge_page_test: skip the test when thp is not available
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Thu, 2 Apr 2026 09:45:42 +0800

When thp is not enabled on some kernel config such as realtime kernel, the
test will report failure.  Fix the false positive by skipping the test
directly when thp is not enabled.

Tested with thp disabled kernel:
Before The fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
  # --------------------------------------------------
  # TAP version 13
  # Bail out! Reading PMD pagesize failed
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1

After the fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
  # --------------------------------------------------
  # TAP version 13
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP

Link: https://lkml.kernel.org/r/20260402014543.1671131-6-chuhu@redhat.com
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,6 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
@@ -757,6 +758,9 @@ int main(int argc, char **argv)
 		ksft_finished();
 	}
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch
selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

