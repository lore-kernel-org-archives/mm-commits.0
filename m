Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354EA32939C
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 06:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786170656; cv=none; b=JeFc5d5dtZ2tEXT3MdPRGz0FEyocSlgTQxenSIXJm0xbCESdHMrm9L8xWvZGv3L1nG2Io4qhcQKPBMKuJjOygZEQNw0Yk8cCFMqWUDlJK255f1zMWK5en2MqgKV1lzJLNFZmEGGRX09vxXcUxSjerfmDMiDCEOzon+5V3fT2kDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786170656; c=relaxed/simple;
	bh=UW5J9OcYSv7uK8sXzIbZz8YxUP59Hi0Zgr3PhEd89qQ=;
	h=Date:To:From:Subject:Message-Id; b=GlQm7Z7kD8o6d4BzqH8czkBf49Wv869cnWDOunMS1lrKjxmARGV5wTD2LLl7claom2uPIPnStoZ3yRjFN9+ev0GPwxNEDl1YZgSDgDYbnNwTII9xqrKMmoxn46kq/WdIIgM2bBWq1MqH3MM/oUtYz7QbbXoRQ7V1IiQgQ2V3roI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDYI3G4i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDYI3G4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75691F000E9;
	Sat,  8 Aug 2026 06:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786170654;
	bh=DLp4Zqc6q/URlsfxVkjZEQTAfPZIz7HP2kPtHDSE/Hs=;
	h=Date:To:From:Subject;
	b=TDYI3G4ikE5ACbPRkm7GnryVO7vGAKg9KU/j66r4xQvXBZ0KNu6iZELjuP8Ab1kuq
	 ylKtv0ls95TGSm7kkD/LQLA+EZTT8gKClZHc9gnqHd1OxDqM3vvDfECSY0cagFiiXm
	 D+v6+xxcZijF3IB621QuxtDY9J/W34dzCVUa5NRM=
Date: Fri, 07 Aug 2026 23:30:54 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-khugepaged-skip-swap-tests-when-no-swap-available.patch removed from -mm tree
Message-Id: <20260808063054.B75691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: khugepaged: skip swap tests when no swap available
has been removed from the -mm tree.  Its filename was
     selftests-mm-khugepaged-skip-swap-tests-when-no-swap-available.patch

This patch was dropped because an updated version will be issued

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

