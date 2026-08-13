Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF57384232
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786650196; cv=none; b=EYkJCNDjPHEh9bikWuUwfYjZ1krJxL51FYtPyNzE1TrVESzotSfVH5AHUN2kDZhWCxCPddzWeA5IEXVb/JdLyqv47m5rxJLST8a/QxFE3VpgecE83lkSGWrjPFuuXIggg5DhezRx1VEUGo5Z41fXantEyFkD81727tEr85IGNwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786650196; c=relaxed/simple;
	bh=rQFzr1EDD5CX89Eb8TNd1bZZeZfTa/EYafxB93vEbnA=;
	h=Date:To:From:Subject:Message-Id; b=oNUBJuicryuGG6VhnHm/5p5FubiVH9OssC+Bbp/INFHu9JOBHkU4BxcseCNjpE64TPjGIWmQQsKHKisxXkA6zodcylOTGK65u883BcrruswacgsMsDVa/Kykz4baqL2wep1Mf5UWe61JBg130aazdPTvBLBXzEzjuyLF/rfiAqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yrQaZ2HC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yrQaZ2HC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEA61F000E9;
	Thu, 13 Aug 2026 19:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786650195;
	bh=lCUQ8wVKp+Xe9TMaMIVsq8TSwMzBPL3zLn3PeiHelOw=;
	h=Date:To:From:Subject;
	b=yrQaZ2HC7UuV/Hu90RJpA9SI9cvGl/AqZKUwtAjfGC4uID9wPuaWHx/JgORiedCaw
	 WHfkbEBx9a/nRPphRobhX6bikLmsIi00H3+eP5YHElReJThFjyYj3Xd8irrKXmpJJ1
	 4NMqTpfURkjchC49x8gQ+JZogB4PrtGaMJ4AJ+dY=
Date: Thu, 13 Aug 2026 12:43:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] selftests-mm-skip-khugepaged-swap-tests-without-swap.patch removed from -mm tree
Message-Id: <20260813194315.1CEA61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip khugepaged swap tests without swap
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-khugepaged-swap-tests-without-swap.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: selftests/mm: skip khugepaged swap tests without swap
Date: Mon, 27 Jul 2026 10:52:19 +0100

collapse_swapin_single_pte and collapse_max_ptes_swap require MADV_PAGEOUT
to replace anonymous pages with swap entries.  On swapless systems there
is no backing store with which to create those entries, so check_swap()
reports missing setup rather than broken khugepaged behavior.

Swapless configurations are common on Android and other constrained test
devices.  Failing these cases obscures actionable results from the rest of
the khugepaged suite.

Check /proc/swaps before either swap-dependent case and skip when no
active swap area exists.  With swap present, retain the existing
MADV_PAGEOUT and swap-entry assertions unchanged.

Print each existing swapout diagnostic before the prerequisite check so
skip() completes a KTAP diagnostic line instead of emitting an unprefixed
message.

Link: https://lore.kernel.org/20260727095225.372655-4-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   38 ++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-skip-khugepaged-swap-tests-without-swap
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -103,6 +103,28 @@ static void skip(const char *msg)
 	exit_status = KSFT_SKIP;
 }
 
+static bool is_swap_enabled(void)
+{
+	char buf[MAX_LINE_LENGTH];
+	FILE *file;
+	bool enabled = false;
+
+	file = fopen("/proc/swaps", "r");
+	if (!file)
+		return false;
+
+	if (!fgets(buf, sizeof(buf), file))
+		goto out;
+
+	/* Check for first active swap entry. */
+	if (fgets(buf, sizeof(buf), file))
+		enabled = true;
+
+out:
+	fclose(file);
+	return enabled;
+}
+
 static void save_settings(void)
 {
 	ksft_print_msg("Save THP and khugepaged settings...");
@@ -821,10 +843,16 @@ static void collapse_swapin_single_pte(s
 {
 	void *p;
 
+	ksft_print_msg("Swapout one page...");
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	ksft_print_msg("Swapout one page...");
 	if (madvise(p, page_size, MADV_PAGEOUT))
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, page_size)) {
@@ -847,10 +875,16 @@ static void collapse_max_ptes_swap(struc
 	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
 	void *p;
 
+	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
 	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
_

Patches currently in -mm which might be from usama.anjum@arm.com are

selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch
selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch
selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch
selftests-mm-retry-migration-failures-for-the-full-runtime.patch

