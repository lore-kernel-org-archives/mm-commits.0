Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70D43FEB27
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634354; cv=none; b=pXybf3xRq46OGWhd7FPX7IEINC54ZPCMUyWheO9epolED8K74BhI/IA9PWmEddzE3smi3wSDZSyGxq6UJMVC128P+MBhG8QItJIpxGV8SPeCXhDyXi8D0iGNJ1LM0CqTFwg9WySEMHpT5os55nXDUtVTp8wnaOsvHtxBlWWzY7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634354; c=relaxed/simple;
	bh=mX+F05r/WCGU40EEq44DuMc8gxRRibmC/EHQcDF1274=;
	h=Date:To:From:Subject:Message-Id; b=sNfxhuGLxKT3pI1BP9I5m5IYsxzDXbPpqpf/Xih2a5kMrLRLijKVN8qj2RGPMS7uODuEQMqpyxwjqtYx1h5RZBeKc3tZ82dA2ae1+7Ek7MilTTTMJ1bqBPvAAGeHs9arvCBWY8uG2EZnaWan8aQEBIwkkLS9Hd9boNoPfqqOiRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ODJtHSFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ODJtHSFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839DAC19424;
	Fri, 27 Mar 2026 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634354;
	bh=mX+F05r/WCGU40EEq44DuMc8gxRRibmC/EHQcDF1274=;
	h=Date:To:From:Subject:From;
	b=ODJtHSFsENMbB6YPwxZnuzb/iO5KDJqnS09IxjaxX4X1LquV89I8TyMZDC6zdLfEf
	 u1aAhRcBR8jjqRrsq1YYBfqWbM3nSvDL3FTxdg03+5Kb5fsXjNs+V73DsVeHBKwkBI
	 Ns73sBx5ok+spDHhm4ZhDrQXfarePjKQNzXGXnP8=
Date: Fri, 27 Mar 2026 10:59:14 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch removed from -mm tree
Message-Id: <20260327175914.839DAC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
has been removed from the -mm tree.  Its filename was
     selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
Date: Thu, 12 Mar 2026 17:55:35 +0530

The hugepage-mremap selftest reserves the destination address using a
anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
while the source region is hugetlb-backed.

When remapping a hugetlb mapping into a base-page VMA may fail with:

    mremap: Device or resource busy

This is observed on powerpc hash MMU systems where slice constraints and
page size incompatibilities prevent the remap.

Ensure the destination region is created using MAP_HUGETLB so that both
source and destination VMAs are hugetlb-backed and compatible.  Also add
MAP_POPULATE to the destination mapping to prefault hugepages, matching
the behaviour used for other hugetlb mapping in the test and ensuring
deterministic behaviour.

Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED | MAP_POPULATE
so that both mappings are hugetlb-backed and compatible.  Also use the
macro for the mmap() calls to avoid repeating the flag combination.

This ensures the test reliably exercises hugetlb mremap instead of failing
due to VMA type mismatch.

Link: https://lkml.kernel.org/r/a9e12dcb25b9be4f146063669b1eb3ff9b776c23.1773305677.git.sayalip@linux.ibm.com
Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
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

 tools/testing/selftests/mm/hugepage-mremap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -31,7 +31,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
 
 static void check_bytes(char *addr)
 {
@@ -121,23 +121,20 @@ int main(int argc, char *argv[])
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
 	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
 	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
-			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
+	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
 	suggested_addr = 0x7faa40000000;
-	void *vaddr =
-		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
+	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

a.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

