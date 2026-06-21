Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D5F36F8FE
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067205; cv=none; b=tQVsTkhQbFSncCljrmFBCv+0uMADQBGQAv7gWGaX716w9hOKC4N0LhVCQTJlFIaDe0TvE8XyVTHVLGF7CV0dK1iCVDWRlIyQgQpnEMDnFOBINpdL7SJ0vk3IHrxezPAChcVtAII5aXOCNI15favE/Gq30RchlRhs73AlS8sKIhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067205; c=relaxed/simple;
	bh=G8OOlAhcfZVQwpzqfUBeYWMB3g99aa/FxCWtZdUpxiA=;
	h=Date:To:From:Subject:Message-Id; b=FxU4ZSs7682ZIfg5ci72hdGG0lrUtGsf/GBHxOpsaV4+7vSyKj6hNrIbk4jIuOy66sDv2B6xmZL57D0Yu59o/nxBqoDmuOIu1CZC370EKxlW5nAwb+qn7W7W/TKxCP/0M8ubtY9A9i5jzBlZ/+qfltuEt3USYuQ1Q7v7IA+5kRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AxRZrund; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AxRZrund"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CF71F000E9;
	Sun, 21 Jun 2026 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067203;
	bh=TdPMOvebDuvq7uMiArO7Aao/2qJhC9RBEMmnIzGlg4A=;
	h=Date:To:From:Subject;
	b=AxRZrundWGogl9/QCSN9xoHfedQfKZcheQksH1E1I1JwmhultCjXBFwNIYB7RA7ej
	 g4s/Apx+LHiB/PHvTFm9FY8fJCjnlNfDw5j/XfvtTccLxTFOBNFuZvJk6bPXDQiDTt
	 wOn1FSU8Iyx0HDy4b9EQAoIVS7XBd6bxYrhktyG8=
Date: Sun, 21 Jun 2026 11:40:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-ensure-destination-is-hugetlb-backed-in-hugetlb-mremap.patch removed from -mm tree
Message-Id: <20260621184003.C6CF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
has been removed from the -mm tree.  Its filename was
     selftests-mm-ensure-destination-is-hugetlb-backed-in-hugetlb-mremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
Date: Thu, 21 May 2026 12:17:49 +0530

The hugetlb-mremap selftest reserves the destination address using a
anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
while the source region is hugetlb-backed.

When remapping a hugetlb mapping into a base-page VMA may fail with:

    mremap: Device or resource busy

This is observed on powerpc hash MMU systems where slice constraints and
page size incompatibilities prevent the remap.

Ensure the destination region is created using MAP_HUGETLB so that both
source and destination VMAs are hugetlb-backed and compatible.

Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED so that both
mappings are hugetlb-backed and compatible.  Also use the macro for the
mmap() calls to avoid repeating the flag combination.

This ensures the test reliably exercises hugetlb mremap instead of failing
due to VMA type mismatch.

Link: https://lore.kernel.org/367644df45c65098f23e3945c6a80f4b8a8964a6.1779296493.git.sayalip@linux.ibm.com
Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-mremap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-mremap.c~selftests-mm-ensure-destination-is-hugetlb-backed-in-hugetlb-mremap
+++ a/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -32,7 +32,7 @@
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
-#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
+#define FLAGS (MAP_HUGETLB | MAP_SHARED)
 
 static void check_bytes(char *addr)
 {
@@ -132,23 +132,20 @@ int main(int argc, char *argv[])
 
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


