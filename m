Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723D40DB59
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 21:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786050011; cv=none; b=fakBKAAdkWM6u+pfjmO4dypNfDhUrTbWwnAtFTdLzAy57eJHGzD3I3n9BPRt43q6RdxUD6lgd2UdpNrrdrQvN/fU2x9Vdhp5UytCJ0PiNi+icEx584scyfCLxQEnivQHdnGAwRaqA4ghtmgGRPj7ADQkzk9V5GBBuRVlTQyokUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786050011; c=relaxed/simple;
	bh=vgrlpU91anjPCo3eMDwO+AmkIYtzKNp038vKczzlnCQ=;
	h=Date:To:From:Subject:Message-Id; b=GB6RE8Max6+cKoGEvR6CMrjskGX3o57wZeDYmLOxKHtV7yfdRFnP0CqTxWOflcVL9k6aOppU1+cYP2jrgTwEDdeaOt0cZo2WOQ8MSGzULLD8yS983GzhRBqiGygYTgbTgq69l4g6P2+LH1bMKdzeux/39G0Kj3oTHKUxXzKylA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WGnE6Blp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WGnE6Blp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D783C1F000E9;
	Thu,  6 Aug 2026 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786050007;
	bh=aCCuB6QIA9YFr99h4MJVDKMZIDLrAe9TBALs06+Acnc=;
	h=Date:To:From:Subject;
	b=WGnE6BlpXlAMINWPofgH3zl2+4S9+QDdIQ+KY/fL8jPI3dRpvMY1T5bAhPqIs/lpD
	 HDeJXHL8KfcoKcp7bjISM5ha+Dp7xBlBJWZm2o2O9Dwxjcz8AL5xCH+GrW5892NPMK
	 7mnP9ENfYTMTs0zcubya+FxcMtuJBCo6WtRmYeEA=
Date: Thu, 06 Aug 2026 14:00:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-khugepaged-swap-tests-without-swap.patch added to mm-new branch
Message-Id: <20260806210007.D783C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip khugepaged swap tests without swap
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-khugepaged-swap-tests-without-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-khugepaged-swap-tests-without-swap.patch

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
@@ -847,10 +869,16 @@ static void collapse_swapin_single_pte(s
 		return;
 	}
 
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
@@ -880,10 +908,16 @@ static void collapse_max_ptes_swap(struc
 		return;
 	}
 
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

selftests-mm-unpoison-pages-in-memory-failure-teardown.patch
selftests-mm-skip-cow-tmpfile-cases-when-fallocate-is-unsupported.patch
selftests-mm-skip-guard-hole-punch-test-if-madv_remove-is-unsupported.patch
selftests-mm-skip-khugepaged-swap-tests-without-swap.patch
selftests-mm-skip-hard-dirty-page-cache-test-on-nfs.patch
selftests-mm-retry-migration-failures-for-the-full-runtime.patch

