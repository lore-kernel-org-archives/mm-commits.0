Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCCF3563DD
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100506; cv=none; b=Nzkgd/mCrbznxNneqBnXJlIUJ9gvbKA5evLntGiULZkmFQ0+on2y4N2n2cU6qeC/0To7g2Fu2zeP7It/05o0Q5B5S4hUrz8yoTG0Hms/FVRD+MukgxXjoCf6PgwvwazCmhQDQSfy5hnemLmx0ngs1uVGVKQBRUpzNXCslwbAqFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100506; c=relaxed/simple;
	bh=46Shy62JHuXwgKGsEI4e7O50xrEFvI+aQwdiU0eRSaE=;
	h=Date:To:From:Subject:Message-Id; b=bKUw5fsXv404BoxvWPMwI3p8zvuJs7/dOJkSG+YIMt3MqmnR50RAgMGcrkSNJ8LZogNlzJbWj5lqtLJBsNivFfHvA9PLjkbnrVix2AUTX85ZIm58N9sRc/7f5QMMd1VNV7Dt2qSRfhVGOTZCEFO25yPuUgPH/uMDb9/Gh9/abG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AZipVEBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AZipVEBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524F9C4CEF7;
	Thu,  2 Apr 2026 03:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100506;
	bh=46Shy62JHuXwgKGsEI4e7O50xrEFvI+aQwdiU0eRSaE=;
	h=Date:To:From:Subject:From;
	b=AZipVEBoC150q0Ou3JMzZdrN/ZLzaOziG/4njfeDvHM+eqPTD+jd6f8v4jW7fOT98
	 h+eRGWdO1zJcKBXweR823CRLb/2cjxaf9ezHOTZjYDRFXRbLXpaL5w+ZTTy1Lctqmz
	 wPAUAGNTce/LBDd3/GI3aHrl9yOZEf1/YdAYjykU=
Date: Wed, 01 Apr 2026 20:28:25 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch removed from -mm tree
Message-Id: <20260402032826.524F9C4CEF7@smtp.kernel.org>
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
Date: Mon, 30 Mar 2026 23:15:03 +0800

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

Link: https://lkml.kernel.org/r/20260330151503.670415-8-chuhu@redhat.com
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


