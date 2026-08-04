Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD08238F633
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785872320; cv=none; b=SjGhRYqrOnoy9zb8vFZ5MgT//CAwvtemJZkyCQxfJjraN6xmctIO3KMBhmxk9SoY68YXYx6BrGLxmieqMSAm2L1OF1nFqo5GexxxJ3myN0zN7NWBpKM3pz6F2P1PRDrLFPylgDiSODDZb5aCMjR9nodMN/nBtG/1JwIJZEMjO/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785872320; c=relaxed/simple;
	bh=CHFY2PLNxO/Pph8L40ai2kLJcuQWw+9GE5xGdTlUPq4=;
	h=Date:To:From:Subject:Message-Id; b=NOvVQ4UBwowewFUWPom5+2Rfpep4aVK/eeywb1nFhD97rkXSVGfZJzsuMskRHBqk/3u1z0ZSfyLLd0O2zJrwW3so7xgHfGOSuFy+/BoOHZNyTz52Ba25fvtIK7tchMIrOh5KpAoUUGCGAHdGTUYMczttYaZmf3tvi4WwWIAcMLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MyzKdU1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MyzKdU1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476301F000E9;
	Tue,  4 Aug 2026 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785872318;
	bh=plm61SXaEf1jtgltPKQsqlUT6B3dKmWBLuiBM50He58=;
	h=Date:To:From:Subject;
	b=MyzKdU1rzj9gsVIAuRAwmxl4XIFlXpbgWlQ6NlVLXkO8Lto98knJLf8CgJ0dezeWs
	 VHlDgRD5fJ9Bt/DhMefG37z+KzKTeOQWJb78SWmkaE2f1ufpeacJlWZDngz55lTVi3
	 /smyEAPZF/x9GBHAkUZpMl3V9it2isQAithLwYPI=
Date: Tue, 04 Aug 2026 12:38:37 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-skip-swap-tests-when-no-swap-available.patch added to mm-new branch
Message-Id: <20260804193838.476301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: khugepaged: skip swap tests when no swap available
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-khugepaged-skip-swap-tests-when-no-swap-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-skip-swap-tests-when-no-swap-available.patch

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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: selftests/mm: khugepaged: skip swap tests when no swap available
Date: Tue, 4 Aug 2026 14:53:51 +0200

When no swap is configured, swap-related tests fail because
madvise(MADV_PAGEOUT) does not swap out pages.  Add a helper function to
detect swap availability and skip these tests.

Link: https://lore.kernel.org/20260804125351.1715708-1-agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-skip-swap-tests-when-no-swap-available
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -216,6 +216,25 @@ err_out:
 	return swap;
 }
 
+static bool is_swap_available(unsigned long size)
+{
+	unsigned long swap_total = 0;
+	char buffer[256];
+	FILE *fp;
+
+	fp = fopen("/proc/meminfo", "r");
+	if (!fp)
+		return false;
+
+	while (fgets(buffer, sizeof(buffer), fp)) {
+		if (sscanf(buffer, "SwapTotal: %lu kB", &swap_total) == 1)
+			break;
+	}
+	fclose(fp);
+
+	return swap_total >= (size / 1024);
+}
+
 static void *alloc_mapping(int nr)
 {
 	void *p;
@@ -734,6 +753,13 @@ static void collapse_swapin_single_pte(s
 {
 	void *p;
 
+	if (!is_swap_available(page_size)) {
+		ksft_print_msg("No swap available...");
+		skip("Skip");
+		ksft_test_result_skip("%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
@@ -760,6 +786,13 @@ static void collapse_max_ptes_swap(struc
 	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
 	void *p;
 
+	if (!is_swap_available((max_ptes_swap + 1) * page_size)) {
+		ksft_print_msg("No swap available...");
+		skip("Skip");
+		ksft_test_result_skip("%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

mm-use-proper-pte-accessor-in-move_ptes.patch
selftests-mm-khugepaged-skip-swap-tests-when-no-swap-available.patch

