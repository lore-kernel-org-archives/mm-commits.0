Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAC43F65FC
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634351; cv=none; b=ssOePM95lM9xMtWbzFw/iNsjZ3T3t5U+Eg9Ln0KqG9QD15yygzdmG066cUWYU05dLrAzzyfU7evIyKSG0vxVqJ1xEl8r16seltUiQ9fpjCpB/W21N4OUxG+kxaIYqyZyPaaWB2dGFNdFYTEXWUveT3Hno2XYdoUf5gjFXUUb3uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634351; c=relaxed/simple;
	bh=YLfJcTNsLVVukSzIqUxiJ/X+UI5oZfVCovNzIf+Zekc=;
	h=Date:To:From:Subject:Message-Id; b=EbzZm7U7K6qxjVtjorlYfn1oDVgQr9YFHuAbgOY+p+l6+sHFAZqznrAKxTOT7DtmVQrJbiZoN8SLoeuEEnihHmHMNKlIctnVzHGT/LZS+1J5oNZjlsJisJ8tpQ++djRizZPbrNuVfoqBbNf6AlHivRXtvMgxus1WQHBKD3yzbdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVZJARiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVZJARiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83ADC19423;
	Fri, 27 Mar 2026 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634351;
	bh=YLfJcTNsLVVukSzIqUxiJ/X+UI5oZfVCovNzIf+Zekc=;
	h=Date:To:From:Subject:From;
	b=rVZJARiT4x5aRh2+bRmIw9vflIE5TEmTLp1ePQ+uSJCpQME+KxJOzO9w+BEM5DByi
	 t5ajjfGub4eceCF0MTXd6pI26x8y6p3Mu6lyGSvczhXGye1O28NHGJIqzwTA41oU8w
	 +VPIMDPZa+MrOYI77vvTijXJ6UtUcGKeM5c2snr0=
Date: Fri, 27 Mar 2026 10:59:10 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftest-mm-adjust-hugepage-mremap-test-size-for-large-huge-pages.patch removed from -mm tree
Message-Id: <20260327175910.E83ADC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: adjust hugepage-mremap test size for large huge pages
has been removed from the -mm tree.  Its filename was
     selftest-mm-adjust-hugepage-mremap-test-size-for-large-huge-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftest/mm: adjust hugepage-mremap test size for large huge pages
Date: Thu, 12 Mar 2026 17:55:33 +0530

The hugepage-mremap selftest uses a default size of 10MB, which is
sufficient for small huge page sizes.  However, when the huge page size is
large (e.g.  1GB), 10MB is smaller than a single huge page.  As a result,
the test does not trigger PMD sharing and the corresponding unshare path
in mremap(), causing the test to fail (mremap succeeds where a failure is
expected).

Update run_vmtest.sh to use twice the huge page size when the huge page
size exceeds 10MB, while retaining the 10MB default for smaller huge
pages.  This ensures the test exercises the intended PMD sharing and
unsharing paths for larger huge page sizes.

Before patch:
 running ./hugepage-mremap
 ------------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fffaa600000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 Bail out! mremap: Expected failure, but call succeeded
 Planned tests != run tests (1 != 0)
 Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]
 not ok 1 hugepage-mremap # exit=1

Before patch:
 running ./hugepage-mremap
 ------------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fffaa600000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 Bail out! mremap: Expected failure, but call succeeded
 Planned tests != run tests (1 != 0)
 Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]
 not ok 1 hugepage-mremap # exit=1

After patch:
 running ./hugepage-mremap 2048
 ------------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff13000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
  ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugepage-mremap 2048

Link: https://lkml.kernel.org/r/0ea624c4bf022425b50c50cf8f5e3023106db9c1.1773305677.git.sayalip@linux.ibm.com
Fixes: f77a286de48c ("mm, hugepages: make memory size variable in hugepage-mremap selftest")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftest-mm-adjust-hugepage-mremap-test-size-for-large-huge-pages
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -293,7 +293,18 @@ echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
 CATEGORY="hugetlb" run_test ./map_hugetlb
-CATEGORY="hugetlb" run_test ./hugepage-mremap
+
+# If the huge page size is larger than 10MB, increase the test memory size
+# to twice the huge page size (in MB) to ensure the test exercises PMD sharing
+# and the unshare path in hugepage-mremap. Otherwise, run the test with
+# the default 10MB memory size.
+if [ "$hpgsize_KB" -gt 10240 ]; then
+	len_mb=$(( (2 * hpgsize_KB) / 1024 ))
+	CATEGORY="hugetlb" run_test ./hugepage-mremap "${len_mb}"
+else
+	CATEGORY="hugetlb" run_test ./hugepage-mremap
+fi
+
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

a.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

