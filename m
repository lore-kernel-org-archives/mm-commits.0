Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128DF35A3B6
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100783; cv=none; b=HNe1pPbQBptcPBJhuspAkzBaXJP6Z2uv16tRolyQwVWRBAM+c5yMbhgPrGzoR12LoVgyllHcNcfK7IZrGOWYOcs36lOg6RWZ9tevr+M7l062jkcjmoCfejYCeCs1P++cJA9r6p7Y5iM6sjBBJTFD9QJIwRAavD7ihzW/ZbRhL4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100783; c=relaxed/simple;
	bh=5dUqmTfjYed8Qy58hEo3B902p9Hn3CLEGZbPPkCsMZY=;
	h=Date:To:From:Subject:Message-Id; b=buvakGBTq5n84Vq13Z5P5EEDY0RvowYCAqcRb9PD352oZlfcbMYxyampyTOoC0xtXpE0vYhk5osnQ/1wab4IuSnAfOTRRTD8hI0Du4dGj6BnxhXugYPUVi1pf/yy4fRSM3kSbS2x+ArTg81hDyDxxBKYEZXYCZu/kwO+9m1YKHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UFcn43Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UFcn43Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1930C4CEF7;
	Thu,  2 Apr 2026 03:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100782;
	bh=5dUqmTfjYed8Qy58hEo3B902p9Hn3CLEGZbPPkCsMZY=;
	h=Date:To:From:Subject:From;
	b=UFcn43HvUA8LXzZFhIA6i/o7eSRpybDrJds6ilykXMlVaE4iMplTDtgXaQNFH7fX0
	 OHD3YA83F7mfljUAyxsd4BKbmxxjnqMtU5l97YF31Jmfk361xfkBrgduAcXS83LipB
	 fP+ijQSBpG7JR8wv/L9ad1267o5nMNXsXtcb6Ze4=
Date: Wed, 01 Apr 2026 20:33:02 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch added to mm-unstable branch
Message-Id: <20260402033302.B1930C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: transhuge_stress: skip the test when thp not available
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

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
Subject: selftests/mm: transhuge_stress: skip the test when thp not available
Date: Thu, 2 Apr 2026 09:45:43 +0800

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

Link: https://lkml.kernel.org/r/20260402014543.1671131-7-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <liwang@redhat.com>
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
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

