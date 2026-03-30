Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657D72E7F39
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898441; cv=none; b=sDL9juWxVo8Ac4hOxcVhxnHkCCgynDiD8roevHzle6DjH1D7e23ewEM+BMwEODEl/62EgJO9gtOlSu20k9q4qtejc31SuPbzIlztuauvJzzSJ50vqBREleHrqJd4kHhH9cYzUwGr5MFavp6xin8cLerwEF5TH0Q321XyXHFBxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898441; c=relaxed/simple;
	bh=PglRFchJaJgEnyASPVvTYsayC3zZf3WMuBAu2S332vs=;
	h=Date:To:From:Subject:Message-Id; b=AytHTM6VgYeCJTIDoUze4gFHUy311nZytOTZ8uwyGAAhlj3PIBUtTc8QETZxdsDaKlxAgmiZt1SsUtb8GvSyEUhrcYYsDCmD+all7RBKTujf8DFUjFLw4st7YUtwDOMnz5clzm6DUrkCinXqAcUyer7isDOGpawJCd3D4yVdcDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKuH3bAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKuH3bAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082C2C4CEF7;
	Mon, 30 Mar 2026 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898441;
	bh=PglRFchJaJgEnyASPVvTYsayC3zZf3WMuBAu2S332vs=;
	h=Date:To:From:Subject:From;
	b=RKuH3bAnof3t2d8hwKYY9lfBM089IXbG+yLLInny3wweAdPIp1Q9qwa28yNf1E4QG
	 du1Q1+cjmEVhJOXP1/e2acF2fJrR7nNAHdfxCqWrFBQMm9E2fUrysP8ULk5eTOYi0f
	 tgm0UW2u9y7j9bwVfgEzI5IutD4OEfmMu2ZWdlQQ=
Date: Mon, 30 Mar 2026 12:20:40 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch removed from -mm tree
Message-Id: <20260330192041.082C2C4CEF7@smtp.kernel.org>
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
Date: Tue, 24 Mar 2026 09:33:15 +0800

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

Link: https://lkml.kernel.org/r/20260324013316.2590422-6-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

