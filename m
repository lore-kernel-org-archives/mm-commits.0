Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD25B34E744
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499090; cv=none; b=kx8bjU+Ri77eNaHZF0S8RVnaeCId97vGjNhaPK3Ycs9kZMocFaM6cPvuPRePcASCN8FDbyX94kP4BGOL/Kl2w5EOxKsroaYvACyW0nPH2qpTKz+32vNsf/tH+jr2Bgi51Nv4xnGRXPUAiui4+b97lei6qxaddmFbr3B+HOL2c2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499090; c=relaxed/simple;
	bh=myu3H6sV6PQLMYsqeuafg4ISkMKl5IoDXRgKmjHjgYw=;
	h=Date:To:From:Subject:Message-Id; b=YVsVhPYXfVRPrnllm/tV5opcIgf0g9T9zsaxfJ8VA83tVGhiuETcjIHHVg/9CcAgTI2VVYh3AiJgWGsPzCdB7Lzpvqu2AuXXGCC3bmQEr/M+cvU6j1V2OPY1nHurqYSZaXj7JD3a/1ZoMQ/wTMsfFkUXD7NpY3YwRlntbkt6Jc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gyL8mygk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gyL8mygk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC64C19424;
	Sat, 18 Apr 2026 07:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499090;
	bh=myu3H6sV6PQLMYsqeuafg4ISkMKl5IoDXRgKmjHjgYw=;
	h=Date:To:From:Subject:From;
	b=gyL8mygkyLBMqEp8D7MvoMU0tO5qENYXBLMTx/LUsrd0MFdMdux6OTJVnXqkAXds6
	 KbckSosxSETyvX4azZnQZZJHMXuNNfqxL1tY88E09cpuk+EK/6a95uQYc5szSSr9V2
	 6dVXJhc+Vk75Gh5y+LmrT5vKLkAUkdqUWFLvJCtc=
Date: Sat, 18 Apr 2026 00:58:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,npache@redhat.com,ljs@kernel.org,liwang@redhat.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch removed from -mm tree
Message-Id: <20260418075809.9FC64C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: split_huge_page_test: skip the test when thp is not available
has been removed from the -mm tree.  Its filename was
     selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260402014543.1671131-6-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Nico Pache <npache@redhat.com>
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


