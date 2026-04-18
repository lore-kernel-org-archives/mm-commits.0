Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6D434E744
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499065; cv=none; b=LS5olbI2g3RpRh21Oi5RQMCNGda8XhnyLUUfuG87xb9zwz+3auwKc2VnP8Pe4cBLfLpzJsq42mvcXDCQXjIAuCzjLxvuyr0PuVy3Q1Tax1CHP0AyCXweObfT17hgw5cLDAyVB2qwphmawJG9fIbob7zx8KDkZSSzSU2vXmKH2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499065; c=relaxed/simple;
	bh=qXSSpn+KKN/bPn2/aTVCprFgnJiynxO4RDejgdVkPuY=;
	h=Date:To:From:Subject:Message-Id; b=ZknR8pzHW1ap2GWuCu5BeLyY4Rpjs8siHKywu39vtXxA0rF07xI/MJ0KyaDRJqEFxicfXHa40riUQQUr0KOCtMVPTlrLAc+RkvNazovGTpIsraaOrWcLXmpGoxhgvJeen7ju63WZoRWhB0VntAwKXI4vu6aQN0rwUaoYQIM4/kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c3vDaqDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c3vDaqDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14BCC19424;
	Sat, 18 Apr 2026 07:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499065;
	bh=qXSSpn+KKN/bPn2/aTVCprFgnJiynxO4RDejgdVkPuY=;
	h=Date:To:From:Subject:From;
	b=c3vDaqDPda3JaMXse5BjL5gdnOeTv8oCmoaBxuvXb1bluZWWL4eORtl8LOfEPJ3JY
	 yhBWyrKy21qKTgCFxnOJXesOUMvo3I4eTNGb8YUHVX3/UNjj6RuuqFB1aLLqfOWoHM
	 VGnZQgm7sf5MsgYKGB4dlht6x/oFGJx9uwVTJv9k=
Date: Sat, 18 Apr 2026 00:57:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,npache@redhat.com,ljs@kernel.org,liwang@redhat.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch removed from -mm tree
Message-Id: <20260418075744.B14BCC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/guard-regions: skip collapse test when thp not enabled
has been removed from the -mm tree.  Its filename was
     selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm/guard-regions: skip collapse test when thp not enabled
Date: Thu, 2 Apr 2026 09:45:38 +0800

Patch series "selftests/mm: skip several tests when thp is not available",
v8.

There are several tests requires transprarent hugepages, when run on thp
disabled kernel such as realtime kernel, there will be false negative. 
Mark those tests as skip when thp is not available.


This patch (of 6):

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

Link: https://lore.kernel.org/20260402014543.1671131-1-chuhu@redhat.com
Link: https://lore.kernel.org/20260402014543.1671131-2-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Cc: Nico Pache <npache@redhat.com>
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


