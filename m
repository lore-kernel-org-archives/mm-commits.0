Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19686351C03
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100505; cv=none; b=CjE71zV6I2DV8A59UZ+85fAcNgKMT2AhZlerPQdSVQHnhyJv2t14YU0WgUeJ5rKFxWWJsII76MrmNJ6YRHuxo2fzg+KKUU0RaEz9IoEufVGoQmGBtY3ydltpYeGGPBjQm0mh700vP+UscpgLCuqZ2wp9gKIGpFc+uFx2sGZDM8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100505; c=relaxed/simple;
	bh=/iQUUzPAn6kqukbTFr/zaSChA5sa2+5EbFLo1MjtY+U=;
	h=Date:To:From:Subject:Message-Id; b=EnfxNIJJCBdQ7Cjx2oSYU1EvTNh7NqqNmm0l5WqhiXY1S2qLmikpXeaQloqhax9Mp2bkgFRsHXmJQH13UuBe2OjpuvCR0hmRc2IVrVljKpUghio2MmM5CvVAh9xWb76LR2q7/VMMGnPC3ySz8OrWd8FKRDeA/4kgBvHzC683Ovk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQ21WaWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQ21WaWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BEBC4CEF7;
	Thu,  2 Apr 2026 03:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100504;
	bh=/iQUUzPAn6kqukbTFr/zaSChA5sa2+5EbFLo1MjtY+U=;
	h=Date:To:From:Subject:From;
	b=LQ21WaWftvjLth2BmD9kyo7OOjT0BoAQw0FSnbof5jPOk+qird4ZRqQsIMj8pf+j/
	 Uj46iFtDbsb9oqPpZ9jH+9JkK24W90QMcx/gfR3kLWqesD2UjjZxDMFrLbdJJuHRyC
	 mDSEoAsn9BLa5Xggf8V+mheIljeYplbAWdtlq1PI=
Date: Wed, 01 Apr 2026 20:28:24 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch removed from -mm tree
Message-Id: <20260402032824.A0BEBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: split_huge_page_test: skip the test when thp is not available
has been removed from the -mm tree.  Its filename was
     selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Mon, 30 Mar 2026 23:15:02 +0800

When thp is not enabled on some kernel config such as realtime kernel, the
test will report failure. Fix the false positive by skipping the test
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

Link: https://lkml.kernel.org/r/20260330151503.670415-7-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <liwang@redhat.com>
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

selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

