Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832272;
	b=DiD3zmEfT2PEY4DbmZkE3NGTujA7zRJeq6nyHxyD0EFeGVk9nBByzxatqQe1EUqNF2WV
	 5lTmElrWtTwxO4vhVUinS78YvoHlBFAFHFAiL1Oqlvl5sOeZ0RsaHAvERH+9FMz+/iEgH
	 yZZA8ouvg1xKYPCh0D4h5dyrOKCfQ3187yQJEnhAnJYt+jcNxrttrYSoeAa2Yb3cLZEOb
	 YdftI9xSBmpalILwjgCKq22kkoIzg5qLSbxww+w1tqNFy7FFctsqMz5oOyKGbZbIRuTuh
	 dZMLGenR1P9KrAWe+MSLexTrT4cuyP7d4LYKCxjieszQI/0kNXCHF3SKNGY6Knc9h6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832272;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xiYE3ZQzTiKeSpB1A3K12KLx+TOYvYzTAF2oha6oiRM=;
	b=G/jLUy7z57lh3D6I1+POfpGhRdiYrU+/rOHDB/gxISG9Utl64PJI6cjn1XY69ZJF4Yhe
	 OfFEoayQGwW19EK67be0QVuhb0gLDFvBBdbm5EBQLXeJiJrWPx/iwiXYBP32DkGFh3RM9
	 j4Ha64fRNGdYgJ+ypfQ9ppQxdz9CdtAVTaDW/FkBK2NqfkNdNtdRb/IqzDchHYPwR6HCu
	 /WrD3TNBgZsLtRIg3uTtSvGT02t6ZFimsZm3UWaQ4aQazlPvTxJhh+uReGwGCu/D2zsdM
	 H32LLJAb9YfnHfzakzXZs4olbCRx6wBwv6e7gQsi4GBJHsfrwBv10ZEuhwI/EOeZvIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P492Ipxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF6606A320
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P492Ipxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3A41F01825;
	Sat, 24 Oct 2026 08:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832272;
	bh=xiYE3ZQzTiKeSpB1A3K12KLx+TOYvYzTAF2oha6oiRM=;
	h=Date:To:From:Subject;
	b=P492IpxgMg+zTuWD7GnOpNnyiqB/OeEGmo7P3vN57U3RcRYDS1L2GuTdsVk0agec0
	 xCz40QPsj/A2OVAzFbsz0PEw0UNO/PUQaff26O2yXp7fP0eX/Ryjh7NKH87rc/72RY
	 i+cVkg3jCSTh0kn8UXPS39LKEhpPBZ9h7jNxyZK4=
Date: Sat, 24 Oct 2026 01:57:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch removed from -mm tree
Message-Id: <20261024085752.4E3A41F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: kselftest: mm: prevent random failure of huge page split for khugepaged
has been removed from the -mm tree.  Its filename was
     kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: prevent random failure of huge page split for khugepaged
Date: Thu, 01 Oct 2026 22:17:51 +0100

Patch series "kselftest: mm: fix some failure of split_huge_page_test",
v9.

split_huge_page_test can fail for the following reasons:

  1. During the test, khugepaged may collapse previously split pages again,
     causing intermittent failures.

  2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
     glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
     made by memalign(). The underlying VMA may start at a different address
     from the aligned address returned by memalign(). Moreover, a subsequent
     madvise(MADV_HUGEPAGE) call does not split the VMA because it already
     has the same advice.

     This causes the test to fail because the check_huge_xxx() helpers
     incorrectly require the address returned by memalign() to match the
     VMA start address reported in /proc/self/smaps.

Address these issues by applying MADV_NOHUGEPAGE after faulting in the
huge page, preventing khugepaged from collapsing it again, and instead of
relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings and large folios:

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
     using check_large_folios(), since only the mapping type matters.
     This identifies PMD-mapped huge pages.
  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.
  3. Check the folio flags according to the type of huge page.

Since check_huge_shmem() was required to distinguish shmem huge pages
because /proc/self/smaps reports them using a dedicated “ShmemPmdMapped”
entry, as opposed to “FilePmdMapped” for file-backed huge pages.

Now that /proc/self/smaps is no longer used to detect huge pages and
/proc/kpageflags is used instead, it is sufficient to distinguish
 between file-backed and anonymous pages since the ShmemPmdMapped is also
kind of file-backed.

Therefore, remove check_huge_shmem() and use check_huge_file() instead.


This patch (of 4):

There're some random failure for split_huge_page_test when khugepaged
collapses pages into pmd again which had split by the test.

Prevent the khugepaged's collapses for split page by setting the
mapped pmd-huge-page with MADV_NOHUGEPAGE before split.

Link: https://lore.kernel.org/20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com
Link: https://lore.kernel.org/20261001-fix_split-v9-1-0f4ba8bbdbdf@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
---

 tools/testing/selftests/mm/split_huge_page_test.c |   16 ++++++++++++
 1 file changed, 16 insertions(+)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -108,6 +108,15 @@ static char *allocate_zero_filled_hugepa
 	return result;
 }
 
+static void disable_khugepaged(void *addr, size_t len)
+{
+	/* Disables khugepaged from collapsing pages in range into THPs */
+	if (!madvise(addr, len, MADV_NOHUGEPAGE))
+		return;
+
+	ksft_exit_fail_perror("MADV_NOHUGEPAGE failed");
+}
+
 static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
 {
 	unsigned long rss_anon_before, rss_anon_after;
@@ -120,6 +129,8 @@ static void verify_rss_anon_split_huge_p
 	if (!rss_anon_before)
 		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		      (uint64_t)one_page + len, 0);
@@ -167,6 +178,8 @@ static void split_pmd_thp_to_order(int o
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
 		ksft_exit_fail_msg("No THP is allocated\n");
 
+	disable_khugepaged(one_page, len);
+
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
 		(uint64_t)one_page + len, order);
@@ -215,6 +228,8 @@ static void split_pte_mapped_thp(void)
 		goto out;
 	}
 
+	disable_khugepaged(thp_area, thp_area_size);
+
 	/*
 	 * To challenge spitting code, we will mremap a single page of each
 	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
@@ -482,6 +497,7 @@ static int create_pagecache_thp_and_fd(c
 		ksft_test_result_skip("Pagecache folio split skipped\n");
 		return -2;
 	}
+	disable_khugepaged(*addr, fd_size);
 	return 0;
 err_out_close:
 	close(*fd);
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are


