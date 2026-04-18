Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B137107F
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499096; cv=none; b=am9ia+FwMMAt63U3sutLy5+htl4bI9sYF9be+p8n0DLtGJImeAbxO3+HlLFRhEb/2jw8p83ot8AtB+tdD4ZkSybqMPzk2X+7RTx+GdzHVuLahmCwZP3Y6a3nL8/9kvieMH+6ZPUJRp/2E5fDp84xexCAHS7rND82cGQHqurfkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499096; c=relaxed/simple;
	bh=3rEvlq78sytaPCrIaD4g5MhKHPoJU41GFmqLEd9AXOI=;
	h=Date:To:From:Subject:Message-Id; b=hwzWrGKttxY4YuwPZLyriEspTvcFWnxczY+9RdeuHJmp105xZZ0pBdnrDQZxyBPyh9AhiCUKBLWYi18tvY226dRRnyTwJmSw3u6EgsiMYbOPF0eskfdbKpigbQPsaoSXaKJ+LV8mbyMamudBOt2XIjiyCVAtlZK4QLyLtuADPT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kyRRjRPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kyRRjRPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A90C19424;
	Sat, 18 Apr 2026 07:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499096;
	bh=3rEvlq78sytaPCrIaD4g5MhKHPoJU41GFmqLEd9AXOI=;
	h=Date:To:From:Subject:From;
	b=kyRRjRPyuVDJhAO6R/B/+uunaDHQFe0VtrUx8vhMfk/4OwromVumPK5NdeP/0TlC4
	 5jahu9DugqKAuhCPnEdNp6QdtnJTiNo2gnxz6Y11Epdy/t0PCagW6ysls/GxRCwx6I
	 hXAq20uHPMH0RUtikPbL7YUdhWiytPJRqOd+mTTM=
Date: Sat, 18 Apr 2026 00:58:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,npache@redhat.com,ljs@kernel.org,liwang@redhat.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch removed from -mm tree
Message-Id: <20260418075815.92A90C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: transhuge_stress: skip the test when thp not available
has been removed from the -mm tree.  Its filename was
     selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260402014543.1671131-7-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <liwang@redhat.com>
Cc: Nico Pache <npache@redhat.com>
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


