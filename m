Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702B15A7
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 01:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1+6LBg6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF580C433C9;
	Wed, 13 Dec 2023 01:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430445;
	bh=DlhNkiEPR+sseD/Z4JFYxxsth/eI9hv2u+4dL1IcmgA=;
	h=Date:To:From:Subject:From;
	b=1+6LBg6Bt6np8gDwjD3lnd5eGlGIiU81QdkmKWxpl5MakVmbtRlvDrn9TRJnlRTWf
	 xCRrbvMQFfvXh1lzROlKtKvT0li/FVLQsD9nitdYZb+DXACni5kC9Dk8ofcuTVNLng
	 RvwuehsUL80sDXq+12scDCIVok2eb0GGMPJ2ilmI=
Date: Tue, 12 Dec 2023 17:20:45 -0800
To: mm-commits@vger.kernel.org,npache@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-cow-print-ksft-header-before-printing-anything-else.patch removed from -mm tree
Message-Id: <20231213012045.AF580C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: cow: print ksft header before printing anything else
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-print-ksft-header-before-printing-anything-else.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: cow: print ksft header before printing anything else
Date: Wed, 6 Dec 2023 11:35:58 +0100

Doing a ksft_print_msg() before the ksft_print_header() seems to confuse
the ksft framework in a strange way: running the test on the cmdline
results in the expected output.

But piping the output somewhere else, results in some odd output,
whereby we repeatedly get the same info printed:
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	TAP version 13
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	TAP version 13
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	ok 1 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped out base page
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled

Doing the ksft_print_header() first seems to resolve that and gives us
the output we expect:
	TAP version 13
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	ok 1 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped out base page
	ok 2 No leak from parent into child
	# [RUN] Basic COW after fork() ... with THP
	ok 3 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped-out THP
	ok 4 No leak from parent into child
	# [RUN] Basic COW after fork() ... with PTE-mapped THP
	ok 5 No leak from parent into child

Link: https://lkml.kernel.org/r/20231206103558.38040-1-david@redhat.com
Fixes: f4b5fd6946e2 ("selftests/vm: anon_cow: THP tests")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-print-ksft-header-before-printing-anything-else
+++ a/tools/testing/selftests/mm/cow.c
@@ -1680,6 +1680,8 @@ int main(int argc, char **argv)
 {
 	int err;
 
+	ksft_print_header();
+
 	pagesize = getpagesize();
 	thpsize = read_pmd_pagesize();
 	if (thpsize)
@@ -1689,7 +1691,6 @@ int main(int argc, char **argv)
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
 
-	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
 		      ARRAY_SIZE(anon_thp_test_cases) * tests_per_anon_thp_test_case() +
 		      ARRAY_SIZE(non_anon_test_cases) * tests_per_non_anon_test_case());
_

Patches currently in -mm which might be from david@redhat.com are


