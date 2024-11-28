Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1CB9460;
	Thu, 28 Nov 2024 00:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754342; cv=none; b=efotmRdOMNVIz9lwnKRkp27pK3hVtKeJ/Y+U7fCd2RQVMXz38gO3qAIHz8PZpwuQEVl1xR0DenzMF0xhenKSDRIgBKsF1kQz9fWgRsFlKUedrQwNLgFWzd0lHh2GnmuXEzdK4NCm5WTPiEPtK8JauflJb4LbqypMgq8nGUufLr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754342; c=relaxed/simple;
	bh=oSzaIbkMZYJO2Tufkp+y03o80y7q4EZ0HofmEa7Y0eY=;
	h=Date:To:From:Subject:Message-Id; b=pBpR+8DH1Izy8TYPvFeuLcghpax3RwJ0+rGqOhysbK33S2M2y7X8PNAJuEDLx0xxmoTF579umnUGLQpxLzqNwFmYlUAiwX4rQZz61B0Qp/PhmQzKVmUZWflIMiIRhInBK4IizHvWoOcZsa0OQO9nbEIK1QFtKWP9emMFFUt6nFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ACH2yuBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ACH2yuBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFBAC4CECC;
	Thu, 28 Nov 2024 00:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732754342;
	bh=oSzaIbkMZYJO2Tufkp+y03o80y7q4EZ0HofmEa7Y0eY=;
	h=Date:To:From:Subject:From;
	b=ACH2yuBt0dZTLHVpbfN2ocpL1/eE51Himx4yqUevRA3uT+sw3HsgDBjzagG/5nke8
	 WiPu07chsKFGE4jeOC2nSkg2M8B1b2WLWkbc53Crz32sK/EHFPW5aSkniZqLefn6qw
	 E6nXBF0C/GmnK8sAJFpTqUdQIM9s1Q8J8lZO9h9o=
Date: Wed, 27 Nov 2024 16:39:01 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,ritesh.list@gmail.com,donettom@linux.ibm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-hugetlb_dio-fix-test-naming.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128003901.EEFBAC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest: hugetlb_dio: fix test naming
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftest-hugetlb_dio-fix-test-naming.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-hugetlb_dio-fix-test-naming.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
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

selftest-hugetlb_dio-fix-test-naming.patch

