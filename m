Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9121F6FBF;
	Fri,  6 Dec 2024 03:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457319; cv=none; b=AvEqjerlRIVUkrBNsUFDz6o+U9KxYCxPF+f7S2jWJBvWnxZppO93UbPfCta8uu83FvG4QKzviWF1NNbaWwh9uKh9RRyppdJ4ke9Ph+50N5amnW4n4LbckK8iQ3+72Z6YMOloeWdJd9FkJFA+X/tMPnZxvw2hqTbaTTnZ3UrbhKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457319; c=relaxed/simple;
	bh=elgyb1tTJ+zyNDVjId5k07Dggcma9j4o5EW6PzVhd+s=;
	h=Date:To:From:Subject:Message-Id; b=cApv7jsMREE202r7cCJutdu5rkcIaJQMxqw548yWIc99KSUe3jigOjkRhToTS0WQZspH01750PDBsjoqtP61uZ7HmMfMbhNVntzArqmGQ0dSElj3VwjChLEMSs1GgJGsSHcrs/6CKTM22uWY1g2Jac/LXiFjJ3Pm/dYUdjEqGiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UC+HLgUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UC+HLgUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58050C4CED1;
	Fri,  6 Dec 2024 03:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457319;
	bh=elgyb1tTJ+zyNDVjId5k07Dggcma9j4o5EW6PzVhd+s=;
	h=Date:To:From:Subject:From;
	b=UC+HLgUsA7VVdBY2yhe5U2qcvlrzmGk2+jhZBhv2Nwn3wIQBVk6QRItwclCvY9gEt
	 A2WbsU+40Lzx5MXs7bJm1E3LDUK9Tjt7+a1VfUJnMo2z0yCmzRSJrywTXny4MPEP9o
	 kAd1L7LCBKd/Bcp+I6Jt68wi5juK9ZGaZ5kaSPOc=
Date: Thu, 05 Dec 2024 19:55:18 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,ritesh.list@gmail.com,donettom@linux.ibm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftest-hugetlb_dio-fix-test-naming.patch removed from -mm tree
Message-Id: <20241206035519.58050C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest: hugetlb_dio: fix test naming
has been removed from the -mm tree.  Its filename was
     selftest-hugetlb_dio-fix-test-naming.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftest: hugetlb_dio: fix test naming
Date: Wed, 27 Nov 2024 16:14:22 +0000

The string logged when a test passes or fails is used by the selftest
framework to identify which test is being reported.  The hugetlb_dio test
not only uses the same strings for every test that is run but it also uses
different strings for test passes and failures which means that test
automation is unable to follow what the test is doing at all.

Pull the existing duplicated logging of the number of free huge pages
before and after the test out of the conditional and replace that and the
logging of the result with a single ksft_print_result() which incorporates
the parameters passed into the test into the output.

Link: https://lkml.kernel.org/r/20241127-kselftest-mm-hugetlb-dio-names-v1-1-22aab01bf550@kernel.org
Fixes: fae1980347bf ("selftests: hugetlb_dio: fixup check for initial conditions to skip in the start")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_dio.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftest-hugetlb_dio-fix-test-naming
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -76,19 +76,15 @@ void run_dio_using_hugetlb(unsigned int
 	/* Get the free huge pages after unmap*/
 	free_hpage_a = get_free_hugepages();
 
+	ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
+	ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
+
 	/*
 	 * If the no. of free hugepages before allocation and after unmap does
 	 * not match - that means there could still be a page which is pinned.
 	 */
-	if (free_hpage_a != free_hpage_b) {
-		ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
-		ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
-		ksft_test_result_fail(": Huge pages not freed!\n");
-	} else {
-		ksft_print_msg("No. Free pages before allocation : %d\n", free_hpage_b);
-		ksft_print_msg("No. Free pages after munmap : %d\n", free_hpage_a);
-		ksft_test_result_pass(": Huge pages freed successfully !\n");
-	}
+	ksft_test_result(free_hpage_a == free_hpage_b,
+			 "free huge pages from %u-%u\n", start_off, end_off);
 }
 
 int main(void)
_

Patches currently in -mm which might be from broonie@kernel.org are


