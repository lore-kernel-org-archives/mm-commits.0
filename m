Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832274;
	b=jOoWl3YxOhnLNxenawWwIuIXTjgB1ecH9j6pGaIcsxK1BO+3eBJKAppa24mWCtzqhHMt
	 KjcPhHiVEmDOqtnvVy3eODRt3URB/FWdEDwdWKkI1b8V7OAc8eh6QNzJgqhS46DSIV88N
	 yUsxri93uIiadWZOIWefV5PpwprCOuPM04lbq1TSSmBrCGRn61tZKuP89KNy2H5yV8/94
	 +XkrIks8xFjhYdY3KnbVS4toI0HwDkWpKsXbFdSN2zhuQzdX9mdDVxeDcBFbJp7YeY9XN
	 ATxLe23t+lbYlJ+X4HrCPQEV2UWapSoZ04/2Q7f2Qo5lnFPiJ5Yhvk+Mdz76zVSxvDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832274;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kMjk5iSwn6hexNCMDVj59HpQFi03eehHAHizMXAIN6s=;
	b=NGJ8crFtd1Aoagqz+eBobioHCtAUHiRFcduoBy+K4R3DkWnSlCKWUaKFMUgVgdwL9VRW
	 TAdcgLUhBcxNcGhWHl+lfVZvwnywfqVEzSmPogxumHID6HnqfzH9QPC/wfO4uJxD6r7Y2
	 XQ0uvkNRQnQY3KLaQDHNcAJkNdB0Y6kM5rRruBh/bJ62DxJbIs6B43UaDFYs3cliElVf+
	 BB7ILiu4gHBExgPGbRJvFdkkELd6a5WqCrujmdJnK1RFIRtkVQ1Zh15BkRxHbpCaKtbK6
	 6O6Ha7eExd9aosm1jp6sEazX3Cv3Vycq4g5gx/75Ku6ktrllLhe1yu2hfv9Z2bEFfow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="z/9UAfpB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9023606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z/9UAfpB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69E31F01825;
	Sat, 24 Oct 2026 08:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832273;
	bh=kMjk5iSwn6hexNCMDVj59HpQFi03eehHAHizMXAIN6s=;
	h=Date:To:From:Subject;
	b=z/9UAfpBxjdGe6dk25E6E/XPceGFRD5A8RunpY20KV2jwcyPnXo2C1uSM9KfhUKg7
	 //i1/isMj0voUgvCnDu89JVgFyMD9jFA6anxFV3jfALdj43G2Xkn1j7r5aQFh0UO0u
	 R7lLDpsu9UKQc/YBOSXBYPlOLHqHrLC7bFqVMfjE=
Date: Sat, 24 Oct 2026 01:57:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch removed from -mm tree
Message-Id: <20261024085753.B69E31F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: kselftest: mm: replace usage of /proc/self/smaps for __check_pmd_huge()
has been removed from the -mm tree.  Its filename was
     kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: replace usage of /proc/self/smaps for __check_pmd_huge()
Date: Thu, 01 Oct 2026 22:17:52 +0100

Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
made by memalign().

The underlying VMA may start at a different address from the aligned
address returned by memalign(). Furthermore, a subsequent
madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
already set.

This causes split_huge_page_test to fail because the check_pmd_huge()
helpers incorrectly require the address returned by memalign() to
match the VMA start address reported in /proc/self/smaps.

Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
and PAGE_IS_FILE according to type of huge page.

Since shmem pages are also file-backed, simply check whether the page
is file-backed.

Link: https://lore.kernel.org/20261001-fix_split-v9-2-0f4ba8bbdbdf@arm.com
Fixes: 642bc52aed9c ("selftests: vm: bring common functions to a new file")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
---

 tools/testing/selftests/mm/vm_util.c |   78 +++++++++++++++----------
 1 file changed, 49 insertions(+), 29 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -351,24 +351,6 @@ err_out:
 	return entry;
 }
 
-static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
-		  uint64_t hpage_size)
-{
-	char buffer[MAX_LINE_LENGTH];
-	uint64_t thp = -1;
-	char *entry;
-
-	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
-	if (!entry)
-		goto err_out;
-
-	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
-		ksft_exit_fail_msg("Reading smap error\n");
-
-err_out:
-	return thp == (nr_hpages * (hpage_size >> 10));
-}
-
 static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
@@ -410,20 +392,51 @@ out:
 	return ret;
 }
 
-bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+enum check_huge_type {
+	CHECK_HUGE_ANON,
+	CHECK_HUGE_FILE,
+};
+
+static bool check_huge_type(uint64_t categories, enum check_huge_type type)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	const bool file = categories & PAGE_IS_FILE;
 
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	switch (type) {
+	case CHECK_HUGE_ANON:
+		return !file;
+	case CHECK_HUGE_FILE:
+		return file;
+	}
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	return false;
+}
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
+		  uint64_t hpage_size, enum check_huge_type type)
+{
+	int pagemap_fd;
+	int nr_pmd_mappings = 0;
+	uint64_t categories;
+	char *start = addr;
+	char *end = start + len;
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open pagemap");
+
+	for (; start < end; start += hpage_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		if (!(categories & PAGE_IS_HUGE))
+			continue;
+		if (check_huge_type(categories, type))
+			nr_pmd_mappings++;
+	}
+	close(pagemap_fd);
+
+	return nr_hpages == nr_pmd_mappings;
 }
 
-bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -431,12 +444,13 @@ bool check_huge_file(void *addr, size_t
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
+					CHECK_HUGE_ANON);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -444,11 +458,17 @@ bool check_huge_shmem(void *addr, size_t
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
+					CHECK_HUGE_FILE);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
+bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return check_huge_file(addr, len, nr_hpages, hpage_size);
+}
+
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are


