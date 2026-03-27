Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2423FA5E1
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634353; cv=none; b=q2IKjXkaaxVEOMm/SYOuAUOtiorY046G6nijdaNqIvdeCts3hapWqupCjvD1+mUFGQPbDtBpVFnl23Zpjy/Di2QH1h6EDxfyshJS6nUAeb8Sp0WKcGKfzbD0DKTzUdw9TXtAIYrhG1N6Ll3/DEYLfEMHDhPTFOydB3Q6EE2dZN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634353; c=relaxed/simple;
	bh=XSNLWpOpj4s3AKWYFjGaqvQxh8MXz/agJee0up8FbPA=;
	h=Date:To:From:Subject:Message-Id; b=AU9GOmAeNjL1BUyp+ye72QBkIUaIzsjn6w+cSZsg5YjK5f7Uvja7O+MG0YfdOAi7WL2iityWiRLmvcq30M8CiKc1kTjrHzndSA+eGYX8anSGisWY0++vh/TgS15MsPTtype3WX0vD+/zTSqKycskDVNao+mUnhx+7CLbtXY4AAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rbpWu3R5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rbpWu3R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0459C19423;
	Fri, 27 Mar 2026 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634352;
	bh=XSNLWpOpj4s3AKWYFjGaqvQxh8MXz/agJee0up8FbPA=;
	h=Date:To:From:Subject:From;
	b=rbpWu3R5l7I9akJFAx14ao+MUR9DXrQWWOVSWqyYRxVGYpIDRtogpZLH++8sB1Y0C
	 O7LbMkNCnARrpLWngAAV4HFKyj44NB2HWpva76gP+q7ZKQt6NjTPpM/ndyWAsc2rtr
	 LxNNmHUvXjMcbKjRJOnJmiEnpRuS9t+9PT4W1WFg=
Date: Fri, 27 Mar 2026 10:59:12 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap.patch removed from -mm tree
Message-Id: <20260327175912.C0459C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
has been removed from the -mm tree.  Its filename was
     selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftest/mm: register existing mapping with userfaultfd in hugepage-mremap
Date: Thu, 12 Mar 2026 17:55:34 +0530

Previously, register_region_with_uffd() created a new anonymous mapping
and overwrote the address supplied by the caller before registering the
range with userfaultfd.

As a result, userfaultfd was applied to an unrelated anonymous mapping
instead of the hugetlb region used by the test.

Remove the extra mmap() and register the caller-provided address range
directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are generated
for the hugetlb mapping used by the test.

This ensures userfaultfd operates on the actual hugetlb test region and
validates the expected fault handling.

Before patch:
 running ./hugepage-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff9d000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugepage-mremap

After patch:
 running ./hugepage-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Registered memory at address 0x7eaa40000000 with userfaultfd
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugepage-mremap

Link: https://lkml.kernel.org/r/da7ec96ee85ccfdb9bec704c6dd534b419212f94.1773305677.git.sayalip@linux.ibm.com
Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-mremap.c |   21 ++++-------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -85,25 +85,14 @@ static void register_region_with_uffd(ch
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
 		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
 
-	/* Create a private anonymous mapping. The memory will be
-	 * demand-zero paged--that is, not yet allocated. When we
-	 * actually touch the memory, it will be allocated via
-	 * the userfaultfd.
-	 */
-
-	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Address returned by mmap() = %p\n", addr);
-
-	/* Register the memory range of the mapping we just created for
-	 * handling by the userfaultfd object. In mode, we request to track
-	 * missing pages (i.e., pages that have not yet been faulted in).
+	/* Register the passed memory range for handling by the userfaultfd object.
+	 * In mode, we request to track missing pages
+	 * (i.e., pages that have not yet been faulted in).
 	 */
 	if (uffd_register(uffd, addr, len, true, false, false))
 		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
+
+	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
 }
 
 int main(int argc, char *argv[])
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

a.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

