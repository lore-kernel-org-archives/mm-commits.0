Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0212E7F39
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898443; cv=none; b=XSOhji11DcRrznI/LExwCaHyiPwzzqlF3FUluUFYRGAgDsUvrKPi74vTihDuWSFuc4Idt53iLm8PtusURIRrmHcKHOl/nqgwAKGcKhpQXgM4sHrF9VljDEz2ErMnCeKox4PhiJ2DuSbPU+V1WJetb1vXDLXtbes4TSRJFdN75x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898443; c=relaxed/simple;
	bh=/487eY9k7zKgHEUydZvCVV2vHS4dVm1r6WLJLfvMcwM=;
	h=Date:To:From:Subject:Message-Id; b=l23vYY23DqJZeWfU8aRee+kb/v0dKWWK2sSAxZXQ2zqlvBvuGkDIS2sC4P7YpaxLxcDsWBUItLyM76MK1pGlNSpAvpjQrFpKakdtCJtOFnax3ExT0J136MBqxaDOcvKzDoLQih7CQYjqn6Pmdc3tZHKEWy5etY8K5ftvKHQXBsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VSGSg3kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VSGSg3kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F19C4CEF7;
	Mon, 30 Mar 2026 19:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898442;
	bh=/487eY9k7zKgHEUydZvCVV2vHS4dVm1r6WLJLfvMcwM=;
	h=Date:To:From:Subject:From;
	b=VSGSg3kvoPi+c9mZOwOlwGipsRI+QHlFhKXyX3aH5BMKgiOb87MYaamth88w7qa6I
	 d9QkwJ8xQ1M+Jk+PhfBuoZvTDqTkeNPyY/a6s1EHKTBfNyPeKYBLvOlTGJxKQGaxqM
	 EDg1nMNmH89srBRh68T1tyqM25VtuLVB++1FqxB0=
Date: Mon, 30 Mar 2026 12:20:42 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch removed from -mm tree
Message-Id: <20260330192042.C4F19C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: transhuge_stress: skip the test when thp not available
has been removed from the -mm tree.  Its filename was
     selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: transhuge_stress: skip the test when thp not available
Date: Tue, 24 Mar 2026 09:33:16 +0800

The test requires thp, skip the test when thp is not available to avoid
false positive.

Tested with thp disabled kernel.
Before the fix:
  # --------------------------------
  # running ./transhuge-stress -d 20
  # --------------------------------
  # TAP version 13
  # 1..1
  # transhuge-stress: allocate 1453 transhuge pages, using 2907 MiB virtual memory and 11 MiB of ram
  # Bail out! MADV_HUGEPAGE# Planned tests != run tests (1 != 0)
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 60 transhuge-stress -d 20 # exit=1

After the fix:
  # --------------------------------
  # running ./transhuge-stress -d 20
  # --------------------------------
  # TAP version 13
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 5 transhuge-stress -d 20 # SKIP

Link: https://lkml.kernel.org/r/20260324013316.2590422-7-chuhu@redhat.com
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

 tools/testing/selftests/mm/transhuge-stress.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/transhuge-stress.c~selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available
+++ a/tools/testing/selftests/mm/transhuge-stress.c
@@ -17,6 +17,7 @@
 #include <sys/mman.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
@@ -37,6 +38,9 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	ram = sysconf(_SC_PHYS_PAGES);
 	if (ram > SIZE_MAX / psize() / 4)
 		ram = SIZE_MAX / 4;
_

Patches currently in -mm which might be from chuhu@redhat.com are


