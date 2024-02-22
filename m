Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C018480
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560064; cv=none; b=EjHpQFYuCmPGF8P2y9Rka8XC1uuWpHBe1EUE4hHRUuhN19BkdHAWzth1EA9dfkFh8nkpwA7DcayNo4ucLrlgfCqpG4F34L/A7ZTtgaEpBiFeiMKKx7kr2AgBAydxFicxULSTwU7qclWumuSpELtCzm/T69WhmmRxVlV4FYDyXeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560064; c=relaxed/simple;
	bh=IFA9Eyuv4IQ67WnIk9CHs12u0YpenosRm2E/KjsrZaM=;
	h=Date:To:From:Subject:Message-Id; b=KHwS8lXL8cqkACkAS/420nXpIZOaJdljt2wK4NSX/gerPTSNOmK6Qr+jVA4U8w802NfgOTEd730vUlW2N2bowWHRq37BQewPe16EHKFjiUUphDyGqel89bQQOfFez8LRaNiu8prsDwx0DYrdsl+bpGK6jCezTMDQi770TcbygNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R4n4r+rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R4n4r+rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05ADC43394;
	Thu, 22 Feb 2024 00:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560063;
	bh=IFA9Eyuv4IQ67WnIk9CHs12u0YpenosRm2E/KjsrZaM=;
	h=Date:To:From:Subject:From;
	b=R4n4r+rLG20gk3wAuvq7bXSPJuv2pXh2aRULgJDRfNiqbhXs6LlNIsZrKfFhIFJp1
	 WKTvkA8BSnV1q1/XehKSA5OLg1CY41XjhjkSBan1VoOIG8enO08JurccUstOQtS0Iy
	 BL7j+/pu+Hkm9CgZs17KOLDwtfsbyTAoAaZp2x8M=
Date: Wed, 21 Feb 2024 16:01:03 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,inwardvessel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-ksm_functional-prevent-unmapping-undefined-address.patch removed from -mm tree
Message-Id: <20240222000103.A05ADC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/ksm_functional: prevent unmapping undefined address
has been removed from the -mm tree.  Its filename was
     selftests-mm-ksm_functional-prevent-unmapping-undefined-address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: JP Kobryn <inwardvessel@gmail.com>
Subject: selftests/mm/ksm_functional: prevent unmapping undefined address
Date: Fri, 5 Jan 2024 12:24:01 -0800

Replace some goto statements with return statements so that unmap() is not
called on an undefined address.  This change is made so that unmap() can
only be reached after mmap() is called (and the address mentioned is
defined).  Returning MAP_FAILED seems acceptable since client code checks
for this value.

Link: https://lkml.kernel.org/r/20240105202401.28851-1-inwardvessel@gmail.com
Fixes: 42096aa24b82 ("selftest/mm: ksm_functional_tests: test in mmap_and_merge_range() if anything got merged")
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-ksm_functional-prevent-unmapping-undefined-address
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -155,12 +155,12 @@ static char *mmap_and_merge_range(char v
 	/* Stabilize accounting by disabling KSM completely. */
 	if (ksm_unmerge()) {
 		ksft_test_result_fail("Disabling (unmerging) KSM failed\n");
-		goto unmap;
+		return MAP_FAILED;
 	}
 
 	if (get_my_merging_pages() > 0) {
 		ksft_test_result_fail("Still pages merged\n");
-		goto unmap;
+		return MAP_FAILED;
 	}
 
 	map = mmap(NULL, size, PROT_READ|PROT_WRITE,
_

Patches currently in -mm which might be from inwardvessel@gmail.com are


