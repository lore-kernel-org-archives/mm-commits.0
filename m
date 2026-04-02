Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CD52C21F4
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100497; cv=none; b=IsiJTE4uh7MJ5c0Xt1FhfpBmA5eDxYHOewoO3mtIbkZcBfGEIwQ2PPcD5yWxaHVBYGn7JPXb3ggeGiQREwrYtb6MlMIsRX+5R64CfAZsEXVYKWpiO4jst5uEfGfTrPOnPpNZoT/EuiW7Klx/FoEB0W2tJbR3xo5RJzJC9hzKseA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100497; c=relaxed/simple;
	bh=l1KU1okqgnuREnPJOujhY9rZ2KQkIphkgBX78InQBCI=;
	h=Date:To:From:Subject:Message-Id; b=IXZk7hQ6cRJrqJDGFWBQe+PZ9tz50YwXYse/abPC3ByUDSzcXru0l7btjF2nrz3ukNaMBjwAt01ymEUzrL+YWWpJs8AjaVKzVvtZFu/QArQLJUl7/wha09uTV0eEVPn9qyl+njzaCAdwon+OBBqe6pWsvbjILKSrnRsmIlh/8Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocXqbcYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocXqbcYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DD2C4CEF7;
	Thu,  2 Apr 2026 03:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100497;
	bh=l1KU1okqgnuREnPJOujhY9rZ2KQkIphkgBX78InQBCI=;
	h=Date:To:From:Subject:From;
	b=ocXqbcYOK3vPmPFVZI27X+WGmvSyC+5tvKYAauZCv1/PmquENa3/+Q/F14TYqREje
	 H4khtpQnonBAtZPQVWLhA7zK+PVgX5q4qSKh/G/QFtlmLQryOPqJqVbUCV7ssFdt0L
	 Z4ZaOYXnZWJAec8xlHfQZYWdTJZbpAFK4wTpS5BI=
Date: Wed, 01 Apr 2026 20:28:16 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch removed from -mm tree
Message-Id: <20260402032816.E2DD2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/guard-regions: skip collapse test when thp not enabled
has been removed from the -mm tree.  Its filename was
     selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Mon, 30 Mar 2026 23:14:57 +0800

Patch series "selftests/mm: skip several tests when thp is not available",
v7.

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative. 
Mark those tests as skip when thp is not available.


This patch (of 7):

When thp is not available, just skip the collape tests to avoid the false
negative.

Without the change, run with a thp disabled kernel:
  ./run_vmtests.sh -t madv_guard -n 1
  <snip/>
  #  RUN           guard_regions.anon.collapse ...
  # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
  # collapse: Test terminated by assertion
  #          FAIL  guard_regions.anon.collapse
  not ok 2 guard_regions.anon.collapse
  <snip/>
  #  RUN           guard_regions.shmem.collapse ...
  # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
  # collapse: Test terminated by assertion
  #          FAIL  guard_regions.shmem.collapse
  not ok 32 guard_regions.shmem.collapse
  <snip/>
  #  RUN           guard_regions.file.collapse ...
  # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
  # collapse: Test terminated by assertion
  #          FAIL  guard_regions.file.collapse
  not ok 62 guard_regions.file.collapse
  <snip/>
  # FAILED: 87 / 90 tests passed.
  # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0

With this change, run with thp disabled kernel:
  ./run_vmtests.sh -t madv_guard -n 1
  <snip/>
  #  RUN           guard_regions.anon.collapse ...
  #      SKIP      Transparent Hugepages not available
  #            OK  guard_regions.anon.collapse
  ok 2 guard_regions.anon.collapse # SKIP Transparent Hugepages not available
  <snip/>
  #  RUN           guard_regions.file.collapse ...
  #      SKIP      Transparent Hugepages not available
  #            OK  guard_regions.file.collapse
  ok 62 guard_regions.file.collapse # SKIP Transparent Hugepages not available
  <snip/>
  #  RUN           guard_regions.shmem.collapse ...
  #      SKIP      Transparent Hugepages not available
  #            OK  guard_regions.shmem.collapse
  ok 32 guard_regions.shmem.collapse # SKIP Transparent Hugepages not available
  <snip/>
  # PASSED: 90 / 90 tests passed.
  # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0

Link: https://lkml.kernel.org/r/20260330151503.670415-1-chuhu@redhat.com
Link: https://lkml.kernel.org/r/20260330151503.670415-2-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/guard-regions.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -21,6 +21,7 @@
 #include <sys/uio.h>
 #include <unistd.h>
 #include "vm_util.h"
+#include "thp_settings.h"
 
 #include "../pidfd/pidfd.h"
 
@@ -2195,6 +2196,9 @@ TEST_F(guard_regions, collapse)
 	char *ptr;
 	int i;
 
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
 	/* Need file to be correct size for tests for non-anon. */
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-ksft_exit_fail_perror-support-printf-style-arguments.patch
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

