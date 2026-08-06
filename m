Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D97137F8A5
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 04:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785990004; cv=none; b=HN2ve0G4Kra4FZcfpHan0j1t9IjPqKuDRn9VebHVPPQKlxhSQn1mmU9SLe1j2RsI+yKGrQc1q2lkQHSbJIdfqCmoWzoBmKmyVDO8IJKehmSrD93JhCSVfWD4bjv8piiHt0uoSMp5n9s/zsSihcYUjPwfKDcBJENbEXWZDsWQDDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785990004; c=relaxed/simple;
	bh=zcduDsaVEDddX1hc0yZ49lCG3Iz7kC7YyrPZK3qI8GU=;
	h=Date:To:From:Subject:Message-Id; b=ZgX2dIfreIWaY0KlRjlMCOItQBULeRGgSetSGFRZKQxv+Y8+e3BpXZDG6MRHfgAWsyFPECbaw7k+R7H/EyC/iU/MM/GdFs4SmGv2gf7Oo7ZZUV4KsvfjZXo1zb8QpBSxibaUJBsb9E8PmEqI3btXDo/+KFufvEQuADk+tr1STsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n0asBRbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n0asBRbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A391F00A3A;
	Thu,  6 Aug 2026 04:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785990002;
	bh=I+fUryPICVWHNODOj2RRfsgbSxVPqsuYpmFtZLhIeq4=;
	h=Date:To:From:Subject;
	b=n0asBRbiwFX1HMGy7NB4v7zp+c3QOtJFKbH/q+kytcvBxpdVNmpd2jgoGIAlCFmEo
	 o+rTLLcTZBzubd6BujtUUIwWgh9MGqoXzkmZY4/fn2erRV3a0BetI0FhVdPYBUZnN3
	 oviuUTN3L8ZjCs9Gqn6wXNkWvaVAYOTkT44/sD5A=
Date: Wed, 05 Aug 2026 21:20:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch added to mm-new branch
Message-Id: <20260806042002.34A391F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: implement the mTHP-sized hugepage check helpers
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch

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
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch
mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch
selftests-mm-extend-the-check_huge-to-support-mthp-check.patch
selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file.patch
selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch
selftests-mm-add-mthp-collapse-test-cases.patch

