Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4781B40DB38
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050005; cv=none; b=GedBx5MW6ldnRzhjh1THUd0XcKk5Te+BXzKVx1sx5NJaPfqHOsNeBMXZP8a2pzRy36ufFqI1ZHBKTI9Lk2jKRj+c4T/HGxBytCUu87SKoUKwWgg/2GgfVkN8HZw/CI7imd3NLXECLoauwpnryphrs6pwN5jaLv8eCzJPWeLgGCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050005; c=relaxed/simple;
	bh=EzN1RwR4DfnxgKKEt1IS4oFgBejajTO4nd/WxcFEf5M=;
	h=Date:To:From:Subject:Message-Id; b=fqUu6DEEd3TXOp4vdga26BXbUJ5ueib9De1ZeeHIMqqpVtyPU4eg1Eyan15DQ3nBno3Z0yX7zx8zHUENED6LEkHzuZGEHNM+RQsqUw+n0/YlGd0i/e1sT0YKhELWFwpOacjrLc6WIfWWdyFaYmiw12YArfu9+eZukR++pFDg12U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eXtOA07N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eXtOA07N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCCD1F000E9;
	Thu,  6 Aug 2026 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786050003;
	bh=agWCM/dnp0tu4lY67zz9Ch36xWVY9h79IJMy7dfvLYc=;
	h=Date:To:From:Subject;
	b=eXtOA07NvB+wVeNlszn5+J4ciYYmbxknTjdnhEPHPet4vy6NpRymqJyx6GGHykoS6
	 FjpqgKUJI8STDedMfBHUuQ4iuOvL3IMUbS32oU0NudbB5Wb+fm8FzaYGTcffVdjR7p
	 htMwkn9aXQSsd6+4Lp1wEOiK2Wqb24iKkuDNe20A=
Date: Thu, 06 Aug 2026 14:00:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch added to mm-new branch
Message-Id: <20260806210003.7FCCD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch

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
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Mon, 27 Jul 2026 10:52:17 +0100

Patch series "selftests/mm: Handle unsupported and transient test
conditions", v3.

Several MM selftests report failures when the test environment lacks
an underlying prerequisite, such as fallocate() support, MADV_REMOVE,
local page-cache semantics, or swap.

This series converts those unsupported cases to SKIP while preserving
failures for unexpected errors. It also allows migration tests to retry
transient move_pages() failures.


This patch (of 5):

The tmpfile-backed COW cases allocate a one-page file with fallocate()
before exercising private and shared mappings.  When the filesystem
backing tmpfile() does not implement fallocate(), setup fails with
EOPNOTSUPP and no COW behavior is exercised.

This occurs when the temporary directory resides on a filesystem with
limited allocation support, such as NFSv3.  Reporting a failure adds noise
because the test prerequisite is absent rather than the COW implementation
being broken.

Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
error as a failure so unexpected setup regressions remain visible.

Link: https://lore.kernel.org/20260727095225.372655-1-usama.anjum@arm.com
Link: https://lore.kernel.org/20260727095225.372655-2-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported
+++ a/tools/testing/selftests/mm/cow.c
@@ -1718,8 +1718,13 @@ static void run_with_tmpfile(non_anon_te
 
 	/* File consists of a single page filled with zeroes. */
 	if (fallocate(fd, 0, 0, pagesize)) {
-		ksft_perror("fallocate() failed");
-		log_test_result(KSFT_FAIL);
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			log_test_result(KSFT_SKIP);
+		} else {
+			ksft_perror("fallocate() failed");
+			log_test_result(KSFT_FAIL);
+		}
 		goto close;
 	}
 
_

Patches currently in -mm which might be from usama.anjum@arm.com are

selftests-mm-unpoison-pages-in-memory-failure-teardown.patch
selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch
selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch
selftests-mm-skip-khugepaged-swap-tests-without-swap.patch
selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch
selftests-mm-retry-migration-failures-for-the-full-runtime.patch

