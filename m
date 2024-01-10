Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7164360B1
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1QcJqMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E76C43390;
	Wed, 10 Jan 2024 05:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704865455;
	bh=/Dew6+oBCJ7ats+z5Us50sdNodeP8a0aWPx5yHty3es=;
	h=Date:To:From:Subject:From;
	b=g1QcJqMouwmEK85GSk30G6tYnPguvW1ETc4W28kAA2MvbhdLELVrSdUSWwRqXjJqX
	 zGo62QlXcjHFJKhWcBY1PqfwjoGGtPe+/MIFjnfGeHMLxEg1Qvbuvm2oNdAd3D/TRp
	 ghbxAe288c2WwCN3LygErr+QXREwmw2Ss8QVuLYw=
Date: Tue, 09 Jan 2024 21:44:14 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,inwardvessel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-ksm_functional-prevent-unmapping-undefined-address.patch added to mm-unstable branch
Message-Id: <20240110054415.44E76C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/ksm_functional: prevent unmapping undefined address
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-ksm_functional-prevent-unmapping-undefined-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-ksm_functional-prevent-unmapping-undefined-address.patch

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

selftests-mm-ksm_functional-prevent-unmapping-undefined-address.patch

