Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138BE347BC9
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 20:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773953824; cv=none; b=KfT1z5dzJDY8RfwFIUHs6KiOooeWjF2JWm7WzQdWtCF4troEnUQQr6ZqsrL76J1q5FPdwBOecY2NRiPkK39S5TDtUd65ybatLv25uUT2oMs+Hs4XZMXbBlrlfLpmmBOWyavYSQYYSkAnGOz1HR7TJ8pKYYtv8viImI4R+n/HsJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773953824; c=relaxed/simple;
	bh=/eER3KCkgjI8TIxrnKN6tNN+6lBND9PtXymHmsr8BBU=;
	h=Date:To:From:Subject:Message-Id; b=HJwmjXSO8VioeuOgPb4upIrhW5kBRR1EbP7u1A/vgj7UdzIBRLxnel9KliQ/cSuL5Bp2ywR2waxgn8xMg3qac+G+oi50a3t9DD7Sk00y3NA2TN82iYq9q7nzUgL+INdz13HMaTZPPjKaLybG8fpDYmYXA/lYXso4qDfINO+6I0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L7PTfagb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L7PTfagb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E657C19424;
	Thu, 19 Mar 2026 20:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773953823;
	bh=/eER3KCkgjI8TIxrnKN6tNN+6lBND9PtXymHmsr8BBU=;
	h=Date:To:From:Subject:From;
	b=L7PTfagbjGh4h9Y2hSC1Wq1db0li0u96+e7/YzDsX1NpNsZG/aQQdgVu6YUOYyfW/
	 yxZ/SJNBL2M3ChryV7rZMjSoLPl0Cfr9/jh30s9YBia6hZKgNLoHZWD1DQ1+DZbULo
	 roFPR2Bve4JIYFbNWvVkrJjCaZtx6KMj3UDfB46s=
Date: Thu, 19 Mar 2026 13:57:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liwang@redhat.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch added to mm-new branch
Message-Id: <20260319205703.9E657C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: split_huge_page_test: skip the test when thp is not available
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch

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
Subject: selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Fri, 20 Mar 2026 00:06:55 +0800

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

Link: https://lkml.kernel.org/r/20260319160656.1480279-5-chuhu@redhat.com
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
@@ -760,6 +761,9 @@ int main(int argc, char **argv)
 		ksft_finished();
 	}
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch
selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

