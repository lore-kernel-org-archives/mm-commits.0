Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311AA395D8E
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774898435; cv=none; b=crT/+J8wpz5qK3GCdoZ0cy71qz0rWGvs4UDG/OvuVxecrxYyIRIEpm0Ce8MUOoXl/W0cowr4ok8Kg0lPgoY01gGcG2BZfuxUAOcXvGtwUbEa1BdQJblcdIg9Ay85FAzM8YDdPMc7r5DdTilnJU0MziMTtIhjCnNkNmhQXMlIwAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774898435; c=relaxed/simple;
	bh=OiMS5eurHAQJ50JStWGsxc8CGvJ12UkbExtxhDDqtZA=;
	h=Date:To:From:Subject:Message-Id; b=tsouodeOfHxX7uUs3/n7Yr5a+7+zZQN1llVy7/1/01q73q/QW0IRS8346uu07hdLpM972QQOFyE7xCcumdmGURGnnbO3x57JmmC0PxLKSJuykCaJVzbNfsCRuUJeRIiqE+iKwRjDKVGg/2RjVxuZjfUaYymCSsleACSlAwkpJ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UyWaEcrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UyWaEcrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DD6C2BCB1;
	Mon, 30 Mar 2026 19:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898435;
	bh=OiMS5eurHAQJ50JStWGsxc8CGvJ12UkbExtxhDDqtZA=;
	h=Date:To:From:Subject:From;
	b=UyWaEcrU1zddZ4/K6sZwGdIoVJc+N3T/bEzdfdXpxeTF+KpxaQdePxZbL/pPL3+X6
	 xG/VGLuWTbhbLyUr+XR0CV4weX2deplw/aQZarR5qSUrRIMCbflfsy2Yh5eCRaHP7j
	 mM1VFGLM4fqgXuXH5DlMS1OOH/9SqzfRp+vkeJR4=
Date: Mon, 30 Mar 2026 12:20:34 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch removed from -mm tree
Message-Id: <20260330192034.E8DD6C2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: soft-dirty: skip two tests when thp is not available
has been removed from the -mm tree.  Its filename was
     selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Tue, 24 Mar 2026 09:33:12 +0800

The test_hugepage test contain two sub tests. If just reporting one skip
when thp not available, there will be error in the log because the test
count don't match the test plan. Change to skip two tests by running the
ksft_test_result_skip twice in this case.

Without the fix (run test on thp disabled kernel):
  ./run_vmtests.sh -t soft_dirty
  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..19
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # ok 4 # SKIP Transparent Hugepages not available
  # ok 5 Test test_mprotect-anon dirty bit of new written page
  # ok 6 Test test_mprotect-anon soft-dirty clear after clear_refs
  # ok 7 Test test_mprotect-anon soft-dirty clear after marking RO
  # ok 8 Test test_mprotect-anon soft-dirty clear after marking RW
  # ok 9 Test test_mprotect-anon soft-dirty after rewritten
  # ok 10 Test test_mprotect-file dirty bit of new written page
  # ok 11 Test test_mprotect-file soft-dirty clear after clear_refs
  # ok 12 Test test_mprotect-file soft-dirty clear after marking RO
  # ok 13 Test test_mprotect-file soft-dirty clear after marking RW
  # ok 14 Test test_mprotect-file soft-dirty after rewritten
  # ok 15 Test test_merge-anon soft-dirty after remap merge 1st pg
  # ok 16 Test test_merge-anon soft-dirty after remap merge 2nd pg
  # ok 17 Test test_merge-anon soft-dirty after mprotect merge 1st pg
  # ok 18 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
  # # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Planned tests != run tests (19 != 18)
  # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:1 error:0
  # [FAIL]
  not ok 52 soft-dirty # exit=1

With the fix (run test on thp disabled kernel):
  ./run_vmtests.sh -t soft_dirty
  # --------------------
  # running ./soft-dirty
  # TAP version 13
  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..19
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # # Transparent Hugepages not available
  # ok 4 # SKIP Test test_hugepage huge page allocation
  # ok 5 # SKIP Test test_hugepage huge page dirty bit
  # ok 6 Test test_mprotect-anon dirty bit of new written page
  # ok 7 Test test_mprotect-anon soft-dirty clear after clear_refs
  # ok 8 Test test_mprotect-anon soft-dirty clear after marking RO
  # ok 9 Test test_mprotect-anon soft-dirty clear after marking RW
  # ok 10 Test test_mprotect-anon soft-dirty after rewritten
  # ok 11 Test test_mprotect-file dirty bit of new written page
  # ok 12 Test test_mprotect-file soft-dirty clear after clear_refs
  # ok 13 Test test_mprotect-file soft-dirty clear after marking RO
  # ok 14 Test test_mprotect-file soft-dirty clear after marking RW
  # ok 15 Test test_mprotect-file soft-dirty after rewritten
  # ok 16 Test test_merge-anon soft-dirty after remap merge 1st pg
  # ok 17 Test test_merge-anon soft-dirty after remap merge 2nd pg
  # ok 18 Test test_merge-anon soft-dirty after mprotect merge 1st pg
  # ok 19 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
  # # 2 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:2 error:0
  # [PASS]
  ok 1 soft-dirty
  hwpoison_inject
  # SUMMARY: PASS=1 SKIP=0 FAIL=0
  1..1

Link: https://lkml.kernel.org/r/20260324013316.2590422-3-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 tools/testing/selftests/mm/soft-dirty.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -82,7 +82,9 @@ static void test_hugepage(int pagemap_fd
 	int i, ret;
 
 	if (!thp_is_enabled()) {
-		ksft_test_result_skip("Transparent Hugepages not available\n");
+		ksft_print_msg("Transparent Hugepages not available\n");
+		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
+		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
 		return;
 	}
 
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

