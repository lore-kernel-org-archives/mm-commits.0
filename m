Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481B33F8817
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 20:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773953826; cv=none; b=O0+Tc1Jf/nQvUN2IU42kIloluk06VyQQwRBdQrYd3fZCeLuqK4nBhNealoIMHbbV7t0kXQM2sAtLKWRLTZHWLJlFXw7TOKT2phmhoYCUcSPImdkGYKiiHxGot1pclzhQKNKpHvyB5On69GZo6H3Arfhl+pLDjtdYY03QPj77LNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773953826; c=relaxed/simple;
	bh=xD3tmCN6gdVgfnaM+oq1zhMacKNfUfJw3fDEuwgu6lo=;
	h=Date:To:From:Subject:Message-Id; b=j2eVQb82m0sSOesyRfzsK1amuXU3mzEReP9OXhiPLmsfrm5KI8t1iTkJCd3VUui+/lu/X9UYpnEwWWh6wiH++rWzlSpIZbOlMwPXFrxxUAXAKclQa6i060jdGZc/LM3RPb3Kxoj7ZHm2K9GkuMqrqRFIrzR2xH5zTzt0HEcQkog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UfzpVmIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UfzpVmIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DD0C2BCAF;
	Thu, 19 Mar 2026 20:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773953825;
	bh=xD3tmCN6gdVgfnaM+oq1zhMacKNfUfJw3fDEuwgu6lo=;
	h=Date:To:From:Subject:From;
	b=UfzpVmIKDt4ipozctQN/O2qp3DT7L2/K98JxdPYWhWTrqQVgrExjkYeMTfbRRxd1H
	 1xbXA1NvOTWGltErkPvdeLyy4H2obaHlRAgAdJLV+sjeoYOflx+frtb4ELdUrxxYkK
	 n/W3F6dW3b+OnDRv8vhRKVmJ3dTPyme8bWKBtmMs=
Date: Thu, 19 Mar 2026 13:57:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liwang@redhat.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch added to mm-new branch
Message-Id: <20260319205705.D0DD0C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: transhuge_stress: skip the test when thp not available
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: transhuge_stress: skip the test when thp not available
Date: Fri, 20 Mar 2026 00:06:56 +0800

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

Link: https://lkml.kernel.org/r/20260319160656.1480279-6-chuhu@redhat.com
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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch
selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

