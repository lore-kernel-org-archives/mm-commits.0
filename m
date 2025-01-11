Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1D97E0FF
	for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 02:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736564164; cv=none; b=jVBx+z1XqgOUUwCh/sp8GMg87whZJxtl3GE3y6ttrCCa28bgEw8muafJf/S8/zOFItVPgaZM1jbyBgadFEwdmGpEhwYmNZ06oZLPYPRBjP8CoViVy8vnL8944128tpXX92sXt0xF23WAqPlS/G3zrFvbQWVJSvDrWtfPTDQLxrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736564164; c=relaxed/simple;
	bh=GF3bWI0ejqbwyWWiiJnbFlq6BWeV8zQSFYuHhvZ3aIE=;
	h=Date:To:From:Subject:Message-Id; b=Bdi8d6PA6W3UlVXP5Y6E87BMR8IGHCn4pPFgDDcpKUmQL3+i7PdRC8+aobAxa7vEq6rN4uskIcU6W15ONzhJkJseh/7b1kvi3Ta7eprXaEA0/tLTYLQ+RzkhnGaCerKnofXONw3BCLZV0LAgqQprEbwvI3SNBSl7Pl3SWQWCj88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmXsCElQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmXsCElQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D386C4CED6;
	Sat, 11 Jan 2025 02:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736564163;
	bh=GF3bWI0ejqbwyWWiiJnbFlq6BWeV8zQSFYuHhvZ3aIE=;
	h=Date:To:From:Subject:From;
	b=gmXsCElQYBUdybPclTfojgLt8HoV1/LGAaZkXE43IIK7GPaNDyV60gkJEpOYrRWzz
	 YWK5mul4ooytOGSlycKs5lxvNCaoFZh5Fjh7nHtbIj6/+93bfDOVC4GoEwopvlbK3w
	 LF5FjI+QF5KUFJDJaznbFJGYpR/s5nCugyEe8DGo=
Date: Fri, 10 Jan 2025 18:56:02 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shuah@kernel.org,riel@surriel.com,alexlzhu@fb.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch added to mm-unstable branch
Message-Id: <20250111025603.8D386C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add tests for splitting pmd THPs to all lower orders
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: add tests for splitting pmd THPs to all lower orders
Date: Fri, 10 Jan 2025 18:50:28 -0500

Kernel already supports splitting a folio to any lower order. Test it.

Link: https://lkml.kernel.org/r/20250110235028.96824-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   13 +++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -144,7 +144,7 @@ void split_pmd_zero_pages(void)
 	free(one_page);
 }
 
-void split_pmd_thp(void)
+void split_pmd_thp_to_order(int order)
 {
 	char *one_page;
 	size_t len = 4 * pmd_pagesize;
@@ -164,7 +164,7 @@ void split_pmd_thp(void)
 
 	/* split all THPs */
 	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
-		(uint64_t)one_page + len, 0);
+		(uint64_t)one_page + len, order);
 
 	for (i = 0; i < len; i++)
 		if (one_page[i] != (char)i)
@@ -174,7 +174,7 @@ void split_pmd_thp(void)
 	if (!check_huge_anon(one_page, 0, pmd_pagesize))
 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
 
-	ksft_test_result_pass("Split huge pages successful\n");
+	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
 	free(one_page);
 }
 
@@ -481,7 +481,7 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(4+9);
+	ksft_set_plan(1+9+2+9);
 
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
@@ -492,7 +492,10 @@ int main(int argc, char **argv)
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_zero_pages();
-	split_pmd_thp();
+
+	for (i = 0; i < 9; i++)
+		split_pmd_thp_to_order(i);
+
 	split_pte_mapped_thp();
 	split_file_backed_thp();
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-use-selftests-framework-to-print-test-result.patch
selftests-mm-add-tests-for-splitting-pmd-thps-to-all-lower-orders.patch

