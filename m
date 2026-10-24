Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832275;
	b=I2Pe29XOZh3d+Pd4W8sOLNK/v8TY7Qrq5ZjiSK56YkGG/hjmRXlky4MLAS8QdEv+T1pH
	 INvZ6s5482XcxyfQ39L+cOgbIEjQNK12qrx0IY1ip44tFggZLYRSBTJ++cOJLIy+LXSXZ
	 uyqDPWCgA2CYJLTtyHV0QFbSuHEgvGHArkNN14WSxM5JFHZRYS1OiJNxuVkginEsswIKu
	 GQhdt5C5j6F5lszRCBWifhnfERym1Ad0mTB1/FS+Od5BJN2qKLvB20BnPIlVl9lqlxgnM
	 e8fzT1g6LJxpafwSjOPemT8OS6XSUtVrShV3QMAEO9B1V324GKxzOF3Af3KoxxlrqXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832275;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nIwOLDPwuUhUyG7wfQhJV3fKbml7MRVfPMa2YWdUI8g=;
	b=h04aXWTL9qk/yYWguLyxkEUyDCETSJGkeKS0CeMs0lST/Z7VzR7N9KR9ubyoG50Jn79k
	 bUHneCJ7/hpXGMpPkM7kWBAaEtEMz00JcRh1ZolHzzabXwZOUkdQjkpfhvUkIJzR07mpA
	 tCOzIa0wq/Fm6e6bXsQtZErykv7YjcfxHM9rp11rqx73h89DIYGzwzxnfVFlJzP0GXFm/
	 jqT9HaB0xsvAYUaBCOZMZsGoNgsV5/8aY6CujoyR39YRICAv/8Appzt1GLKmM2STJI3Lr
	 Pw2AjMM2Hql9bx2TD7WtIpc015EnZhiU8kvlq2kxs+t1oaeJwZYBsrqom+9Qs8aADcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=B4w6tlfo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2E2606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=B4w6tlfo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296AB1F01825;
	Sat, 24 Oct 2026 08:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832275;
	bh=nIwOLDPwuUhUyG7wfQhJV3fKbml7MRVfPMa2YWdUI8g=;
	h=Date:To:From:Subject;
	b=B4w6tlfoO+0uZD4WHQFDlP9xJH9gxIGgFZBwOfFdU1VDGjHaRXDtswD6gzh7puYIU
	 owMYFxX27GHgJolue1FX5uL/3xskA3tPBU056eQwCE6/6tZSfW4SQaPPiz2nhmTz/q
	 GcRwozH9tPy55s+vqO5XBKm/+q8aAAH2VMbtr1Bk=
Date: Sat, 24 Oct 2026 01:57:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-integrate-huge-page-checks.patch removed from -mm tree
Message-Id: <20261024085755.296AB1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: kselftest: mm: integrate huge page checks
has been removed from the -mm tree.  Its filename was
     kselftest-mm-integrate-huge-page-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: integrate huge page checks
Date: Thu, 01 Oct 2026 22:17:53 +0100

check_large_folios() only checks for large folios without distinguishing
between anonymous and file-backed huge pages.

To add huge page type checking, integrate the huge page checks into
__check_huge() and __check_type():

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
     check_large_folios(), since only the mapping type matters. This
     identifies PMD-mapped huge pages.

  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.

  3. Check the folio flags according to the huge page type via
     __check_type()

Link: https://lore.kernel.org/20261001-fix_split-v9-3-0f4ba8bbdbdf@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 tools/testing/selftests/mm/vm_util.c |   90 +++++++++++++++----------
 1 file changed, 56 insertions(+), 34 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~kselftest-mm-integrate-huge-page-checks
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -392,76 +392,98 @@ out:
 	return ret;
 }
 
-enum check_huge_type {
-	CHECK_HUGE_ANON,
-	CHECK_HUGE_FILE,
+enum check_type {
+	CHECK_TYPE_ANON,
+	CHECK_TYPE_FILE,
 };
 
-static bool check_huge_type(uint64_t categories, enum check_huge_type type)
+static bool __check_type(void *addr, size_t len, uint64_t page_size,
+		enum check_type type)
 {
-	const bool file = categories & PAGE_IS_FILE;
+	bool ret = false;
+	int pagemap_fd;
+	char *start = addr;
+	char *end = start + len;
+	uint64_t categories;
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open pagemap");
 
-	switch (type) {
-	case CHECK_HUGE_ANON:
-		return !file;
-	case CHECK_HUGE_FILE:
-		return file;
+	for (; start < end; start += page_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		if ((categories & PAGE_IS_PRESENT) != PAGE_IS_PRESENT)
+			continue;
+
+		if ((type == CHECK_TYPE_FILE) != !!(categories & PAGE_IS_FILE))
+			goto out;
 	}
 
-	return false;
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	return ret;
 }
 
-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-		  uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+		uint64_t hpage_size)
 {
+	bool ret = false;
 	int pagemap_fd;
 	int nr_pmd_mappings = 0;
+	uint64_t pmd_pagesize;
 	uint64_t categories;
 	char *start = addr;
 	char *end = start + len;
 
+	pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
 	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_perror("open pagemap");
 
+	if (hpage_size != pmd_pagesize) {
+		ret = check_large_folios(addr, len, nr_hpages, hpage_size);
+		goto out;
+	}
+
 	for (; start < end; start += hpage_size) {
 		categories = pagemap_scan_get_categories(pagemap_fd, start);
-		if (!(categories & PAGE_IS_HUGE))
-			continue;
-		if (check_huge_type(categories, type))
+		if (categories & PAGE_IS_HUGE)
 			nr_pmd_mappings++;
 	}
-	close(pagemap_fd);
 
-	return nr_hpages == nr_pmd_mappings;
+	if (nr_pmd_mappings != nr_hpages)
+		goto out;
+
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	return ret;
 }
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_ANON);
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_ANON);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_FILE);
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_FILE);
 }
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are


