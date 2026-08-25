Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB58F34751F
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622855; cv=none; b=f+hSjAvXwfDatWqO6xE3k6EbW/uESIeahzGuDjh+C0mlOwe29n4iMx+lT6tZhd9Y4DN9AHHqBEa/D7PbbXd0fM0VThDRuFZRt+QivtV4kgDrMeHFrXyy6F40enqjpuCQTZJA2zlM7oPp3ymNRiZagmUix+z/uXVA8zfP9czP+sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622855; c=relaxed/simple;
	bh=BGHa9fXJ7/ncM3VBLJqyFi4kX/cGcyQwuLS1tmcLHNA=;
	h=Date:To:From:Subject:Message-Id; b=qS3e3mzkVvRlFlZTIYmWYKpz0Boyqm5IbVy+3suhM2nFopv2an7/6WVLgw5BNFJ5uSfoHcX+ipBM6eHY+C2wNnfD9A3OnMtgZ8v0m4KkvZ2pevURGWgrAvBwXPgOoX3v1gDpaEIfKyTutGZX3n8Yt3gEUVatXugLUt7rsEd7mXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lt5DzVPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lt5DzVPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1BF1F000E9;
	Tue, 25 Aug 2026 01:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622853;
	bh=KmQM/CJFCKm/FVvKIlVyDwcsGJJI/7w3P2aVYtyG/No=;
	h=Date:To:From:Subject;
	b=lt5DzVPzaQ0kZ4BXsMkmZU3384fXP0IdfBC4QvhcztU81TfJhI5XYPq9u4Dg9/S1s
	 yxF+/qMkrEqbN3nRvzy1LOL3+yvSpHx1+h2xUo46tMXsxVn3L1EtYLd5mkJvuLtDbR
	 dAszOlqyUi5bWQXMs8uByEfUQIPKLBbeOa+3SEkM=
Date: Mon, 24 Aug 2026 18:54:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch removed from -mm tree
Message-Id: <20260825015413.9F1BF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: implement the mTHP-sized hugepage check helpers
has been removed from the -mm tree.  Its filename was
     selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: selftests: mm: implement the mTHP-sized hugepage check helpers
Date: Thu, 6 Aug 2026 11:34:14 +0800

Implement mTHP-sized hugepage checking helpers using
gather_folio_orders().  Also rename the existing PMD-sized huge page check
function to __check_pmd_huge() for clarity.

Link: https://lore.kernel.org/56b16691f605426b33b5cf47319233de6127a6b3.1785985999.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |   76 +++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-implement-the-mthp-sized-hugepage-check-helpers
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -15,6 +15,9 @@
 #define SMAP_FILE_PATH "/proc/self/smaps"
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
+#define PAGEMAP_PATH "/proc/self/pagemap"
+#define KPAGEFLAGS_PATH "/proc/kpageflags"
+#define MAX_NR_ORDERS 20
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -348,7 +351,7 @@ err_out:
 	return entry;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
+static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
 	char buffer[MAX_LINE_LENGTH];
@@ -366,19 +369,84 @@ err_out:
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
+static bool check_large_folios(void *addr, size_t len, int nr_hpages,
+		uint64_t hpage_size)
+{
+	int order = 0, pagesize = getpagesize();
+	unsigned int nr_pages = hpage_size / pagesize;
+	int orders[MAX_NR_ORDERS], status;
+	int pagemap_fd, kpageflags_fd;
+	bool ret = false;
+
+	if (!nr_pages)
+		ksft_exit_fail_msg("invalid hugepage size\n");
+
+	order = 31 - __builtin_clz(nr_pages);
+	if (!order || order >= MAX_NR_ORDERS)
+		ksft_exit_fail_msg("invalid order\n");
+
+	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd == -1)
+		ksft_exit_fail_msg("read pagemap fail\n");
+
+	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (kpageflags_fd == -1) {
+		close(pagemap_fd);
+		ksft_exit_fail_msg("read kpageflags fail\n");
+	}
+
+	status = gather_folio_orders(addr, len, pagemap_fd,
+			kpageflags_fd, orders, MAX_NR_ORDERS);
+	if (status)
+		goto out;
+
+	if (orders[order] == nr_hpages)
+		ret = true;
+
+out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	return ret;
+}
+
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	uint64_t pmd_pagesize = read_pmd_pagesize();
+
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	if (hpage_size == pmd_pagesize)
+		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	uint64_t pmd_pagesize = read_pmd_pagesize();
+
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	if (hpage_size == pmd_pagesize)
+		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+	uint64_t pmd_pagesize = read_pmd_pagesize();
+
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
+	if (hpage_size == pmd_pagesize)
+		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch

